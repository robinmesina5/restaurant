require 'pg'
require 'active_record'
require 'pry'

Dir["../models/*.rb"].each do |file|
 require_relative file
end

#require_relative '../models/food'

ActiveRecord::Base.establish_connection(
  adapter: :postgresql,
  database: "restaurant",
  host: "localhost", port: 5432

 )
#Pry.start(binding)

##FOODS
[

{
 name: "Cheeseburger",
 cuisine_type: "Sandwiches",
 price: 6,
 allergens: "dairy"

},
{
 name: "Grilled Cheese",
 cuisine_type: "Sandwiches",
 price: 4,
 allergens: "dairy"

},
{
 name: "Western Omelet",
 cuisine_type: "Breakfast",
 price: 6,
 allergens: "eggs, dairy"

}

].each do |food|
 Food.create( food )
end

##Partys

[

{
 people: 2,
 paid: "FALSE",
},
{
 people: 4,
 paid: "TRUE",
},
{
 people: 3,
 paid: "FALSE",
}

].each do |party|
 Party.create( party)
end

 ## ORDERS

[

{
 party_id: nil,
 food_id: nil

},
{
 party_id: nil,
 food_id: nil

},
{
 party_id: nil,
 food_id: nil

}

 ].each do |order|
   Order.create (order)
 end