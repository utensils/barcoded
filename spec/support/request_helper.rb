module RequestHelper
  # If no accept header is supplied, default response is JSON
  def response
    case last_request.content_type
      when 'application/xml', 'text/xml'
        Hash.from_xml(last_response.body)['barcode']
      else
        JSON.parse(last_response.body)
    end
  end
end
