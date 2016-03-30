class Product
	LAVENDER_HEART = '001'
	PERSONALISED_CUFFLINKS = '002'
	KIDS_T_SHIRT = '003'
	attr_reader :price, :code, :name

	def initialize code, name, price
		@code,@name,@price = code, name, price
	end

end