require 'rails_helper'

RSpec.describe Pagination::RelationPagination do
  let!(:per_page) { 3 }
  let!(:none_relation) { User.none }
  let!(:all_relation) { User.all.order(:id) }
  let!(:with_no_pages) { described_class.new(none_relation, per_page: per_page) }
  let!(:with_four_pages) { described_class.new(all_relation, per_page: per_page) }

  before do
    10.times do 
      create(:user)
    end
  end

  describe '#count' do
    it 'returns the number of records' do
      expect(all_relation.count).to eq(10)
    end
  end

  describe '#current_page_number' do
    context 'when no pages exist' do
      it 'returns 0' do
        expect(with_no_pages.current_page_number).to eq(0)
      end
    end

    context 'when pages exist' do
      it 'returns 1 after initialization' do
        expect(with_four_pages.current_page_number).to eq(1)
      end
    end

    context 'when set by accessing a page' do
      let(:subject) { with_four_pages }

      it 'returns the requested page' do
        requested_page = 2
        subject.page(requested_page)

        expect(subject.current_page_number).to eq(requested_page)
      end

      it 'returns first page when negative page requested' do
        subject.page(-1)

        expect(subject.current_page_number).to eq(subject.first_page_number)
      end

      it 'returns last page when out of range page requested' do
        subject.page(1000)

        expect(subject.current_page_number).to eq(subject.last_page_number)
      end
    end
  end

  describe '#page' do
    context 'when page too low' do
      it 'returns the first page' do
        first_page = all_relation.limit(per_page)

        expect(with_four_pages.page(-1)).to match_array(first_page)
      end
    end

    context 'when page too high' do
      it 'returns the last page' do
        last_page = [all_relation.last]

        expect(with_four_pages.page(1000)).to match_array(last_page)
      end
    end

    it 'returns the correct page' do
      second_page = all_relation.limit(per_page).offset(per_page)

      expect(with_four_pages.page(2)).to match_array(second_page)
    end
  end

  describe '#pages?' do
    context 'when no page exist' do
      it 'returns false' do
        expect(with_no_pages.pages?).to be false
      end
    end

    context 'when pages exist' do
      it 'returns true' do
        expect(with_four_pages.pages?).to be true
      end
    end
  end

  describe '#pages' do
    context 'when no pages exist' do
      it 'returns 0' do
        expect(with_no_pages.pages).to eq(0)
      end
    end

    context 'when pages exist' do
      it 'returns the page count' do
        expect(with_four_pages.pages).to eq(4)
      end
    end
  end

  describe '#first_page_number' do
    context 'when no pages exist' do
      it 'returns 0' do
        expect(with_no_pages.first_page_number).to eq(0)
      end
    end

    context 'when pages exist' do
      it 'returns 1' do
        expect(with_four_pages.first_page_number).to eq(1)
      end
    end
  end

  describe '#last_page_number' do
    context 'when no pages exist' do
      it 'returns 0' do
        expect(with_no_pages.last_page_number).to eq(0)
      end
    end

    context 'when pages exist' do
      it 'returns the last page' do
        expect(with_four_pages.last_page_number).to eq(with_four_pages.pages)
      end
    end
  end

  describe '#next' do
    it 'returns self' do
      expect(with_four_pages.next).to eq(with_four_pages)
    end

    it 'increments the current page' do
      with_four_pages.page(1)

      expect(with_four_pages.next.current_page_number).to eq(2)
    end

    context 'when on the last page' do
      it 'does not increment the current page' do
        with_four_pages.page(4)

        expect(with_four_pages.next.current_page_number).to eq(4)
      end
    end
  end

  describe '#previous' do
    it 'returns self' do
      expect(with_four_pages.previous).to eq(with_four_pages)
    end

    it 'decrements the current page' do
      with_four_pages.page(2)

      expect(with_four_pages.previous.current_page_number).to eq(1)
    end

    context 'when on the first page' do
      it 'does not decrement the current page' do
        with_four_pages.page(1)
        
        expect(with_four_pages.previous.current_page_number).to eq(1)
      end
    end
  end
end