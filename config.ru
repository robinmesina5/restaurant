require 'bundler'
Bundler.require



require_relative 'environment'
require_relative 'restaurant-app.rb'


map('/foods') { run FoodsController }
map('/parties') { run PartiesController }
map('/orders') { run OrdersController }

run Restaurant