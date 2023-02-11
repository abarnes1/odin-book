# frozen_string_literal: true

# Adds #page and #pages scopes to model classes.
# Will prevent asking for negative page numbers or negative per page values
# as they would result in invalid SQL statements.  When invalid values
# are requested they will be replaced with safe values that will result
# in valid SQL.
#
# User.page(-1) => User.page(1)
# User.page(2, -1) => User.page(2, 10), where 10 is the default per_page value
#
# Per page values may be overridden in model classes, however,
# invalid values from overridden methods will result in an error rather
# than defaulting to safe values, as invalid values should not be defined
# at a class level.
#
# class User < ApplicationRecord
#   def self.per_page
#     -1
#   end
# end
#
# User.page(1) defaults to User.page(1, -1) and will raise an exception
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

    def self.safe_per_page(per = nil)
      return per unless per.nil? || per <= 0

      if per_page.nil? || per_page <= 0
        raise RangeError, "#{ancestors.first} class override of #per_page must return a positive number."
      end

      per_page
    end

    def self.safe_offset(page_number, per)
      (safe_page_number(page_number) - 1) * safe_per_page(per)
    end
  end
end
