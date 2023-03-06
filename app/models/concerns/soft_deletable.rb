module SoftDeletable
  extend ActiveSupport::Concern

  def self.thing
    'thang'
  end

  def self.zzzzz
    'zzzzz'
  end

  # def self.with_soft_deletable_fields(soft_deletable_fields = {})
  def self.with_soft_deletable_fields(*fields, **fields_with_override)
    Module.new do
      include SoftDeletable

      fields.each do |field|
        set_soft_deletable_field(field)
      end

      fields_with_override.each_pair do |field, override|
        set_soft_deletable_field(field, override)
      end
    end
  end

  # instance methods
  included do
    def soft_delete
      self.soft_deleted = true
    end

    def soft_restore
      self.soft_deleted = false
    end

    def soft_deleted?
      soft_deleted
    end
  end

  class_methods do
    def yyyyyy
      'yyyyy'
    end

    def set_soft_deletable_field(field, override = nil)
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

      raise ArgumentError, "Active Record field type #{active_record_field_type} not supported for soft deletion."
    end
  end
end
