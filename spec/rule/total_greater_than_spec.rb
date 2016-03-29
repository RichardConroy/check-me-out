require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

require 'rule/total_greater_than'

describe Rule::TotalGreaterThan do
	let(:total_threshold) { 50 }
	let(:rule) { Rule::TotalGreaterThan.new total_threshold}
	let(:checkout_total) { 49 }
	describe '#process_eligibility' do
		let(:checkout) { double(:checkout, total: checkout_total)}
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
			let(:checkout_total) { 100 }

			it 'is eligible for discount' do
				rule.process_eligibility checkout
				expect(rule.eligible?).to be_true
			end

			it 'has a price_adjustment of 10% of checkout#total' do
				rule.process_eligibility checkout
				expect(rule.price_adjustment).to eq 10
			end
		end
	end
end