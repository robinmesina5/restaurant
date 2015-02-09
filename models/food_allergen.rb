class FoodAllergen < ActiveRecord::Base
	has_many :foods
	has_many :allergens
end