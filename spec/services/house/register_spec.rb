# frozen_string_literal: true

require 'rails_helper'

RSpec.describe House::Register, type: :service do
  let!(:creator) { create(:user) }

  let(:valid_house_data) do
    {
      creator_id: creator.id,
      address:   '123 Main St',
      latitude:  '40.7128',
      longitude: '-74.0060'
    }
  end

  let(:invalid_house_data) do
    {
      creator_id: creator.id.to_s,
      address:   '123 Main St',
      latitude:  'fourty',
      longitude: 'minus seventy four'
    }
  end

  describe '#call' do
    context 'with valid data' do
      it 'first time creates, second time fails' do
        result1 = described_class.new(valid_house_data, creator.id).call
        result2 = described_class.new(valid_house_data, creator.id).call

        expect(result1).to be_success
        expect(result2).to be_failure
        expect(result2.failure).to have_key(:address)
      end
    end

    context 'with invalid data' do
      it 'respond with fail' do
        result = described_class.new(invalid_house_data, creator.id).call

        expect(result).to be_failure

        errors = result.failure.to_h
        expect(errors).not_to have_key(:creator_id)
        expect(errors).not_to have_key(:address)
        expect(errors).to have_key(:latitude)
        expect(errors).to have_key(:longitude)
      end
    end
  end
end
