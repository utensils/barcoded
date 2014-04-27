class Barcoded < Sinatra::Base
  helpers Sinatra::RequestHelpers
  helpers Sinatra::ResponseHelpers

  enable :logging

  before do
    supported!
  end

  get '/v1/*' do
    halt 501
  end

end
