class Employee < ActiveRecord::Base

	has_many :parties
	has_many :orders, through: :parties

	attr_reader :password

	validates :email, presence: true

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

