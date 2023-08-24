# frozen_string_literal: true

require 'rails_helper'

RSpec.describe House::Delete do
  let!(:creator)       { create(:user) }
  let(:existing_house) { create(:house, creator_id: creator.id) }

  let(:house_params) do
    {
      id: existing_house.id,
      creator_id: creator.id
    }
  end

  subject { described_class.new(house_params, creator.id) }

  describe '#call' do
    context 'when house exists' do
      it 'deletes the house and returns success message' do
        allow(House).to receive(:find_by).and_return(existing_house)
        allow(existing_house).to receive(:delete).and_return(true)

        result = subject.call

        expect(result).to be_a Dry::Monads::Success
        expect(result.value!).to eq 'Deleted successfully'
      end
    end

    context 'when house does not exist' do
      it 'returns a failure with error message' do
        allow(House).to receive(:find_by).and_return(nil)

        result = subject.call

        expect(result).to be_a Dry::Monads::Failure
        expect(result.failure).to eq "The user's registered home was not found"
      end
    end

    context 'when house deletion fails' do
      it 'returns a failure with house errors' do
        allow(House).to receive(:find_by).and_return(existing_house)
        allow(existing_house).to receive(:delete).and_return(false)
        allow(existing_house).to receive(:errors).and_return(['Deletion failed'])

        result = subject.call

        expect(result).to be_a Dry::Monads::Failure
        expect(result.failure).to eq ['Deletion failed']
      end
    end
  end
end
