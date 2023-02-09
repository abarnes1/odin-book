class RelationPagination
  def initialize(relation, per_page: relation.per_page_value)
    @relation = relation
    @per_page = per_page
    @current_page = 0
  end

  def page(num)
    num = first_page if num <= first_page
    num = last_page if num >= last_page

    current_page = num
    relation.page(current_page).per(per_page)
  end

  def first_page
    @first_page ||= (pages? ? 1 : 0)
  end

  def last_page
    @last_page ||= pages
  end

  def pages?
    count.positive?
  end

  def pages
    @pages ||= (pages? ? relation.pages(per_page) : 0)
  end

  def count
    @count ||= relation.size
  end

  def next
    current_page += 1 if current_page < last_page
    current_page
  end

  def previous
    current_page -= 1 if current_page > first_page
    current_page
  end

  private

  attr_reader :relation, :per_page
  attr_accessor :current_page
end
