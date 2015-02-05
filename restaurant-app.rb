Dir["models/*.rb"].each do |file|
	require_relative file
end

require 'active_support/inflector'

class Restaurant < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	enable :method_override

	get '/' do
		#Pry.start(binding)
		erb :index
	end

	get '/foods' do
		@foods = Food.all
		erb :'foods/index'
	end

	get '/foods/new' do
		erb :'foods/new'
	end

	post '/foods' do
		food = params[:food]
		Food.create(food)

		redirect to '/foods'
	end

	get '/foods/:id/edit' do |id|
		@food = Food.find(id)
		erb :'foods/edit'
	end

	patch '/foods/:id' do |id|
		food = Food.find(id)
		food.update(params[:food])

		redirect to "/foods/#{food.id}"
	end

	get '/foods/:id' do |id|
		@food = Food.find(id)
		erb :'foods/show'
	end

	delete '/foods/:id' do
		food = Food.find(params[:id])
		food.destroy

		redirect to "/foods"
	end

	get '/parties' do
		@parties = Party.all
		erb :'parties/index'
	end

	get '/parties/new' do
		@available = Party.open_tables
		erb :'parties/new'
	end

	post '/parties' do
		party = params[:party]
		Party.create(party)

		redirect to "/parties/"
	end

	get '/parties/:id/edit' do |id|
		@parties = Party.find(id)
		erb :'parties/edit'
	end

	patch '/parties/:id' do |id|
		party = Party.find(id)
		party.update(params[:party])

		redirect to "/parties/#{party.id}"
	end

	get '/parties/:id' do |id|
		@party = Party.find(id)
		erb :'parties/show'
	end

end
