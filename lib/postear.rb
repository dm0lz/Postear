require 'sinatra/base'
require 'omniauth-twitter'
require 'twitter'
require 'pry'
require 'haml'
require 'sass'
require 'better_errors'
require 'symbolmatrix'
require 'mongo'
require 'koala'

class Postear < Sinatra::Base

	set :views, "views"
	set :public_folder, "public"
	set :haml, :format => :html5
	set :port, 4567
	enable :sessions
	
	use BetterErrors::Middleware
	BetterErrors.application_root = File.expand_path("..", __FILE__)

	unless File.exists? "config/main.yaml"
		puts "configuration file is missing !!"
		Process.exist
	else
		CONFIG = SymbolMatrix.new "config/main.yaml"
	end

	Twitter.configure do |config|
		config.consumer_key = CONFIG.twitter_consumer_key
		config.consumer_secret = CONFIG.twitter_consumer_secret
	end

	get '/style.css' do
		sass :style
	end

	get '/' do
		client
		haml :index 
	end

	post '/postear' do
		coll
		getTwitterCredentials 308762265
		getFacebookCredentials 100002221264673
		twitterClient
		facebookClient
		session["twitterprovider"] = params["twitter"]
		session["facebookprovider"] = params["facebook"]
		session["message"] = params["message"]
		twitterClient.update session["message"] if session["twitterprovider"] == "on"
		facebookClient.put_connections("me", "feed", :message => session["message"]) if session["facebookprovider"] == "on"
		#binding.pry

		redirect '/posted'
	end

	get '/posted' do
		'Your post was succeffully processed !!'
	end

	helpers do
		def twitterClient
			@twitterClient ||= Twitter::Client.new(:oauth_token => @twitter_access_token, 
											:oauth_token_secret => @twitter_access_secret)
		end
		def facebookClient
			@facebookClient ||= Koala::Facebook::API.new @facebook_access_token
		end
		def client
	    @client ||= Mongo::Connection.new("mongocfg1.fetcher")
	  end
	  def db
	    @db ||= client["test"]
	  end
	  def coll
	    @coll ||= db["http://schema.org/Person/User"]
	  end
	  def getTwitterCredentials id
	  	@twitter_access_token = @coll.find("Item#id" => id).collect{|i| i['accessToken']}.first
			@twitter_access_secret = @coll.find("Item#id" => id).collect{|i| i['accessSecret']}.first
	  end
	  def getFacebookCredentials id
	  	@facebook_access_token = @coll.find("Item#id" => id).collect{|i| p i["accessToken"]}.join
	  end
	end

end
