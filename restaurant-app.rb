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

		#attr_reader :password

	#validates :email, presence: true

	def self.find_by_credentials(args={})
		employee = Employee.find_by(email: args[:email])

		if employee.is_password?(args[:password])
			return employee
		else
			return nil
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
