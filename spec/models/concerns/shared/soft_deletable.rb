RSpec.shared_examples SoftDeletable do
  let(:soft_deletable_model) { described_class.new }

  describe '#soft_deleted?' do
    it 'is initialized to false' do
      expect(soft_deletable_model).not_to be_soft_deleted
    end
  end

  describe '#soft_delete' do
    it 'sets soft_deleted attribute to true' do
      soft_deletable_model.soft_restore
      expect(soft_deletable_model.soft_delete).to be_soft_deleted
    end
  end

  describe '#soft_restore' do
    it 'sets soft_deleted attribute to false' do
      soft_deletable_model.soft_delete
      expect(soft_deletable_model.soft_restore).not_to be_soft_deleted
    end
  end

  describe '#soft_deletable' do
    valid_attribute = :some_valid_column

    before do 
      allow(described_class).to receive(:column_names).and_return(["#{valid_attribute}"])
      described_class.soft_deletable(valid_attribute)
    end

    it 'defines the attribute method' do
      expect(soft_deletable_model).to respond_to(valid_attribute)
    end

    it 'defines the original attribute method' do
      original_method_name = "original_#{valid_attribute}".to_sym
      expect(soft_deletable_model).to respond_to(original_method_name)
    end
    
    context 'when the attribute is invalid' do
      invalid_attribute = :this_attribute_wont_exist

      it 'raises an argument exception' do
        expect { described_class.soft_deletable(invalid_attribute) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#field_type_default' do
    valid_attribute = :some_valid_column

    before do 
      allow(described_class).to receive(:column_names).and_return(["#{valid_attribute}"])
      described_class.soft_deletable(valid_attribute)
    end

    context 'when field type is :string' do
      it 'returns the default string' do
        allow(described_class).to receive(:active_record_field_type).with(valid_attribute).and_return(:string)
        expect(described_class.field_type_default(valid_attribute)).to eq('String is soft deleted.')
      end
    end

    context 'when field type default is not defined' do
      valid_attribute = :some_valid_column

      before do 
        allow(described_class).to receive(:column_names).and_return(["#{valid_attribute}"])
        described_class.soft_deletable(valid_attribute)
      end

      it 'raises an argument exception' do
        allow(described_class).to receive(:active_record_field_type).with(valid_attribute).and_return(:some_invalid_field_type)
        expect{ described_class.field_type_default(valid_attribute) }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'defined attribute method' do
    valid_attribute = :some_valid_column
    soft_deleted_value = "It's gone!"

    before do 
      allow(described_class).to receive(:column_names).and_return(["#{valid_attribute}"])
      described_class.soft_deletable(some_valid_column: soft_deleted_value)
    end

    context 'when soft deleted' do
      it 'returns the soft deleted value' do
        soft_deleted_model = described_class.new(soft_deleted: true)
        expect(soft_deleted_model.send(valid_attribute)).to eq(soft_deleted_value)
      end
    end
  end

  describe 'original defined attribute method' do
    valid_attribute = :some_valid_column
    soft_deleted_value = "It's gone!"

    before do 
      allow(described_class).to receive(:column_names).and_return(["#{valid_attribute}"])
      described_class.soft_deletable(some_valid_column: soft_deleted_value)
    end

    context 'when soft deleted' do
      it 'returns the soft deleted value' do
        original_method_name = "original_#{valid_attribute}".to_sym
        original_value = 'Not gone!'

        soft_deleted_model = described_class.new(soft_deleted: true)
        allow(soft_deleted_model).to receive(original_method_name).and_return(original_value)
        expect(soft_deleted_model.send(original_method_name)).to eq(original_value)
      end
    end
  end
end