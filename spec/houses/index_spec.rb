require 'rails_helper'

RSpec.describe HousesController, type: :controller do
  let(:user)  { create(:user) }
  let(:house) { create(:house) }

  let(:params) do
    { topRightCoords: '56.84806990247708,61.06336361948214',
      bottomLeftCoords: '56.78970451254612,60.16523129526338' }
  end

  describe 'GET #index' do
    let!(:house) { create(:house) }

    it 'returns a successful response' do
      get(:index, params:)
      expect(response).to have_http_status(:success)
    end

    it 'assigns houses as @houses' do
      get(:index, params:)
      expect(assigns(:houses)).to eq([house])
    end
  end
end
