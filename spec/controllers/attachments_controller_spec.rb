require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do

    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_file, author: user) }
    let!(:another_user) { create(:user) }
    let!(:foreign_question) { create(:question, :with_file, author: another_user) }

    context 'Authenticated user tries' do

      before { login(user) }

      it 'deletes his attachment' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'deletes not his attachment' do
        expect { delete :destroy, params: { id: foreign_question.files.first.id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first.id }, format: :js
        expect(response).to render_template :destroy
      end

    end

    it 'Not Authenticated user tries deletes a attachment' do
      expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
    end

  end

end
