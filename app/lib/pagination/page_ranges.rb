# frozen_string_literal: true

module Pagination
  # Calculates pagination page ranges for display purposes.
  class PageRanges
    MAX_NEXT_PAGES = 3
    MAX_PREVIOUS_PAGES = 3

    def initialize(current_page:, total_pages:)
      @page_count = total_pages
      @first_page_number = 1
      @previous_pages = nil
      @current_page_number = current_page
      @next_pages = nil
      @last_page_number = total_pages
    end

    attr_reader :current_page_number, :page_count, :first_page_number, :last_page_number

    def previous_pages
      @previous_pages ||= calculate_previous_pages
    end

    def next_pages
      @next_pages ||= calculate_next_pages
    end

    def to_s
      "#{first_page_number}|#{previous_pages.join(', ')}...#{current_page_number}...#{next_pages.join(', ')}|#{last_page_number}"
    end

    private

    def calculate_previous_pages
      previous_pages = []

      MAX_PREVIOUS_PAGES.times do |index|
        previous_page = current_page_number - (index + 1)
        break if previous_page <= first_page_number

        previous_pages << previous_page
      end

      previous_pages.reverse!
    end

    def calculate_next_pages
      next_pages = []

      MAX_NEXT_PAGES.times do |index|
        next_page = current_page_number + (index + 1)
        break if next_page >= last_page_number

        next_pages << next_page
      end

      next_pages
    end
  end
end
