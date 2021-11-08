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

    render json: { items: query.map(&method(:serialize_rushing)), **pagination.meta_params(query) }
  end

  def export
    items = RushingsQuery.new
                         .filter(params[:query])
                         .sort(*params.values_at(:sort_field, :sort_order))
                         .call
    send_data Export::RushingsCsv.new(items).csv,
              type: "text/csv; charset=utf-8; header=present",
              disposition: "attachment; filename=rushings.csv"
  end

  private

  def pagination
    @pagination ||= Pagination.new(params[:page], params[:per_page])
  end

  def serialize_rushing(rushing) # rubocop:disable Metrics/MethodLength
    {
      player_name: rushing["player_name"],
      team_abbr: rushing["team_abbr"],
      pos: rushing["pos"],
      attempts: rushing["attempts"],
      attempts_per_game: rushing["attempts_per_game"].to_s,
      yds: rushing["yds"],
      avg_yds: rushing["avg_yds"].to_s,
      yds_per_game: rushing["yds_per_game"],
      total_touchdowns: rushing["total_touchdowns"],
      longest: "#{rushing['longest']}#{rushing['longest_t'] ? 'T' : ''}",
      first_downs: rushing["first_downs"],
      first_downs_percentage: rushing["first_downs_percentage"].to_s,
      twenty_plus: rushing["twenty_plus"],
      forty_plus: rushing["forty_plus"],
      fumbles: rushing["fumbles"]
    }
  end
end
