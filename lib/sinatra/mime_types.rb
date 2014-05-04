module Sinatra
  module MimeTypes

    MIME_TYPES = {
      png: 'image/png',
      gif: 'image/gif',
      jpg: 'image/jpeg',
      svg: 'image/svg+xml'
    }

    def self.included?(mod)
      mod.send(:configure) do
        MIME_TYPES.each { |k, v| mime_type k, v }
      end
    end

  end
end
