module Rule
	class Base
		def display
			raise 'Override this'
		end

		def process_eligibility checkout
			raise 'Override this'
		end

		def price_adjustment
			raise 'Override this'
		end
	end
end