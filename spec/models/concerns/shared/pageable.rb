RSpec.shared_examples Pageable do
  # If these tests fail, check #count.  Some top level
  # model tests may be creating records!

  describe '#pages' do
    before do
      create_model(10)
    end

    it 'calculates the number of pages with default per value' do
      stub_const("Pageable::PER_PAGE_DEFAULT", 4)
      expect(described_class.pages).to eq(3)
    end

    it 'calculates the number of pages when per is specified' do
      expect(described_class.pages(per: 3)).to eq(4)
    end
  end

  describe '#page' do
    before do
      create_model(10)
    end

    it 'returns the correct page' do
      stub_const("Pageable::PER_PAGE_DEFAULT", 3)
      expect(described_class.page(4)).to eq([described_class.last])
    end

    context 'when page out of range' do
      it 'returns an empty array' do
        expect(described_class.page(1000)).to eq([])
      end
    end
  end

  private

  def create_model(count)
    factory_name = described_class.to_s.downcase
    
    10.times do 
      create(factory_name.to_sym)
    end
  end
end
