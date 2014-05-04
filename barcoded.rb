class Barcoded < Sinatra::Base
  helpers Sinatra::RequestHelpers
  helpers Sinatra::ResponseHelpers

  enable :logging

  INVALID_DATA = 'The data is invalid for the selected encoding.'

  before '/barcodes' do
    valid_request!
    supported!
  end

  error ArgumentError do
    bad_request(INVALID_DATA)
  end

  error do
    bad_request
  end

  post '/barcodes' do
    content_type 'application/json'
    barcode = create_barcode(encoding, data)
    created(barcode)
  end

  get '/img/*/*.*' do |encoding, data, format|
    barcode = create_barcode(encoding, data)
    image   = BarcodeImageFactory.build(barcode, format)
    send_image image, format
  end

  private

  def create_barcode(encoding, value)
    BarcodeFactory.build(encoding, value)
  end

end
