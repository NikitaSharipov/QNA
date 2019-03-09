require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let!(:user) { create(:user)}
    let!(:user_not_author) { create(:user)}
    let!(:question) { create(:question, author: user)}

    context 'if authorized user not have subscription' do
      before { login(user_not_author) }

      it_behaves_like'To save a new object', let(:methods) {:create}, let(:params){ {question_id: question.id} }, let(:object_class) {user_not_author.subscriptions}
    end

    context 'if authorized user have subscription already' do
      before { login(user) }

      it_behaves_like'does not save a new object', let(:params){ {question_id: question.id} }, let(:object_class) {user_not_author.subscriptions}

      it 'render status 422 if subscribe already exist' do
        post :create, params: { question_id: question.id }, format: :js
        expect(response).to have_http_status 422
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user)}
    let!(:question) { create(:question, author: user)}

    context 'if authorized user' do
      before { login(user) } # because user is author, get subscribe automatically, by after_commit adding

      it_behaves_like'To delete the object', let(:object){user.subscriptions.last.id}, let(:object_class){user.subscriptions}

    end
  end
end
