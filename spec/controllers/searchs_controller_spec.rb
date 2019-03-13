require 'rails_helper'

RSpec.describe SearchsController, type: :controller do
  describe 'GET #index' do
    context 'if valid search query' do
      let(:sphinx_service) { double(Services::SearchSphinxService) }

      before do
        allow(Services::SearchSphinxService).to receive(:new).and_return(sphinx_service)
      end

      it 'searches for result' do
        expect(sphinx_service).to receive(:search).with('Global', 'test', '1')
        get :index, params: {category: 'Global', search: 'test', page: '1'}
      end

      it "should render :index" do
        allow(sphinx_service).to receive(:search).with('Global', 'test', '1').and_return([])
        get :index, params: {category: 'Global', search: 'test', page: '1'}

        expect(response).to render_template(:index)
      end

    end
  end
end
