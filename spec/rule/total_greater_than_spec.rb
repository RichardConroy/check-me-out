require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

require 'rule/total_greater_than'

describe Rule::TotalGreaterThan do
	let(:total_threshold) { 50 }
	let(:rule) { Rule::TotalGreaterThan.new total_threshold}
	let(:promotion_rules) { [rule] }
	let(:product_total) { 49 }
	describe '#process_eligibility' do
		let(:checkout) { double(:checkout, product_total: product_total, rules: promotion_rules)}
		context 'checkout#total below threshold' do
			it 'remains ineligible for discount' do
				rule.process_eligibility checkout
				expect(rule.eligible?).to be_false
			end

			it 'has a price_adjustment of zero' do
				rule.process_eligibility checkout
				expect(rule.price_adjustment).to eq 0
			end
		end

		context '#checkout#total above threshold' do
			let(:product_total) { 100 }

			it 'is eligible for discount' do
				rule.process_eligibility checkout
				expect(rule.eligible?).to be_true
			end

			it 'has a price_adjustment of 10% of checkout#total' do
				rule.process_eligibility checkout
				expect(rule.price_adjustment).to eq 10
			end

			context 'other discounts in effect' do
				let(:other_rule) { double(:other_rule, eligible?: true, price_adjustment: 20 )}
				let(:promotion_rules) { [rule, other_rule] }

				it 'calculates price_adjustment after other discounts are applied' do
					rule.process_eligibility checkout
					expect(rule.price_adjustment).to eq 8
				end
			end
		end
	end
end