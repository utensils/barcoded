require 'spec_helper'

describe Barcoded do
  context 'with unsupported format' do
    it 'will return 415 Unsupported Media Type' do
      get '/v1/1235ABC.gif?type=code-128'
      expect(last_response.status).to eq 415
    end
  end

  context 'with unsupported symbology' do
    it 'will return 415 Unsupported Media Type' do
      get '/v1/1235ABC.svg?type=code-1337'
      expect(last_response.status).to eq 415
    end
  end

  it 'will return 501 Not Implemented' do
    get '/v1/1235ABC.svg?type=code-128'
    expect(last_response.status).to eq 501
  end
end
