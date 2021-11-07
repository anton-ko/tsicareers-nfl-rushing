require "rails_helper"

RSpec.describe "Rushings", type: :request do
  describe "GET /rushings" do
    it "returns http success" do
      get "/rushings"
      expect(response).to have_http_status(:success)
    end

    pending "more coverage"
  end
end
