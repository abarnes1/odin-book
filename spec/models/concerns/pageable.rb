RSpec.shared_examples Pageable do
  context 'when records exist' do
    before do
      # How to build list of n models here without knowing the model's class?
      # This will work, assuming the method signatures for #create match:
      #   create(described_class.to_s.downcase.to_sym)
      # However, for this signature to match the comment factory must also create a user.
      # 
      # Alternatives:
      #  1) Pass in a build method to call n times.
      #    - Ultimately could not figure out how to get this to work.
      #    - Thought it would add unnecessary complexity anyway.  Would prefer
      #      this to just work without adding setup to classes that include the
      #      Pageable concern.
      #  2) Test as a standalone file once with a mock or dummy class.
      #    - Could not figure out how to fake an ActiveRecord::Relation, which is needed to test
      #      scopes.  They're more complex than I thought.
      #  3) Create a new single column table for the test and tear it down after. 
      #     - Would prefer to test with real objects that include the concern even if the tests
      #       have to repeat for each including class.

      factory_symbol = described_class.to_s.downcase.to_sym
      10.times do 
        create(factory_symbol)
      end
    end

    # quick tests to make sure setup works
    describe '#pages' do
      it 'calculates the number of pages with default per value' do
        allow(described_class).to receive(:per_page_default).and_return(6)
        expect(described_class.pages).to eq(2)
      end

      it 'calculates the number of pages when per specified' do
        expect(described_class.pages(per = 3)).to eq(4)
      end
    end
  end
end
