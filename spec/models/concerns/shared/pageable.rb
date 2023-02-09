RSpec.shared_examples Pageable do
  describe '#page' do

  end

  describe '#pages' do
  end

  describe '#per' do
  end
  
  context 'when pageable records exist' do
    before do
      factory_name = described_class.to_s.downcase
      10.times do 
        create(factory_name.to_sym)
      end
    end

    # quick tests to make sure setup works
    describe '#pages' do
      it 'calculates the number of pages with default per value' do
        stub_const("Pageable::PER_PAGE_DEFAULT", 4)
        expect(described_class.pages).to eq(3)
      end

      it 'calculates the number of pages when per specified' do
        expect(described_class.pages(per: 3)).to eq(4)
      end
    end
  end
end
