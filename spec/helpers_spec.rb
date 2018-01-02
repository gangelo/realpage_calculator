require 'spec_helper'

describe 'Helpers' do
  context 'methods' do
    describe '#blank?' do
      it 'should accept 1 argument' do
        expect(RealPage::Calculator::Helpers).to respond_to(:blank?).with(1).arguments
      end

      it 'should return true if argument is nil' do
        expect(RealPage::Calculator::Helpers.blank?(nil)).to eq(true) 
      end

      it 'should return true if argument is an empty string' do
        expect(RealPage::Calculator::Helpers.blank?('')).to eq(true) 
      end

      it 'should return true if argument is a string with all spaces' do
        expect(RealPage::Calculator::Helpers.blank?('   ')).to eq(true) 
      end

      it 'should return false if argument is not nil or a string' do
        expect(RealPage::Calculator::Helpers.blank?(1)).to eq(false) 
        expect(RealPage::Calculator::Helpers.blank?(Object.new)).to eq(false) 
      end
    end
  end
end