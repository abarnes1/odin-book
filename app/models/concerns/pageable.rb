module Pageable
  extend ActiveSupport::Concern

  included do
    scope :page, ->(page_number, per = nil) { offset((page_number - 1) * page_number).limit(per || per_page_value) }
    scope :pages, ->(per = nil) { (size / (per || per_page_value)) + 1 }
    scope :per, ->(per_page) { limit(per_page) }

    def self.per_page_default
      10
    end

    def self.per_page_value
      if respond_to?(:per_page_override)
        per_page_override
      else
        per_page_default
      end
    end
  end
end
