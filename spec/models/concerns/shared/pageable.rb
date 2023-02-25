RSpec.shared_examples Pageable do
  describe '#pages' do
    let(:ten_model_relation) { create_model_relation(10) }

    before do
      allow(described_class).to receive(:all).and_return(ten_model_relation)
    end

    it 'calculates the number of pages with default per value' do
      stub_const("Pageable::PER_PAGE_DEFAULT", 4)
      expect(described_class.all.pages).to eq(3)
    end

    it 'calculates the number of pages when per is specified' do
      expect(described_class.all.pages(per: 3)).to eq(4)
    end
  end

  describe '#page' do
    let(:ten_model_relation) { create_model_relation(10) }

    before do
      allow(described_class).to receive(:all).and_return(ten_model_relation)
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

  def create_model_relation(count)
    factory_name = described_class.to_s.downcase
    query_results = []
    
    count.times do 
      query_results << create(factory_name.to_sym)
    end

    described_class.where(id: query_results)
  end
end
