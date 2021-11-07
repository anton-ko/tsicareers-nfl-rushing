class CreateRushings < ActiveRecord::Migration[6.1]
  def change
    create_table :rushings do |t|
      t.string :player_name                                       # Player (Player's name)
      t.string :team_abbr                                         # Team (Player's team abbreviation)
      t.string :pos                                               # Pos (Player's postion)
      t.integer :attempts                                         # Att (Rushing Attempts)
      t.decimal :attempts_per_game, precision: 1, scale: 4        # Att/G (Rushing Attempts Per Game Average)
      t.integer :yds                                              # Yds (Total Rushing Yards)
      t.decimal :avg_yds, precision: 1, scale: 4                  # Avg (Rushing Average Yards Per Attempt)
      t.integer :yds_per_game                                     # Yds/G (Rushing Yards Per Game)
      t.integer :total_touchdowns                                 # TD (Total Rushing Touchdowns)
      t.integer :longest                                          # Lng (Longest Rush
      t.boolean :longest_t, default: false                        #        -- a T represents a touchdown occurred)
      t.integer :first_downs                                      # 1st (Rushing First Downs)
      t.decimal :first_downs_percentage, precision: 1, scale: 4   # 1st% (Rushing First Down Percentage)
      t.integer :twenty_plus                                      # 20+ (Rushing 20+ Yards Each)
      t.integer :forty_plus                                       # 40+ (Rushing 40+ Yards Each)
      t.integer :fumbles                                          # FUM (Rushing Fumbles)

      t.timestamps
    end
  end
end
