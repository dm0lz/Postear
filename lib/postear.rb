require 'sinatra/base'
#require 'omniauth-twitter'
#require 'twitter'
#require 'pry'
require 'haml'
require "better_errors"

class Postear < Sinatra::Base

	set :views, "views"
	set :public_folder, "public"
	#set :haml, :format => :html5
	#set :port, 4567
	use BetterErrors::Middleware
	BetterErrors.application_root = File.expand_path("..", __FILE__)

	enable :sessions

	get '/' do
		haml :index 
	end


end
