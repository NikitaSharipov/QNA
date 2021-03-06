require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it_behaves_like 'To save a new object', let(:params) { { question_id: question, answer: attributes_for(:answer) } }, let(:object_class) { Answer }, let(:object) { 'answer' }

      it 'saves a new answer belongs to user in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'does not save a new object', let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid) } }, let(:object_class) { Answer }

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    context 'Authenticated user tries' do
      before { login(user) }

      let!(:another_user) { create(:user) }
      let!(:foreign_answer) { create(:answer, question: question, author: another_user) }

      it_behaves_like 'To delete the object', let(:object) { answer }, let(:object_class) { Answer }

      it 'deletes not his question' do
        expect { delete :destroy, params: { id: foreign_answer } }.not_to change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    it 'Not Authenticated user tries deletes a answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated ' do
      let(:link) { create(:link, linkable: answer) }
      let!(:another_user) { create(:user) }
      let!(:foreign_answer) { create(:answer, question: question, author: another_user) }

      before { login(user) }

      context 'answer author tries to update answer' do
        context 'with valid attributes' do
          it_behaves_like 'To update the object', let(:params) { { question_id: question, answer: attributes_for(:answer) } }, let(:object) { answer }
          it_behaves_like 'To change the object attributes', let(:params) { { answer: { body: 'new_body' } } }, let(:object) { answer }
        end

        context 'with invalid attributes' do
          it 'does not change answer attributes' do
            expect do
              patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            end.to_not change(answer, :body)
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            expect(response).to render_template :update
          end
        end
      end

      it 'user tries to update not his answer' do
        patch :update, params: { id: foreign_answer, answer: { body: 'new body' } }, format: :js
        foreign_answer.reload
        expect(foreign_answer.body).to_not eq 'new body'
      end

      it 'renders shared/delete_link' do
        put :update, params: { id: answer, answer: { links_attributes: { id: link.id, "_destroy" => true } } }, format: :js
        expect(response).to render_template "shared/delete_link"
      end
    end
  end

  describe 'PATCH #best' do
    context 'Authenticated ' do
      let!(:another_user) { create(:user) }
      let!(:foreign_answer) { create(:answer, question: question, author: another_user) }

      before { login(user) }

      it 'change best question' do
        post :best, params: { id: answer }, format: :js
        expect { answer.reload }.to change(answer, :best?)
      end

      it 'renders best template' do
        post :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end

      it "user try's to mark as best not his question" do
        post :best, params: { id: foreign_answer }, format: :js
        expect { answer.reload }.not_to change(answer, :best?)
      end
    end
  end

  it_behaves_like 'Voted' do
    let(:user) { create :user }
    let(:another_user) { create :user }
    let(:question) { create(:question, author: another_user) }
    let(:votable) { create(:answer, question: question, author: another_user) }
  end

  it_behaves_like 'Commented' do
    let(:user) { create :user }
    let(:question) { create(:question, author: user) }
    let(:commented) { create(:answer, question: question, author: user) }
  end
end
