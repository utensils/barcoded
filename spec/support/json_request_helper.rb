module JsonRequestHelper
  def json_response 
    JSON.parse(last_response.body)
  end
end
