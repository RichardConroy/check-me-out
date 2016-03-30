require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

require 'rule/lavender_hearts'

describe Rule::LavenderHearts do
	let(:threshold_lavender_hearts) { 2 }
	let(:rule) { Rule::LavenderHearts.new threshold_lavender_hearts }
	let(:expected_discount) { threshold_lavender_hearts * 0.75 }
	let(:checkout_total) { 49 }
	let(:item1) { double(:item1, price: 10, code: '001', name: 'Lavender Heart')}
	let(:item2) { double(:item2, price: 10, code: '001', name: 'Lavender Heart')}
	let(:item3) { double(:item3, price: 20, code: '005', name: 'Queen of Hearts')}
	describe '#process_eligibility' do
		let(:items) { [] }
		let(:checkout) { double(:checkout, items: items )}

		context 'empty checkout' do
			it 'sets eligibility to false' do
				rule.process_eligibility(checkout)
				expect(rule.eligible?).to be_false
			end

			it 'sets price adjustment to zero' do
				rule.process_eligibility(checkout)
				expect(rule.price_adjustment).to eq 0
			end
		end

		context 'checkout contains enough lavender hearts for eligibility' do
			let(:items) { [item1, item2, item1, item2] }

			it 'sets eligibility to true' do
				rule.process_eligibility(checkout)
				expect(rule.eligible?).to be_true
			end

			it 'sets price adjustent to 0.75 x number of hearts' do
				rule.process_eligibility(checkout)
				expect(rule.price_adjustment).to eq (4 * 0.75)
			end
		end
	end
end