require "rails_helper"

describe RushingsQuery do
  let(:players) { ["john doe", "john smith", "jim jones"] }
  let!(:rushing1) { create(:rushing, player_name: "john doe", longest: 1, yds: 10) }
  let!(:rushing2) { create(:rushing, player_name: "john smith", longest: 2, yds: 20) }
  let!(:rushing3) { create(:rushing, player_name: "jim jones", longest: 3, yds: 30) }

  describe "#sort" do
    it "sorts by longest in descending order" do
      expected_names = [rushing3, rushing2, rushing1].map(&:player_name)

      results = described_class.new.sort(:longest, :desc).call

      expect(results.map(&:player_name)).to match_array(expected_names)
    end

    it "sorts by total yards in ascending order" do
      expected_names = [rushing1, rushing2, rushing3].map(&:player_name)

      results = described_class.new.sort(:yds, :asc).call

      expect(results.map(&:player_name)).to match_array(expected_names)
    end

    it "sorts by id by default" do
      expected_names = [rushing1, rushing2, rushing3].map(&:player_name)
      results = described_class.new.call

      expect(results.map(&:player_name)).to match_array(expected_names)
    end

    it "raises an error when unsortable field is passed" do
      expect { described_class.new.sort(:player_name, :desc).call }.to raise_error(QueryArgumentError)
    end
  end
end
