require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer belongs to user in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'saves a new answer belongs to question in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end


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

      it 'deletes his answer' do
        expect { delete :destroy, params: { id: answer } }.to change(user.answers, :count).by(-1)
      end

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

      let!(:another_user) { create(:user) }
      let!(:foreign_answer) { create(:answer, question: question, author: another_user) }

      before { login(user) }

      context 'answer author tries to update answer' do

        context 'with valid attributes' do
          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            expect(response).to render_template :update
          end
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

end
