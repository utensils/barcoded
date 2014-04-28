require 'spec_helper'

describe Barcoded do
  context 'with unsupported format' do
    it 'will return 415 Unsupported Media Type' do
      get '/v1/1235ABC.pdf?type=code-128'
      expect(last_response.status).to eq 415
    end
  end

  context 'with unsupported symbology' do
    it 'will return 415 Unsupported Media Type' do
      get '/v1/1235ABC.png?type=code-1337'
      expect(last_response.status).to eq 415
    end
  end

  shared_examples 'an inline image resource' do
    let(:content_type) { '' }
    let(:format)       { '' }

    it 'will return an image' do
      get "/v1/1235ABC.#{format}?type=code128a"
      expect(last_response.status).to eq 200
    end
  end

  context '.png' do
    it_behaves_like 'an inline image resource' do
      let(:content_type) { 'image/png' }
      let(:format)       { 'png' }
    end
  end

  context '.gif' do
    it_behaves_like 'an inline image resource' do
      let(:content_type) { 'image/gif' }
      let(:format)       { 'gif' }
    end
  end

  context '.jpg' do
    it_behaves_like 'an inline image resource' do
      let(:content_type) { 'image/jpg' }
      let(:format)       { 'jpg' }
    end
  end
end
