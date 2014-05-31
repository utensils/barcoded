require 'spec_helper'

describe Barcoded do
  describe 'POST /barcodes' do
    valid_data = {
        'bookland'          => '968-26-1240-3',
        'code128a'          => 'ABC123',
        'code128b'          => 'ABC123',
        'code128c'          => '123456',
        'code25'            => '0123456789',
        'code25interleaved' => '12345670',
        'code39'            => 'TEST8052',
        'code93'            => 'TEST93',
        'ean13'             => '123456789012',
        'ean8'              => '1234567',
        'iata'              => '0123456789',
        'qr'                => 'UtensilsUnion',
        'supp2'             => '12',
        'supp5'             => '12345',
        'upca'              => '12345678999'
    }

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

      valid_data.each do |encoding, data|
        context 'with valid data' do
          let(:encoding) { encoding }
          let(:data) { data }

          it 'will return a valid barcode' do
            post '/barcodes',barcode_request, headers
            expect(response['location']).to eq "http://example.org/img/#{encoding}/#{data}.#{format}"
          end

          it 'will return an svg file' do
            get "http://example.org/img/#{encoding}/#{data}.svg"
            expect(last_response.status).to eq 200
          end

          it 'will return an png file' do
            get "http://example.org/img/#{encoding}/#{data}.png"
            expect(last_response.status).to eq 200
          end

          it 'will return an jpg file' do
            get "http://example.org/img/#{encoding}/#{data}.jpg"
            expect(last_response.status).to eq 200
          end

          it 'will return an gif file' do
            get "http://example.org/img/#{encoding}/#{data}.gif"
            expect(last_response.status).to eq 200
          end

        end
      end

      it 'will support Cross Origin Resource Sharing' do
        ENV['RACK_CORS']            = 'enabled'
        ENV['RACK_CORS_ORIGINS']    = 'http://utensils.io/'
        headers['HTTP_ORIGIN']      = 'http://utensils.io/'
        headers['HTTP_USER_AGENT']  = 'Rspec'
        post '/barcodes', barcode_request, headers
        expect(last_response.headers['Access-Control-Allow-Origin']).to eq 'http://utensils.io/'
      end

      it 'will deny Cross Origin Resource Sharing' do
        ENV['RACK_CORS']            = 'disabled'
        headers['HTTP_ORIGIN']      = 'http://utensils.io/'
        headers['HTTP_USER_AGENT']  = 'Rspec'
        post '/barcodes', barcode_request, headers
        expect(last_response.headers['Access-Control-Allow-Origin']).to be_nil
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
          { encoding: encoding, format: format, data: data }.to_xml(root: :barcode, skip_types: true)
        end
      end
    end

    context 'with Content Type application/xml' do
      it_behaves_like 'a supported content type' do
        let(:content_type) { 'application/xml' }
        let(:accept) { 'application/xml' }
        let(:barcode_request) do
          { encoding: encoding, format: format, data: data }.to_xml(root: :barcode, skip_types: true)
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

  end
end
