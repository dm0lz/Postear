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
require 'fetcher-mongoid-models'

Fetcher::Mongoid::Models::Db.new "/home/fetcher/Desktop/Postear/config/database.yml"

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
		@person = getPersonUser
		
		#binding.pry
		haml :index 
	end

	post '/postear' do
		
		#getTwitterCredentials 308762265
		#getFacebookCredentials 100002221264673
		#twitterClient
		#facebookClient
		session["twitterprovider"] = params["twitter"]
		session["facebookprovider"] = params["facebook"]
		session["message"] = params["message"]
		getPersonUser.each do |person|
			session[person.itemId.join] = params[person.itemId.join]
		end
		#twitterClient.update session["message"] if session["twitterprovider"] == "on"
		#facebookClient.put_connections("me", "feed", :message => session["message"]) if session["facebookprovider"] == "on"
		postear
		binding.pry

		redirect '/posted'
	end

	get '/posted' do
		'Your post was succeffully processed !!'
	end

	helpers do
	  def getPersonUserAccountsId 
	  	@cuentas = User.where(login: "olivier").first.PersonUser
	  end
	  def getPersonUser
	  	@person = getPersonUserAccountsId.collect do |person|
	  		PersonUser.find(person)
	  	end
	  end
	  def getPersonUserName
	  	@names = getPersonUserAccountsId.collect do |cuenta|
	  		PersonUser.find(cuenta).name.join
	  	end
	  end
	  def getitemId
	  	@itemId = getPersonUserAccountsId.collect do |item|
	  		PersonUser.find(item).itemId.join
	  	end
	  end
	  def getTwitterCredentials id
	  	@twitter_access_token = PersonUser.where(itemId: id).first.accessToken
			@twitter_access_secret = PersonUser.where(itemId: id).first.accessSecret
	  end
	  def getFacebookCredentials id
	  	#@facebook_access_token = @coll.find("Item#id" => id).collect{|i| p i["accessToken"]}.join
	  end
		def twitterClient 
			@twitterClient = Twitter::Client.new(:oauth_token => @twitter_access_token, 
											:oauth_token_secret => @twitter_access_secret)
		end
		def facebookClient
			@facebookClient = Koala::Facebook::API.new @facebook_access_token
		end
	  def postTwitter
	  	twitterClient.update session["message"] if session["twitterprovider"] == "on"
	  end
	  def postear
	  	getitemId.each do |itemId|
	  		#unless blablabla...
	  		getTwitterCredentials itemId.to_i
	  		twitterClient
	  		postTwitter
	  	end
	  end

	end

end
