require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 2, question: question, author: user) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request returns 200'

      it_behaves_like 'Returns list of object', let(:json_object) { json['questions'] }

      it_behaves_like 'Returns all public fields', let(:fields) { %w[id title body created_at updated_at] },
                      let(:object_response) { question_response }, let(:object) { question }

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Returns list of object', let(:json_object) { question_response['answers'] }
        it_behaves_like 'Returns all public fields', let(:fields) { %w[id body created_at updated_at] },
                        let(:object_response) { answer_response }, let(:object) { answer }
      end
    end
  end

  describe 'GET /api/v1/question/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:question_response) { json['question'] }
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request returns 200'

      it_behaves_like 'Returns all public fields', let(:fields) { %w[id title body created_at updated_at] },
                      let(:object_response) { question_response }, let(:object) { question }

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      it 'contains links object' do
        expect(question_response['links'].count).to eq question.links.count
      end

      it 'contains comment object' do
        expect(question_response['comments'].count).to eq question.comments.count
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions" }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    before { post api_path, params: { access_token: access_token.token, 'question' => attributes_for(:question) } }

    it_behaves_like 'Request returns 200'
  end

  describe 'UPDATE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:access_token)    { create(:access_token) }
    let(:api_path)        { "/api/v1/questions/#{question.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable', let(:method) { :patch }

    context 'authorized' do
      before { patch api_path, params: { access_token: access_token.token, question: { title: 'Title_new', body: 'Body_new' } } }

      it_behaves_like 'Request returns 200'

      it 'update the question' do
        question.reload
        expect(question.title).to eq 'Title_new'
        expect(question.body).to eq 'Body_new'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:access_token)    { create(:access_token) }
    let(:api_path)        { "/api/v1/questions/#{question.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable', let(:method) { :delete }

    it 'delete the question' do
      expect { delete api_path, params: { access_token: access_token.token } }.to change(Question, :count).by(-1)
    end
  end
end
