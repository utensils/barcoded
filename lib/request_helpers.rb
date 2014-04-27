module Sinatra
  module RequestHelpers

    FORMATS     = %w(svg png gif jpeg)
    SYMBOLOGIES = %w(bookland
                     code-128
                     code-25
                     code-39
                     code-93
                     ean-8
                     ean-13
                     gs1-128
                     iata
                     qr
                     supp-2
                     supp-5
                     upc-a)

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
      unless FORMATS.include?(format) && SYMBOLOGIES.include?(symbology)
        unsupported_type
      end
    end
  end

  helpers RequestHelpers
end

