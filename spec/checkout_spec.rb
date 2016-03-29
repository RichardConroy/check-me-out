require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'checkout'

describe Checkout do

	let(:rules) { [] }
	let(:checkout) { Checkout.new rules }

	describe '#scan' do
		let(:item) { double(:item, price: 12, code: '007', description: 'Mystery Product 15') }
		it 'accepts an item argument' do
			expect(checkout).to respond_to(:scan).with(1).argument
		end

		it 'updates the number of items in the checkout' do
			checkout.scan item
			expect(checkout.items.size).to eq 1
		end

		context 'with promotions' do
			let(:promotion_rule) { double(:promotion_rule)}
			let(:rules) { [promotion_rule]}

			it 'calls #process_eligibility? on each rule with argument self' do
				expect(promotion_rule).to receive(:process_eligibility).with(checkout)
				checkout.scan item
			end
		end
	end

	describe '#total' do 
		it 'returns zero when there are no products in cart' do
			expect(checkout.total).to eq 0
		end

		context 'no promotions' do
			let(:another_item) { double(:another_item, price: 15) }
			let(:yet_another_item) { double(:item3, price: 32) }

			it 'is the sum of all scanned item prices' do
				checkout.scan another_item
				checkout.scan yet_another_item
				expect(checkout.total).to eq 47
			end

			it 'calls #price on each item' do
				expect(another_item).to receive(:price).and_return(5)
				expect(yet_another_item).to receive(:price).and_return(12)
				checkout.scan another_item
				checkout.scan yet_another_item
				checkout.total				
			end
		end

		context 'with promotions' do
			let(:item1) { double(:item1, price: 18) }
			let(:item2) { double(:item2, price: 52) }

			let(:promotion_rule) { double(:promotion_rule, price_adjustment: 20, eligible?: true )}
			let(:rules) { [promotion_rule] }

			it 'is deducts promotion price adjustments from item prices' do
				allow(promotion_rule).to receive(:process_eligibility)
				checkout.scan item1
				checkout.scan item2
				expect(checkout.total).to eq 50 # 18 + 52 - 20 = 50
			end
		end
	end
end