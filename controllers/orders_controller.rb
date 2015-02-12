class OrdersController < ApplicationController

	get '/' do
		@orders = Order.all
		@party = Party.all

		erb :'orders/index'
	end

	post '/' do
		#Pry.start(binding)
		order = Order.create(params[:order])
		party = order.party.id

		redirect to "/orders/#{order.id}"
	end

	patch '/:id' do
		@order = Order.find(id)
		group = order.update(params[:order])
		a = Order.find(id)
		a.update(receipt_id: id)
		redirect to "/parties/#{group.id}"
	end

	get '/:id' do |id|
		@order = Order.find(id)
		@food = Food.all
		#Pry.start(binding)
		erb :'orders/show'
	end

	get '/:id/edit' do |id|
		@order = Order.find(id)
		@party = Party.all
		@foods = Food.all
		#Pry.start(binding)
		erb :'orders/edit'
	end

	delete '/:id' do
		order = Order.find(params[:id])
		order.destroy

		redirect to "/orders"
	end

end