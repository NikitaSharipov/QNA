require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it_behaves_like 'To save a new object', let(:params) { { question: attributes_for(:question) } }, let(:object_class) { Question }, let(:object) { 'question' }

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'does not save a new object', let(:params) { { question: attributes_for(:question, :invalid) } }, let(:object_class) { Question }

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:link) { create(:link, linkable: question) }

    before { login(user) }
    context 'with valid attributes' do
      it_behaves_like 'To update the object', let(:params) { { question: attributes_for(:question) } }, let(:object) { question }
      it_behaves_like 'To change the object attributes', let(:params) { { question: { title: 'new_title', body: 'new_body' } } }, let(:object) { question }

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let!(:old_params) { { title: question.title, body: question.body } }
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq old_params[:title]
        expect(question.body).to eq old_params[:body]
      end

      it_behaves_like 'To render update view', let(:params) { { question: attributes_for(:question, :invalid) } }, let(:object) { question }

      it 'renders shared/delete_link' do
        put :update, params: { id: question, question: { links_attributes: { id: link.id, "_destroy" => true } } }, format: :js
        expect(response).to render_template "shared/delete_link"
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }

    context 'Authenticated user tries' do
      before { login(user) }

      let!(:another_user) { create(:user) }
      let!(:foreign_question) { create(:question, author: another_user) }

      it_behaves_like 'To delete the object', let(:object) { question }, let(:object_class) { Question }

      it 'deletes not his question' do
        expect { delete :destroy, params: { id: foreign_question } }.not_to change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    it 'Not Authenticated user tries deletes a question' do
      expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
    end
  end

  describe 'GET #new' do
    before do
      login user
      get :new
    end

    it 'assigns new link for question' do
      expect(assigns(:exposed_question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new link for answer' do
      expect(assigns(:exposed_answer).links.first).to be_a_new(Link)
    end
  end

  it_behaves_like 'Voted' do
    let(:user) { create :user }
    let(:another_user) { create :user }
    let(:votable) { create(:question, author: another_user) }
  end

  it_behaves_like 'Commented' do
    let(:user) { create :user }
    let(:commented) { create(:question, author: user) }
  end
end
