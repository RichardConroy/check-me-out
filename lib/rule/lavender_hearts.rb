require File.expand_path(File.dirname(__FILE__) + '/base')
require 'pry'

module Rule
	class LavenderHearts < Rule::Base
		def initialize item_count_threshold=2
			@item_count_threshold = item_count_threshold
			@price_adjustment = 0
		end

		def display
			"Save £0.75 on each Lavender Heart, when you buy #{@item_count_threshold} or more"
		end

		def process_eligibility checkout
			if sufficient_products_for_discount? checkout
				@price_adjustment = lavender_hearts_count(checkout) * 0.75
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
		def sufficient_products_for_discount? checkout
			lavender_hearts_count(checkout) >= @item_count_threshold
		end

		def lavender_hearts_count checkout
			require_relative '../product'
			checkout.items.select{|item| item.code == Product::LAVENDER_HEART }.size
		end
	end
end