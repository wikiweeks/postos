require 'json'
require 'pry'
require 'oauth'

class PlacesController < ApplicationController

  def index
  end

  def create
  	
	 yahoo = Typhoeus.get("http://where.yahooapis.com/v1/places.q(#{URI.encode(safe_search_term[:name])})?format=json&appid=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
	 
	 response = yahoo.options[:response_body]
	 parsed =JSON.load(response)
	 
	 spot = parsed["places"]["place"][0]["woeid"]
	 # name = safe_search_term["name"]
	 @place = Places.new(safe_search_term)

	 @place.spot = spot

 		def prepare_access_token(oauth_token, oauth_token_secret)
		  consumer = OAuth::Consumer.new("XXXXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXX",
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
		access_token = prepare_access_token("XXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXX")
		# use the access token as an agent to get the home timeline
		response = access_token.request(:get, "https://api.twitter.com/1.1/trends/place.json?id=#{@place.spot}")

		
		trends_hash = JSON.load(response.body)
		@place.trends = trends_hash[0]["trends"]
		
		@place.save
	 	
	 	redirect_to @place

  end

  def show
  	@place = Places.find(params[:id])
		
	end

  private
	  def safe_search_term	
			params.require(:place).permit(:name)
	  end

 end



