class Allergen < ActiveRecord::Base
	has_many :foods, through: :food_allergens

end