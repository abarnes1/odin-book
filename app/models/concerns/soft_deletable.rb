module SoftDeletable
  extend ActiveSupport::Concern

  included do
    def soft_delete
      self.soft_deleted = true
      self
    end

    def soft_restore
      self.soft_deleted = false
      self
    end

    def soft_deleted?
      soft_deleted
    end

    private

    def field_type_default(field)
      self.class.field_type_default(field)
    end
  end

  class_methods do
    def soft_deletable(*fields, **fields_with_override)
      fields.each do |field|
        set_soft_deletable_field(field)
      end

      fields_with_override.each_pair do |field, override|
        set_soft_deletable_field(field, override)
      end
    end

    def set_soft_deletable_field(field, override = nil)
      unless column_names.include?(field.to_s)
        raise ArgumentError, "Soft deletable field #{field} unknown for class #{name}"
      end

      define_method field do
        soft_deleted? ? (override || field_type_default(field)) : super()
      end

      define_method "original_#{field}".to_sym do
        self[field]
      end
    end

    def active_record_field_type(field)
      columns_hash[field.to_s].type
    end

    def field_type_default(field)
      active_record_field_type = active_record_field_type(field)
      return 'String is soft deleted.' if active_record_field_type == :string

      raise ArgumentError, "Default soft deleted value for field type #{active_record_field_type} does not exist. "\
        'A value must be provided.'
    end
  end
end
