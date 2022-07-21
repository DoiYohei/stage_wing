module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_band

    def connect
      self.current_band = find_verified_band(request.query_parameters)
      logger.add_tags(current_band.name)
    end

    private

    def find_verified_band(params)
      uid = params['uid']
      token = params['access-token']
      client = params['client']
      band = Band.find_by(email: uid)
      if band&.valid_token?(token, client)
        band
      else
        reject_unauthorized_connection
      end
    end
  end
end
