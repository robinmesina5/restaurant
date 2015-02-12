### Employee or User routes for app.rb ###

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

	class User < ActiveRecord::Base

	attr_reader :password

	validates :email, presence: true
	validates :password_digest, presence: true
	validates :password, length: { minimum: 6, allow_nil: true }

	def self.find_by_credentials(args={})
		@employee = Employee.find_by(email: args[:email])

		if @employee.is_password?(args[:password])
			return @employee
		else
			return allow_nil
		end
	end

	def password = (pwd)
		@password = pwd

		self.password_digest = BCrypt::Password.create(pwd)
		self.save
	end

	def is_password?(pwd)
		bcrypt_pwd = BCrypt::Password.new(self.password_digest)

		return bcrypt_pwd.is_password?(pwd)
	end
end


### SIGNUP.RB ###

<h3>Welcome. Please register before logging in. If you are a returing user, please login <a href="/login">here</a></h3>

<% @employee.errors.full_messages.each do |message| %>
  <p class="error"><%= message %></p>
<% end %>

<form action="/signup" method="post">
  <fieldset>
    <label for="employee_email">Email Address</label>
    <input type="email" id="employee_email" name="employee[email]" value="<%= @employee.email %>">
  </fieldset>

  <fieldset>
    <label for="employee_password">Password</label>
    <input type="password" id="employee_password" name="employee[password]">
  </fieldset>

  <fieldset>
    <label for="employee_password_confirmation">Password Confirmation</label>
    <input type="password" id="employee_password_confirmation" name="employee[password_confirmation]">
  </fieldset>

  <input type="submit" value="Sign Up">
</form>

### LOGIN.RB ###

<h1>Welcome, existing user!  Log in below.</h1>

<% @employee.errors.full_messages.each do |message| %>
  <p class="error"><%= message %></p>
<% end %>

<form action="/login" method="post">
  <fieldset>
    <label for="employee_email">Email Address</label>
    <input type="email" id="employee_email" name="employee[email]" value="<%= @employee.email %>">
  </fieldset>

  <fieldset>
    <label for="employee_password">Password</label>
    <input type="password" id="employee_password" name="employee[password]">
  </fieldset>

  <input type="submit" value="Log in">
</form>

### WELCOME.RB ###

<h1>Welcome, <%= @employee.email %></h1>

<form action="/logout" method="post">
  <input type="hidden" value="delete" name="_method">
  <input type="submit" value="Log out!">
</form>

#require 'securerandom'
