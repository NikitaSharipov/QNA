require 'rails_helper'

RSpec.describe SearchsController, type: :controller do
  describe 'GET #index' do
    context 'if valid search query' do
      it "should render :index" do
        get :index, params: {category: 'Global', search: 'test', page: '1'}

        expect(response).to render_template(:index)
      end
    end
  end
end
