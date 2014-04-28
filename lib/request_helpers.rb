module Sinatra
  module RequestHelpers

    FORMATS = %w(svg png gif jpeg)

    # Internal: Get the expected barcode symbology
    #
    # Returns a String
    def symbology 
      params[:type].downcase
    end

    # Internal: Helper to retrieve the expected barcode response format 
    #
    # Returns a String
    def format
      File.extname(request.path).downcase[1..-1]
    end

    # Internal: Requires that the symbology and format be supported
    #
    # Returns nothing
    # Halts with a 415
    def supported!
      unless FORMATS.include?(format) && BarcodeFactory.supported?(symbology)
        unsupported_type
      end
    end
  end

  helpers RequestHelpers
end

