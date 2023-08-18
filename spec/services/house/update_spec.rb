# frozen_string_literal: true

require 'rails_helper'

RSpec.describe House::Update do
  let!(:creator) { create(:user) }

  let(:house_params) do
    {
      id: 1,
      creator_id: creator.id,
      address: '123 Main St',
      latitude: 42.123,
      longitude: -71.456
    }
  end

  subject { described_class.new(house_params) }

  describe '#call' do
    context 'when house exists and params are valid' do
      let(:existing_house) { create(:house, id: 1, creator_id: creator.id) }

      it 'updates the house' do
        allow(House).to receive(:find_by).and_return(existing_house)
        allow(existing_house).to receive(:update).and_return(true)

        result = subject.call

        expect(result).to be_a Dry::Monads::Success
        expect(result.value!).to eq existing_house
      end
    end

    context 'when house does not exist' do
      it 'returns a failure with "House not found"' do
        allow(House).to receive(:find_by).and_return(nil)

        result = subject.call

        expect(result).to be_a Dry::Monads::Failure
        expect(result.failure).to eq 'House not found'
      end
    end

    context 'when params are invalid' do
      it 'returns a failure with validation errors' do
        allow(HouseUpdateSchema).to receive(:call).and_return(double(failure?: true, errors: ['address is missing']))
        allow(House).to receive(:find_by).and_return(nil)

        result = subject.call

        expect(result).to be_a Dry::Monads::Failure
        expect(result.failure).to eq ['address is missing']
      end
    end

    context 'when house update fails' do
      let(:existing_house) { create(:house, id: 1, creator_id: creator.id) }

      it 'returns a failure with house errors' do
        allow(House).to receive(:find_by).and_return(existing_house)
        allow(existing_house).to receive(:update).and_return(false)
        allow(existing_house).to receive(:errors).and_return(['Update failed'])

        result = subject.call

        expect(result).to be_a Dry::Monads::Failure
        expect(result.failure).to eq ['Update failed']
      end
    end
  end
end
