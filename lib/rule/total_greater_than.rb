require File.expand_path(File.dirname(__FILE__) + '/base')
require 'pry'

module Rule
	class TotalGreaterThan < Rule::Base
		def initialize discount_threshold
			@discount_threshold = discount_threshold
			@price_adjustment = 0
		end

		def display
			"10% Discount on orders over £#{@discount_threshold}"
		end

		def process_eligibility checkout
			if total_less_other_discounts(checkout) > @discount_threshold
				# binding.pry
				@price_adjustment = total_less_other_discounts(checkout) * 0.1
				@eligible = true
			else
				@price_adjustment = 0
				@eligible = false
			end
		end

		def price_adjustment
			@price_adjustment
		end

		def eligible?
			@eligible
		end

		private 
		def total_less_other_discounts checkout
			checkout.product_total - total_discounts(checkout)
		end

		def total_discounts checkout
			checkout.rules.reject{|r| r == self}.select(&:eligible?).inject(0){|sum,x| sum + x.price_adjustment }
		end
	end
end