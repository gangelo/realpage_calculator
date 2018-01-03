require 'spec_helper'

describe 'Helpers' do
  context 'methods' do
    describe '#blank?' do
      before do
        class Blank 
          include RealPage::Calculator::Helpers::Blank 
        end
        @helpers_blank = Blank.new
      end

      it 'should accept 1 argument' do
        expect(@helpers_blank).to respond_to(:blank?).with(1).arguments
      end

      it 'should return true if argument is nil' do
        expect(@helpers_blank.blank?(nil)).to eq(true) 
      end

      it 'should return true if argument is an empty string' do
        expect(@helpers_blank.blank?('')).to eq(true) 
      end

      it 'should return true if argument is a string with all spaces' do
        expect(@helpers_blank.blank?('   ')).to eq(true) 
      end

      it 'should return false if argument is not nil or a string' do
        expect(@helpers_blank.blank?(1)).to eq(false) 
        expect(@helpers_blank.blank?(Object.new)).to eq(false) 
      end
    end
  end
end