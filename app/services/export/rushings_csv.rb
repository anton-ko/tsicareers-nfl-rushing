require 'csv'

module Export
  class RushingsCsv
    def initialize(collection)
      @collection = collection
    end

    def csv
      CSV.generate do |csv|
        csv << header
        @collection.find_each do |record|
          csv << row(record)
        end
      end
    end

    def header
      ["Player", "Team", "Pos", "Att/G", "Att", "Yds", "Avg", "Yds/G", "TD", "Lng", "1st", "1st%", "20+", "40+", "FUM"]
    end

    def row(record) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      [
        record.player_name,
        record.team_abbr,
        record.pos,
        record.attempts,
        record.attempts_per_game.to_s,
        record.avg_yds.to_s,
        record.yds_per_game,
        record.total_touchdowns,
        "#{record.longest}#{record.longest_t ? 'T' : ''}",
        record.first_downs,
        record.first_downs_percentage.to_s,
        record.twenty_plus,
        record.forty_plus,
        record.fumbles
      ]
    end
  end
end
