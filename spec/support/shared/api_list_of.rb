# frozen_string_literal: true

shared_examples_for 'API list of' do
  it 'returns list of comments' do
    expect(parent_response.size).to eq 3
  end

  it 'returns all public fields' do
    mas.each do |attr|
      expect(json_response[attr]).to eq type.send(attr).as_json
    end
  end
end
