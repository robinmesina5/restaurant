class Food < ActiveRecord::Base
	has_many :orders
	has_many :parties, through: :orders
	#has_many :allergens, through: :food_allergens

end