# frozen_string_literal: true

# 
class Pagination::RelationPagination
  def initialize(relation, per_page: relation.per_page)
    @relation = relation
    @per_page = per_page
  end

  attr_reader :per_page

  def count
    @count ||= relation.size
  end

  def current_page_number
    @current_page_number ||= (pages? ? 1 : 0)
  end

  def page(num = current_page_number)
    num = first_page_number if num <= first_page_number
    num = last_page_number if num >= last_page_number

    self.current_page_number = num
    relation.page(current_page_number, per: per_page)
  end

  def pages?
    count.positive?
  end

  def pages
    @pages ||= (pages? ? relation.pages(per_page) : 0)
  end

  def first_page_number
    @first_page_number ||= (pages? ? 1 : 0)
  end

  def last_page_number
    @last_page_number ||= pages
  end

  def next
    current_page += 1 if current_page_number < last_page_number
    current_page
  end

  def previous
    current_page -= 1 if current_page_number > first_page_number
    current_page
  end

  private

  attr_reader :relation
  attr_writer :current_page_number
end
