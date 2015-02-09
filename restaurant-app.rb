Dir["models/*.rb"].each do |file|
	require_relative file
end

require 'sinatra'
require 'sass'
require 'active_support/inflector'

enable :sessions

class Restaurant < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	enable :method_override

configure do
  set :scss, {:style => :compressed, :debug_info => false}
end

# /css/index.css => name == index
# /css/app.css => name == app
get '/css/:name.css' do |name|
  content_type :css
  scss "../public/sass/#{name}".to_sym, :layout => false
end


	get '/' do
		#Pry.start(binding)
		erb :index
	end

### FOODS ###

	get '/foods' do
		@foods = Food.all
		erb :'foods/index'
	end

	get '/foods/new' do
		erb :'foods/new'
	end

	post '/foods' do
		food = Food.create(params[:food])

		redirect to "/foods/#{food.id}"
	end

	get '/foods/:id/edit' do |id|
		@food = Food.find(id)
		erb :'foods/edit'
	end

	patch '/foods/:id' do |id|
		food = Food.find(id)
		food.update(params[:food])

		redirect to ("/foods/#{food.id}")
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

### PARTIES ###

	get '/parties' do
		@parties = Party.all
		erb :'parties/index'
	end

	get '/parties/new' do
		@available = Party.open_tables
		@party = Party.all
		erb :'parties/new'
	end

	post '/parties' do
		party = Party.create(params[:party])
		 
		redirect to("/parties/#{party.id}")
	end

	get '/parties/:id/edit' do |id|
		@party = Party.find(id)
		@foods = Food.all
		erb :'parties/edit'
	end

	get '/parties/:id' do |id|
		@party = Party.find(id)
		@foods = Food.all
		@order = Order.all
		
		erb :'parties/show'
	end

	get '/parties/:id/new_order' do |id|
		@party = Party.find(id)
		@foods = Food.all
		erb :"orders/new"
	end

	patch '/parties/:id' do |id|
		party = Party.find(id)
		party.update(params[:party])
		redirect to("/parties")
	end

	get '/parties/:id/receipt' do |id|
		@party = Party.find(id)
		@foods = Food.all

		erb :"parties/receipt"
	end

	get '/parties/:id/close' do |id|
		@party = Party.find(id)
		erb :"parties/close"
	end
 
	delete '/parties/:id' do
		party = Party.find(params[:id])
		party.destroy

		redirect to "/parties"
	end

	### ORDERS ###

	get '/orders' do
		@orders = Order.all
		@food = Food.all
		erb :'orders/index'
	end

	post '/orders' do
		#Pry.start(binding)
		# FIX parties.show, orders.show, orders.new 
		order = Order.create(params[:order])
		party = order.party.id

		redirect to "/orders/#{order.id}"
	end

	patch '/orders/:id' do
		@order = Order.find(id)
		group = order.update(params[:order])
		a = Order.find(id)
		a.update(receipt_id: id)
		redirect to "/parties/#{group.id}"
	end

	get '/orders/:id' do |id|
		#Pry.start(binding)
		@order = Order.find(id)
		@food = Food.all
		erb :'orders/show'
	end

	get '/orders/:id/edit' do |id|
		@order = Order.find(id)
		@party = Party.all
		@foods = Food.all
		erb :'orders/edit'
	end

	delete '/orders/:id' do
		order = Order.find(params[:id])
		order.destroy

		redirect to "/orders"
	end

end
