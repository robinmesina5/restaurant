class Party < ActiveRecord::Base
	has_many :orders
	has_many :foods, through: :orders

	def self.open_tables
		range = (1..8)
		table = range.to_a
		parties = Party.all
		not_paid = parties.where(paid: 'f')
		unavailable=  not_paid.map do |table|
			table.table_id
		end
		return available = table - unavailable
	end
end
