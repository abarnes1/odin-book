require 'rails_helper'

RSpec.describe RelationPagination do
  describe '#per_page' do
    before do
      let(:dummy_class) { dummy_class = Class.new(ApplicationRecord).include(Pageable) }
    end

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
end