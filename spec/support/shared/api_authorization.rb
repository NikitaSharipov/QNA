shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: {access_token: '1234'}, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Request returns 200' do
  it 'returns 200 status code' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Returns list of object' do
  it 'returns list of object' do
    expect(json_object.size).to eq 2
  end
end

shared_examples_for 'Returns all public fields' do
  it 'returns all public fields' do
    fields.each do |attr|
      expect(object_response[attr]).to eq object.send(attr).as_json
    end
  end
end
