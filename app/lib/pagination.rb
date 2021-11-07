class Pagination
  DEFAULT_PER_PAGE = 15
  attr_accessor :page, :per_page

  def initialize(page, per_page)
    @page = page&.to_i || 1
    @per_page = per_page.presence || DEFAULT_PER_PAGE
  end

  def apply(scope)
    scope.page(page).per(per_page)
  end

  def meta_params(scope)
    page_params(scope).merge(
      total_count: scope.total_count,
      total_pages: scope.total_pages
    )
  end

  def page_params(scope)
    {
      page: scope.current_page,
      per_page: scope.limit_value
    }
  end
end
