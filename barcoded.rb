class Barcoded < Sinatra::Base
  helpers Sinatra::RequestHelpers
  helpers Sinatra::ResponseHelpers

  enable :logging

  before do
    supported!
  end

  get '/v1/*' do
    begin
      barcode = BarcodeFactory.build(symbology, value)
      image   = BarcodeImageFactory.build(barcode, format)
      send_image barcode, format
    rescue ArgumentError => e
      logger.error(e)
      halt 400
    end
  end

end
