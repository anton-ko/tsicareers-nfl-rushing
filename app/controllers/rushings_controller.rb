class RushingsController < ApplicationController
  # Accepts params:
  #   query - string to filter player names
  #   sort_field - field to sort on: longest, yds, total_touchdowns
  #   sort_order - asc or desc
  #   page
  #   per_page
  def index
    query = RushingsQuery.new
                         .filter(params[:query])
                         .sort(*params.values_at(:sort_field, :sort_order))
                         .call
                         .then { |q| pagination.apply(q) }

    render json: { items: query.to_json, **pagination.meta_params(query) }
  end

  private

  def pagination
    @pagination ||= Pagination.new(params[:page], params[:per_page])
  end
end
