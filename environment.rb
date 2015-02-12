# Make sure we load all the gems
require 'rubygems'
require 'bundler'
Bundler.require :default

# Then connect to the database
set :database, {
  adapter: "postgresql", database: "restaurant",
  host: "localhost", port: 5432
}

['models/concerns', 'models', 'helpers', 'controllers'].each do |component|
  Dir["#{component}/*.rb"].sort.each do |file|
    require File.expand_path(file)
  end
end