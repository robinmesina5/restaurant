require 'securerandom'

use Rack::MethodOverride

require_relative 'environment'
require_relative 'restaurant-app'

require './controllers/application_controller.rb'



map('/foods') { run FoodsController }
map('/parties') { run PartiesController }
map('/orders') { run OrdersController }
map('/employees') { run EmployeesController }

run Sinatra::Application

run Restaurant