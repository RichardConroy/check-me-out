require 'pry'
class Checkout
	attr :items
	attr :rules
	def initialize rules
		@items = Array.new
		@rules = rules
	end

	def scan(item)
		@items << item
		@rules.each {|rule| rule.process_eligibility self}
	end

	def total
		@items.inject(0) {|sum,item| sum + item.price } - eligible_price_discounts
	end

	private
	def eligible_price_discounts
		@rules.select(&:eligible?).inject(0) {|sum, rule| sum + rule.price_adjustment }
	end


end