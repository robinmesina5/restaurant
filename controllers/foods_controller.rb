class FoodsController < ApplicationController

	get '/' do
		@foods = Food.all
		erb :'foods/index'
	end

	get '/new' do
		erb :'foods/new'
	end

	post '/' do
		food = Food.create(params[:food])

		redirect to "/foods/#{food.id}"
	end

	get '/:id/edit' do |id|
		@food = Food.find(id)
		erb :'foods/edit'
	end

	patch '/:id' do |id|
		food = Food.find(id)
		food.update(params[:food])

		redirect to ("/foods/#{food.id}")
	end

	get '/:id' do |id|
		@food = Food.find(id)
		erb :'foods/show'
	end

	delete '/:id' do
		food = Food.find(params[:id])
		food.destroy

		redirect to "/foods"
	end

end