require 'rails_helper'

RSpec.describe Pageable do
  let!(:dummy_class) { dummy_class = Class.new(ApplicationRecord).include(Pageable) }

  describe '#per_page' do
    context 'when including model does not override' do
      it 'returns the default value' do
        expect(dummy_class.per_page).to eq(Pageable::PER_PAGE_DEFAULT)
      end
    end

    context 'when including model overrides method' do
      it 'returns the override value' do
        per_page = 3
        dummy_class.define_singleton_method(:per_page) { per_page }

        expect(dummy_class.per_page).to eq(per_page)
      end
    end
  end

  describe '#safe_page_number' do
    context 'when page is negative' do
      it 'returns the default per page value' do
      end
    end

    context 'when page is zero' do
      it 'returns the default per page value' do

      end
    end

    context 'when page is positive' do
      it 'returns the provided page number' do
        
      end
    end
  end
end