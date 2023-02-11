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
    context 'when page param is negative' do
      it 'returns the first page' do
        expect(dummy_class.safe_page_number(-1)).to eq(1)
      end
    end

    context 'when page param is zero' do
      it 'returns the first page' do
        expect(dummy_class.safe_page_number(0)).to eq(1)
      end
    end

    context 'when page param is positive' do
      it 'returns the page param' do
        page_number = 123
        expect(dummy_class.safe_page_number(page_number)).to eq(page_number)
      end
    end
  end

  describe '#safe_per_page' do
    context 'when per param is nil' do
      it 'returns the default per page' do
        expect(dummy_class.safe_per_page).to eq(Pageable::PER_PAGE_DEFAULT)
      end
    end

    context 'when per param is negative' do
      it 'returns the default per page' do
        expect(dummy_class.safe_per_page(-1)).to eq(Pageable::PER_PAGE_DEFAULT)
      end
    end

    context 'when per param is zero' do
      it 'returns the default per page' do
        expect(dummy_class.safe_per_page(0)).to eq(Pageable::PER_PAGE_DEFAULT)
      end
    end

    context 'when per param is positive' do
      it 'returns the per param' do
        per_page = 123
        expect(dummy_class.safe_per_page(per_page)).to eq(per_page)
      end
    end

    context 'when including class overrides #per_page' do
      it 'raises an error with negative value' do
        dummy_class.define_singleton_method(:per_page) { -1 }
        expect{ dummy_class.safe_per_page }.to raise_error(StandardError)
      end

      it 'raises an error with zero value' do
        dummy_class.define_singleton_method(:per_page) { 0 }
        expect{ dummy_class.safe_per_page }.to raise_error(StandardError)
      end

      it 'returns per_page with positive value' do
        dummy_class.define_singleton_method(:per_page) { 1 }
        expect(dummy_class.safe_per_page).to eq(dummy_class.per_page)
      end
    end
  end

  describe '#safe_offset' do
    context 'when params are positive' do
      it 'calculates the offset' do
        page = 3
        per_page = 4
        expected_offset = 8

        expect(dummy_class.safe_offset(3, 4)).to eq(8)
      end
    end

    context 'when params are unsafe values' do
      it 'calculates the offset with default values' do
        expect(dummy_class.safe_offset(-1, -1)).to eq(0)
      end
    end
  end
end