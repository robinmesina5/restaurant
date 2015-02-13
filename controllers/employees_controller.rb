class EmployeesController < ApplicationController

	get '/signup' do
		@employee = Employee.new
		erb :signup
	end

	post '/signup' do
		@employee = Employee.new(email: params[:employee][:email])

		if params[:employee][:password] == params[:employee][:password_confirmation]

			@employee.password = params[:employee][:password]

			if @employee.save
				login!(@employee)

				redirect to('/welcome')
			else
				erb :signup
			end
		else
			@employee.errors.add(:password, "and confirmation do not match.")

			erb :signup
		end
	end

	get '/login' do
		@employee = Employee.new

		erb :login
	end

	post '/login' do
		@employee = Employee.find_by_credentials(params[:employee])

		if @employee
			login!(@employee)

			redirect to('/welcome')
		else
			@employee = Employee.new(email: params[:employee][:email])

			@employee.errors.add(:password, "and email are not a valid combination.")

			erb :login
		end
	end

	delete '/logout' do
		logout!

		redirect to('/login')
	end

	get '/welcome' do
		@employee = current_employee

		erb :welcome
	end
	
	private

	def create_token
		return SecureRandom.urlsafe_base64
	end

	def current_employee
		Employee.find_by(authorization_token: session[:authorization_token])
	end

	def login!(employee)
		employee.authorization_token = session[:authorization_token] = create_token

		employee.save
	end

	def logout!
		employee = current_employee

		employee.authorization_token = session[:authorization_token] = nil

		employee.save
	end

end