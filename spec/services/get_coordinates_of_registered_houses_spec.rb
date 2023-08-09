# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetCoordinatesOfRegisteredHouses, type: :service do
  let(:valid_search_area) do
    {
      bottom_left: [0.0, 0.0],
      top_right: [1.0, 1.0]
    }
  end

  let(:invalid_search_area) do
    {
      bottom_left: [0.0, 0.0],
      top_right: [1.0]
    }
  end

  describe '#call' do
    context 'with valid home search area' do
      let!(:house_1) { create(:house, address: '1', location: 'POINT(0 0)') }
      let!(:house_2) { create(:house, address: '2', location: 'POINT(2 2)') }

      it 'returns houses within the search area' do
        result = described_class.new(valid_search_area).call

        expect(result).to be_success
        expect(result.value!).to include(house_1)
        expect(result.value!).not_to include(house_2)

      end
    end

    context 'with invalid home search area' do
      it 'returns failure with validation errors' do
        result = described_class.new(invalid_search_area).call

        expect(result).to be_failure
        expect(result.failure.to_h).to have_key(:top_right)
      end
    end
  end
end
