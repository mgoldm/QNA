shared_examples_for 'API index' do

  before { do_request(method, api_path, params: {access_token: access_token}, headers: headers)
  }
  it 'return status 200' do
    expect(response).to be_successful
  end

  it 'returns list of users' do
    expect(json['users'].size).to eq 3
  end

  it 'return all public fields' do
    %w[id email admin].each do |attr|
      expect(json['users'].first[attr]).to eq users.first.send(attr).as_json
    end
  end
end
