require 'spec_helper'

describe Barcoded do
  describe 'POST /barcodes' do
    shared_examples 'a supported content type' do
      let(:encoding) { 'code-128a' }
      let(:format)   { 'png' }
      let(:data)     { '123ABC' }

      let(:headers) { { 'CONTENT_TYPE' => content_type, 'HTTP_ACCEPT' => accept } }

      context 'with unsupported format' do
        let(:format) { 'jar' }

        it 'will return 415 Unsupported Media Type' do
          post '/barcodes', barcode_request, headers
          expect(last_response.status).to eq 415
          expect(response['error']).to eq Barcoded::UNSUPPORTED_FORMAT
        end
      end

      context 'with unsupported encoding' do
        let(:encoding) { 'code-1337' }

        it 'will return 415 Unsupported Media Type' do
          post '/barcodes', barcode_request, headers
          expect(last_response.status).to eq 415
          expect(response['error']).to eq Barcoded::UNSUPPORTED_ENCODING
        end
      end

      context 'with invalid data' do
        let(:encoding) { 'code-128c' }

        it 'will return 400 Bad Request' do
          post '/barcodes', barcode_request, headers
          expect(last_response.status).to eq 400
          expect(response['error']).to eq Barcoded::INVALID_DATA
        end
      end

      it 'will return a 201 Created' do
        post '/barcodes', barcode_request, headers
        expect(last_response.status).to eq 201
        expect(response['location']).to_not be_nil
      end
    end

    context 'with Content Type application/json' do
      it_behaves_like 'a supported content type' do
        let(:content_type) { 'application/json' }
        let(:accept) { 'application/json' }
        let(:barcode_request) do
          { encoding: encoding, format: format, data: data }.to_json
        end
      end
    end

    context 'with Content Type application/x-www-form-urlencoded' do
      it_behaves_like 'a supported content type' do
        let(:content_type) { 'application/x-www-form-urlencoded' }
        let(:accept) { '*/*' }
        let(:barcode_request) do
          { encoding: encoding, format: format, data: data }
        end
      end
    end

    context 'with Content Type text/xml' do
      it_behaves_like 'a supported content type' do
        let(:content_type) { 'text/xml' }
        let(:accept) { 'text/xml' }
        let(:barcode_request) do
          { encoding: encoding, format: format, data: data }.to_xml(:root => :barcode, :skip_types => true)
        end
      end
    end

    context 'with Content Type application/xml' do
      it_behaves_like 'a supported content type' do
        let(:content_type) { 'application/xml' }
        let(:accept) { 'application/xml' }
        let(:barcode_request) do
          { encoding: encoding, format: format, data: data }.to_xml(:root => :barcode, :skip_types => true)
        end
      end
    end

    shared_examples 'a required parameter' do
      let(:encoding) { 'code-128a' }
      let(:format)   { 'png' }
      let(:data)     { '123ABC' }

      let(:barcode_request) do
        { encoding: encoding, format: format, data: data }
      end

      context 'when missing' do
        it 'will return 400 Bad Request' do
          post '/barcodes', barcode_request
          expect(last_response.status).to eq 400
          expect(response['error']).to eq Barcoded::MISSING_REQUIRED_PARAMS
        end
      end
    end

    describe 'encoding' do
      it_behaves_like 'a required parameter' do
        let(:encoding) { nil }
      end
    end

    describe 'format' do
      it_behaves_like 'a required parameter' do
        let(:format) { nil }
      end
    end

    describe 'data' do
      it_behaves_like 'a required parameter' do
        let(:data) { nil }
      end
    end
  end

  describe 'GET /img/:encoding/:data.:format' do
    shared_examples 'an inline image resource' do
      let(:content_type) { '' }
      let(:format)       { '' }

      it 'will return an image' do
        get "/img/code128a/1235ABC.#{format}"
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

    context '.svg' do
      it_behaves_like 'an inline image resource' do
        let(:content_type) { 'image/svg+xml' }
        let(:format)       { 'svg' }
      end
    end

    context 'with a bad request' do
      it 'will return 400 Bad Request' do
        get '/img/code128c/1235ABC.png'
        expect(last_response.status).to eq 400
      end
    end

    context 'with an unexpected server error' do
      before do
        any_instance_of(Barcoded) do |klazz|
          stub(klazz).create_barcode(anything, anything) { raise Exception }
        end
      end

      it 'will return 500 Server Error' do
        get '/img/code128c/1235ABC.png'
        expect(last_response.status).to eq 500
      end
    end

    describe 'GET /ping' do
      it 'responds with pong' do
        get '/ping'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq 'pong'
      end
    end

    describe 'GET /symbologies' do
      it 'responds with a JSON array of symbologies' do
        get '/symbologies'
        expect(last_response.status).to eq 200
        expect(json_response).to eq BarcodeFactory.supported_encodings.map { |symbology| {'symbology' => symbology}}
      end
    end

  end
end
