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
		(product_total - eligible_price_discounts).round(2)
	end

	def product_total
		@items.inject(0) {|sum,item| sum + item.price }
	end

	private
	def eligible_price_discounts
		@rules.select(&:eligible?).inject(0) {|sum, rule| sum + rule.price_adjustment }
	end


end