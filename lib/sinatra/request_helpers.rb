module Sinatra
  module RequestHelpers
    # Internal: The requested barcode encoding
    #
    # Returns a String
    def encoding
      (params['encoding'] || '').downcase
    end

    # Internal: The value to encode
    #
    # Returns a String
    def data
      params['data']
    end

    # Internal: Helper to retrieve the barcode response format
    #
    # Returns a String
    def format
      (params['format'] || '').downcase
    end

    SUPPORTED_OPTIONS = %w(height width)
    def options
      options = (params['options'] || params).slice(*SUPPORTED_OPTIONS).symbolize_keys
      options.update(options) { |_, v, _| v.to_i }
    end

    def normalize_params!
      case request.env['CONTENT_TYPE']
      when 'application/json'
        json_body = ::JSON.parse(request.env['rack.input'].read)
        params.merge!(json_body)
      when 'application/xml', 'text/xml'
        xml_body = Hash.from_xml(request.env['rack.input'].read)
        params.merge!(xml_body['barcode'])
      end
    end

    # Internal: Requires that the encoding and format be supported
    #
    # Returns nothing
    # Halts with a 415
    FORMATS              = %w(svg png gif jpg)
    UNSUPPORTED_FORMAT   = 'The specified format is not supported.'
    UNSUPPORTED_ENCODING = 'The encoding selected is not currently supported.'
    def supported!
      unsupported_type(UNSUPPORTED_FORMAT)   unless FORMATS.include?(format)
      unsupported_type(UNSUPPORTED_ENCODING) unless BarcodeFactory.supported?(encoding)
    end

    # Internal: Ensures all required fields are present
    #
    # Returns nothing
    # Halts with a 400
    REQUIRED_PARAMS         = %w(format encoding data)
    MISSING_REQUIRED_PARAMS = 'Missing required parameters.'
    def valid_request!
      bad_request(MISSING_REQUIRED_PARAMS) if REQUIRED_PARAMS.any? { |f| missing?(f) }
    end

    private

    def missing?(name)
      param = params[name]
      param.nil? || param.empty?
    end
  end

  helpers RequestHelpers
end
