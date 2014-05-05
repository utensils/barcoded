class Barcoded < Sinatra::Base
  helpers Sinatra::RequestHelpers
  helpers Sinatra::ResponseHelpers
  include Sinatra::ExceptionHandler

  enable :logging

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

  get '/ping' do
    healthy_response
  end

  private

  def create_barcode(encoding, value)
    BarcodeFactory.build(encoding, value)
  end

end
