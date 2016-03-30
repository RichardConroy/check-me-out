require File.expand_path(File.dirname(__FILE__) + '/product')
require File.expand_path(File.dirname(__FILE__) + '/checkout')
require File.expand_path(File.dirname(__FILE__) + '/rule/lavender_hearts')
require File.expand_path(File.dirname(__FILE__) + '/rule/total_greater_than')

class Main
  def self.run
  	puts 'Test Data'
  	puts '---------'
  	checkout1 = Checkout.new promotional_rules
  	checkout1.scan product001
  	checkout1.scan product002
  	checkout1.scan product003
  	puts checkout1.items.collect(&:code).join(',')
  	puts 'Total price expected: £66.78'
  	puts "Total price actual: £#{checkout1.total}"
  	puts
  	checkout2 = Checkout.new promotional_rules
  	checkout2.scan product001
  	checkout2.scan product003
  	checkout2.scan product001
  	puts checkout2.items.collect(&:code).join(',')
  	puts 'Total price expected: £36.95'
  	puts "Total price actual: £#{checkout2.total}"
  	puts  	
  	checkout3 = Checkout.new promotional_rules
  	checkout3.scan product001
  	checkout3.scan product002
  	checkout3.scan product001
  	checkout3.scan product003
  	puts checkout3.items.collect(&:code).join(',')
  	puts 'Total price expected: £73.76'
  	puts "Total price actual: £#{checkout3.total}"
  	puts  	
  end

  def self.promotional_rules
  	[Rule::LavenderHearts.new(2), Rule::TotalGreaterThan.new(60)]
  end

  def self.product001
  	Product.new Product::LAVENDER_HEART, 'Lavender heart', 9.25
  end

  def self.product002
		Product.new Product::PERSONALISED_CUFFLINKS, 'Personalised cufflinks', 45
  end

  def self.product003
		Product.new Product::KIDS_T_SHIRT, 'Kids T-shirt', 19.95
  end

end

Main.run