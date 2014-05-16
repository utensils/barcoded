module Sinatra
  module ExceptionHandler
    INVALID_DATA = 'The data is invalid for the selected encoding.'

    def handle_exception!(ex)
      case ex 
      when ArgumentError, InvalidBarcodeData
        bad_request(INVALID_DATA)
      else
        super(ex)
      end
    end
  end
end
