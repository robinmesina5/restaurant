Dir["models/*.rb"].each do |file|
	require_relative file
end

require 'sinatra'
require 'sass'
require 'unicorn'
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


get '/console' do
	Pry.start(binding)
end

get '/' do
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
	erb :'parties/edit'
end

get '/parties/:id' do |id|
	@party = Party.find(id)
	@foods = Food.all
	@order = Order.all
	@employee = @party.employee
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

	redirect to ("/parties/#{party.id}")
end

get '/parties/:id/receipt' do |id|
	@party = Party.find(id)
	@foods = Food.all
	sum = Party.find(id).foods.map do |food|
		food.price
	end
	@party.sub_total = sum.inject(:+)
	@party.total = @party.sub_total.to_f + @party.tip.to_f
	erb :"parties/receipt"
end

get '/parties/:id/close' do |id|
	@party = Party.find(id)
		def self.open_tables
		range = (1..8)
		table = range.to_a
		parties = Party.all
		not_paid = parties.where(paid: 'f')
		unavailable = not_paid.map do |table|
			table.table_id
		end
		return available = table - unavailable
	end
	@available = Party.open_tables
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
		@party = Party.all
		erb :'orders/index'
	end

	post '/orders' do
		#Pry.start(binding)
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
		@order = Order.find(id)
		@food = Food.all
		#Pry.start(binding)
		erb :'orders/show'
	end

	get '/orders/:id/edit' do |id|
		@order = Order.find(id)
		@party = Party.all
		@foods = Food.all
		#Pry.start(binding)
		erb :'orders/edit'
	end

	delete '/orders/:id' do
		order = Order.find(params[:id])
		order.destroy

		redirect to "/orders"
	end

end
