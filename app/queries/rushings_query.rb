class RushingsQuery
  SORT_FIELDS = [:id, :yds, :longest, :total_touchdowns].freeze
  SORT_ORDERS = [:asc, :desc].freeze

  DEFAULT_SORT_FIELD = :id
  DEFAULT_SORT_ORDER = :asc

  def initialize(scope = Rushing.all)
    @scope = scope
  end

  def filter(query)
    @filter = query

    self
  end

  def sort(field, order)
    raise QueryArgumentError, "Invalid field name" if field.present? && !SORT_FIELDS.include?(field.to_sym)
    raise QueryArgumentError, "Invalid sort order" if order.present? && !SORT_ORDERS.include?(order.to_sym)

    @sort_field = field
    @sort_order = order

    self
  end

  def call
    @scope = apply_filter
    @scope = apply_sort

    @scope
  end

  private

  def apply_filter
    return @scope if @filter.blank?

    # SQLite doesn't support ILIKE queries: @scope.where("player_name ILIKE ?", "%#{@filter}%")
    @scope.where("UPPER(player_name) LIKE ?", "%#{@filter.upcase}%")
  end

  def apply_sort
    field = @sort_field.presence || DEFAULT_SORT_FIELD
    order = @sort_order.presence || DEFAULT_SORT_ORDER

    @scope.order(field => order)
  end
end
