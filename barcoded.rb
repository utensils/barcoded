class Barcoded < Sinatra::Base
  helpers Sinatra::RequestHelpers
  helpers Sinatra::ResponseHelpers
  helpers Sinatra::MimeTypes

  enable :logging

  INVALID_DATA = 'The data is invalid for the selected encoding.'

  error ArgumentError do
    bad_request(INVALID_DATA)
  end

  before '/barcodes' do
    normalize_params!
    valid_request!
    supported!
  end

  post '/barcodes' do
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
