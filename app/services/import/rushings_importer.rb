module Import
  class RushingsImporter
    class << self
      def import_list(records)
        records.map(&method(:import))
      end

      def import(record)
        Rushing.create!(rushing_attributes(record))
      end

      def rushing_attributes(record) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        {
          player_name: record["Player"],
          team_abbr: record["Team"],
          pos: record["Pos"],
          attempts: record["Att"],
          attempts_per_game: record["Att/G"],
          yds: record["Yds"].yield_self { |yds| yds.is_a?(String) ? yds.delete(",").to_i : yds },
          avg_yds: record["Avg"],
          yds_per_game: record["Yds/G"],
          total_touchdowns: record["TD"],
          longest: record["Lng"].yield_self { |lng| lng.to_s.delete("T").to_i },
          longest_t: record["Lng"].to_s.ends_with?("T"),
          first_downs: record["1st"],
          first_downs_percentage: record["1st%"],
          twenty_plus: record["20+"],
          forty_plus: record["40+"],
          fumbles: record["FUM"]
        }
      end
    end
  end
end
