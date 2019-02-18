require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }


  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end


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
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:exposed_question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

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

      it 're-renders edit view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end

      it 'renders shared/delete_link' do
        put :update, params: { id: question, question: { links_attributes: { id: link.id, "_destroy" => true }} }, format: :js
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

      it 'deletes his question' do
        expect { delete :destroy, params: { id: question } }.to change(user.questions, :count).by(-1)
      end

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
