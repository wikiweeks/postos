require 'json'
require 'pry'
require 'oauth'

class PlacesController < ApplicationController

  def index
  end

  def create
  	
	 yahoo = Typhoeus.get("http://where.yahooapis.com/v1/places.q(#{URI.encode(safe_search_term[:name])})?format=json&appid=NKkXnZ7V34G1aIcSoM.FKQt18ewzU5CkGzJznfCpRS6v8hLIrZdHM1ecYx_2gbfz")
	 
	 response = yahoo.options[:response_body]
	 parsed =JSON.load(response)
	 
	 spot = parsed["places"]["place"][0]["woeid"]
	 # name = safe_search_term["name"]
	 @place = Places.new(safe_search_term)

	 @place.spot = spot

 		def prepare_access_token(oauth_token, oauth_token_secret)
		  consumer = OAuth::Consumer.new("Q330Y6DrJHFgKcCY6FkARbw2g", "CKBIZGyWPZtFMqivzQYHGJ4fOIaUWl5V8kP90nrGVSXPoT6bcA",
		    { :site => "https://api.twitter.com",
		      :scheme => :header
		    })
		  # now create the access token object from passed values
		  token_hash = { :oauth_token => oauth_token,
		                 :oauth_token_secret => oauth_token_secret
		               }
		  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
		  return access_token
		end
	 
		# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
		access_token = prepare_access_token("137516812-3tV2YB4vcT2pX1JCO9pH6e20r4kzoDtfOgwuv54E", "okC2kBZEdiQIGB5wFbcMVxzv45VTW2100mNi9UxR2JMOa")
		# use the access token as an agent to get the home timeline
		response = access_token.request(:get, "https://api.twitter.com/1.1/trends/place.json?id=#{@place.spot}")

		# if response.body = nil
		# 	worldwide=access_token.request(:get, "https://api.twitter.com/1.1/trends/place.json?id=1")
		# 	trends_hash=JSON.load(worldwide.body)
		# 	binding.pry
		# 	@place.name="Worldwide"
		# else
		# if response.body
		
		trends_hash = JSON.load(response.body)
		@place.trends = trends_hash[0]["trends"]
		
		@place.save
	 	
	 	redirect_to @place
		# else 
		# 	worldwide = access_token.request(:get, "https://api.twitter.com/1.1/trends/place.json?id=1")
		# 	trends_hash = JSON.load(worldwide.body)	
		# 	@place.name = "Worldwide"
		# end


		


  end

  def show
  	@place = Places.find(params[:id])
		
	end

  private
	  def safe_search_term	
			params.require(:place).permit(:name)
	  end

 end



