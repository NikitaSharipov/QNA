require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question, author: user) }
      let(:answer) { answers.first}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }


      it_behaves_like 'Request returns 200'

      it_behaves_like 'Returns list of object', let(:json_object) {json['answers']}

      it_behaves_like 'Returns all public fields', let(:fields) {%w[id body created_at updated_at]},
        let(:object_response) {json['answers'].first}, let(:object) {answer}
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user)            { create(:user) }
    let(:question)        { create(:question, author: user) }
    let(:answer_response) { json['answer'] }
    let!(:answer)   { create(:answer, question: question, author: user) }
    let!(:links)    { create_list(:link, 3, linkable: answer) }
    let!(:comment) { create(:comment, commentable: answer, user: user) }
    let(:api_path)        { "/api/v1/answers/#{answer.id}" }
    let(:access_token)    { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end


    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request returns 200'

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains links object' do
        expect(answer_response['links'].count).to eq answer.links.count
      end

      it 'contains comment object' do
        expect(answer_response['comments'].count).to eq answer.comments.count
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user)         { create(:user) }
    let(:question)     { create(:question, author: user) }
    let(:api_path)     { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create(:access_token) }
    let(:headers) {{"ACCEPT" => 'application/json'}}

    it 'ddd' do
      send :post, "/api/v1/questions/#{question.id}/answers", {:params=>{:access_token=>'1234'}}
    end


    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    before { post api_path, params: { access_token: access_token.token, 'answer' => attributes_for(:answer) } }

    it_behaves_like 'Request returns 200'
  end

  describe 'UPDATE /api/v1/answers/:id' do
    let(:user)            { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer)   { create(:answer, question: question, author: user) }
    let(:access_token)    { create(:access_token) }
    let(:api_path)        { "/api/v1/answers/#{answer.id}" }
    let(:headers) {{"ACCEPT" => 'application/json'}}

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      before { patch api_path, params: { access_token: access_token.token, answer: {body: 'Body_new' } } }

      it_behaves_like 'Request returns 200'

      it 'update answer' do
        answer.reload
        expect(answer.body).to eq 'Body_new'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user)          { create(:user) }
    let(:question)      { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:access_token)  { create(:access_token) }
    let(:api_path)      { "/api/v1/answers/#{answer.id}"  }
    let(:headers) {{"ACCEPT" => 'application/json'}}

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it 'returns 200 status' do
      delete api_path, params: { access_token: access_token.token }
      expect(response).to be_successful
    end

    it 'delete the object' do
      expect { delete api_path, params: { access_token: access_token.token } }.to change(Answer, :count).by(-1)
    end

  end

end
