Dir["models/*.rb"].each do |file|
	require_relative file
end

require 'sinatra'
require 'sass'
require 'unicorn'
require 'active_support/inflector'


class Restaurant < Sinatra::Base
	register Sinatra::ActiveRecordExtension
	
	enable :sessions
	enable :method_override, true

	configure do
		set :scss, {:style => :compressed, :debug_info => false}
	end

	# /css/index.css => name == index
	# /css/app.css => name == app
	get '/css/:name.css' do |name|
		content_type :css
		scss "../public/sass/#{name}".to_sym, :layout => false
	end

	get '/console' do
		Pry.start(binding)
	end

	get '/' do
		erb :index
	end



end
