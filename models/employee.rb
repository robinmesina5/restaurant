class Employee < ActiveRecord::Base
	has_many :parties
	has_many :orders, through: :parties

	
end