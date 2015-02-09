class Receipt < ActiveRecord::Base
	has_many :orders
	belongs_to :parties

end