require 'rails_helper'

RSpec.describe Pagination::PageRanges do
  page = 5
  pages = 10
  subject { described_class.new(current_page: page, total_pages: pages)}

  describe '#page_count' do
    it 'returns the page count' do
      expect(subject.page_count).to eq(pages)
    end
  end

  describe '#current_page_number' do
    it 'returns the current page number' do
      expect(subject.current_page_number).to eq(page)
    end
  end

  describe '#first_page_number' do
    it 'returns page 1' do
      expect(subject.first_page_number).to eq(1)
    end
  end

  describe '#previous_pages' do
    it 'returns the maximum previous pages' do
      expect(subject.previous_pages).to eq([2, 3, 4])
    end

    context 'when the maximum previous pages is not possible' do
      subject { described_class.new(current_page: 4, total_pages: 5)}

      it 'returns a partial set' do
        expect(subject.previous_pages).to eq([2, 3])
      end

      it 'does not include the first page in the partial set' do
        expect(subject.previous_pages).to eq([2, 3])
      end
    end

    context 'when no previous pages are possible' do
      subject { described_class.new(current_page: 1, total_pages: 5)}

      it 'returns no pages' do
        expect(subject.previous_pages).to be_empty
      end
    end
  end

  describe '#next_pages' do
    it 'returns the maximum next pages' do
      expect(subject.next_pages).to eq([6, 7, 8])
    end

    context 'when the maximum next pages is not possible' do
      subject { described_class.new(current_page: 2, total_pages: 5)}

      it 'returns a partial set' do
        expect(subject.next_pages).to eq([3, 4])
      end

      it 'does not include the last page in the partial set' do
        expect(subject.next_pages).not_to include(subject.last_page_number)
      end
    end

    context 'when no next pages are possible' do
      subject { described_class.new(current_page: 5, total_pages: 5)}

      it 'returns no pages' do
        expect(subject.next_pages).to be_empty
      end
    end
  end

  describe '#last_page_number' do
    it 'returns the last page' do
      expect(subject.last_page_number).to eq(pages)
    end
  end
end