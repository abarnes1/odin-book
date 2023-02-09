module Pageable
  extend ActiveSupport::Concern

  PER_PAGE_DEFAULT = 10

  included do
    scope :page, ->(page_number: 1, per: nil) { offset(safe_offset(page_number, per)).limit(safe_per_page(per)) }
    scope :pages, ->(per: nil) { (size.to_f / safe_per_page(per)).ceil }

    def self.per_page
      PER_PAGE_DEFAULT
    end

    def self.safe_page_number(page_number)
      return 1 if page_number < 2

      page_number
    end

    def self.safe_per_page(per)
      if per_page.negative? || per_page.zero?
        raise RangeError, "#{ancestors.first} class override of #page_number must return a positive number."
      end

      return per_page if per.nil? || per <= 0

      per
    end

    def self.safe_offset(page_number, per)
      (safe_page_number(page_number) - 1) * safe_per_page(per)
    end
  end
end
