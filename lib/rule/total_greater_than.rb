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
			if checkout.total > @discount_threshold
				@price_adjustment = checkout.total * 0.1
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
	end
end