require File.expand_path(File.dirname(__FILE__) + '/base')

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
			current_discounted_total = total_less_other_discounts(checkout)
			if current_discounted_total > @discount_threshold
				@price_adjustment = current_discounted_total * 0.1
			else
				@price_adjustment = 0
			end
		end

		def price_adjustment
			@price_adjustment
		end

		private 
		def total_less_other_discounts checkout
			checkout.product_total - other_discounts(checkout)
		end

		def other_discounts checkout
			all_other_rules = checkout.rules.reject{|r| r == self}
			all_other_rules.inject(0){|sum,x| sum + x.price_adjustment }
		end
	end
end