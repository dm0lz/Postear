$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require "pry"
require "cucumber"
require "rspec"
require 'fetcher-mongoid-models'
Fetcher::Mongoid::Models::Db.new "/home/fetcher/Desktop/Postear/config/database.yml"

