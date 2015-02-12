class PartiesController < ApplicationController

	get '/' do
		@parties = Party.all
		erb :'parties/index'
	end

	get '/new' do
		@available = Party.open_tables
		@party = Party.all
		erb :'parties/new'
	end

	post '/' do
		party = Party.create(params[:party])

		redirect to("/parties/#{party.id}")
	end

	get '/:id/edit' do |id|
		@party = Party.find(id)
		erb :'parties/edit'
	end

	get '/:id' do |id|
		@party = Party.find(id)
		@foods = Food.all
		@order = Order.all
		@employee = @party.employee
		erb :'parties/show'
	end

	get '/:id/new_order' do |id|
		@party = Party.find(id)
		@foods = Food.all
		erb :"orders/new"
	end

	patch '/:id' do |id|
		party = Party.find(id)
		party.update(params[:party])

		redirect to ("/parties/#{party.id}")
	end

	get '/:id/receipt' do |id|
		@party = Party.find(id)
		@foods = Food.all
		sum = Party.find(id).foods.map do |food|
			food.price
		end
		@party.sub_total = sum.inject(:+)
		@party.total = @party.sub_total.to_f + @party.tip.to_f
		erb :"parties/receipt"
	end

	get '/:id/pay' do |id|
		@party = Party.find(id)
		@foods = Food.all
		@party.total = @party.sub_total.to_f + @party.tip.to_f
		erb :"parties/pay"
	end

	get '/:id/close' do |id|
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

	delete '/:id' do
		party = Party.find(params[:id])
		party.destroy

		redirect to "/parties"
	end

end
