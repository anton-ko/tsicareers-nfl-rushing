require "rails_helper"

describe Import::RushingsImporter do
  let(:rushing) { build_stubbed(:rushing) }
  let(:rushing2) { build_stubbed(:rushing) }

  describe ".import_list" do
    it "imports each record" do
      allow(described_class).to receive(:import)

      described_class.import_list([rushing, rushing2])

      expect(described_class).to have_received(:import).with(rushing)
      expect(described_class).to have_received(:import).with(rushing2)
    end
  end

  describe ".import" do
    let(:player_name) { "John Smith" }
    let(:input) { { "Player" => player_name } }

    it "creates a new Rushing record from attributes" do
      allow(described_class).to receive(:rushing_attributes).with(input).and_return({ player_name: player_name })

      expect { described_class.import(input) }.to change(Rushing, :count).by(1)
      expect(Rushing.last.player_name).to eq(player_name)
    end
  end

  describe ".rushing_attributes" do
    let(:rushing_input) do
      { "Player" => "Joe Banyard", "Team" => "JAX", "Pos" => "RB", "Att" => 2, "Att/G" => 2.3,
        "Yds" => "1,024", "Avg" => 3.5, "Yds/G" => 7, "TD" => 2, "Lng" => "75T", "1st" => 2,
        "1st%" => 33.3, "20+" => 1, "40+" => 0, "FUM" => 1 }
    end

    let(:expected_output) do
      { player_name: "Joe Banyard",
        team_abbr: "JAX",
        pos: "RB",
        attempts: 2,
        attempts_per_game: 2.3,
        yds: 1024,
        avg_yds: 3.5,
        yds_per_game: 7,
        total_touchdowns: 2,
        longest: 75,
        longest_t: true,
        first_downs: 2,
        first_downs_percentage: 33.3,
        twenty_plus: 1,
        forty_plus: 0,
        fumbles: 1 }
    end

    it "transforms input hash into Rushing attributes" do
      expect(described_class.rushing_attributes(rushing_input)).to eq(expected_output)
    end
  end
end
