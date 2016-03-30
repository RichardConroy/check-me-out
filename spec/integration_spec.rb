require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'checkout'
require 'rule/total_greater_than'
require 'rule/lavender_hearts'

describe 'Integration Specs', type: :integration do
	let(:item1) { double(:item1, price: 9.25, code: '001', name: 'Lavender Heart')}
	let(:item2) { double(:item2, price: 45, code: '002', name: 'Personalised Cufflinks')}
	let(:item3) { double(:item3, price: 19.95, code: '003', name: 'Kids T-shirt')}

	let(:gtr60_rule) { Rule::TotalGreaterThan.new 60 }
	let(:lavender_heart_rule) { Rule::LavenderHearts.new 2 }
	let(:promotion_rules) { [gtr60_rule, lavender_heart_rule] }

	let(:checkout) { Checkout.new promotion_rules}

	it 'computes total correctly when one of each product is in the checkout' do
		checkout.scan item1
		checkout.scan item2
		checkout.scan item3
		expect(checkout.total).to eq 66.78
	end

	it 'computes total correctly when there are 2 lavender hearts in the checkout' do
		checkout.scan item1
		checkout.scan item3
		checkout.scan item1
		expect(checkout.total).to eq 36.95
	end

	it 'computes total correctly when both rules are in effect' do
		checkout.scan item1
		checkout.scan item2
		checkout.scan item1
		checkout.scan item3
		expect(checkout.total).to eq 73.76
	end


end