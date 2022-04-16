require "rails_helper"

RSpec.describe FoodEntryManagement::Create do
  describe ".call" do
    let(:user) { create(:user) }
    let(:meal) { create(:meal, user: user) }
    context "when successful" do
      let(:params) do
        {
          user: user,
          meal: meal,
          name: "steak",
          calories: 1000,
          eaten_at: "2022-04-10 21:37:38"
        }
      end

      it "saves a new food entry record" do
        described_class.call(params)

        expect(FoodEntry.find_by_params(params)).not_to be_nil
      end

      it "returns a success result with food entry record" do
        result = described_class.call(params)

        expect(result.success).to eq(FoodEntry.find_by_params(params))
      end
    end

    context "when parameters are invalid" do
      let(:params) do
        {
          user: user,
          meal: meal,
          name: "steak",
          calories: 1000,
          eaten_at: nil
        }
      end

      it "returns a failure result with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq("eaten_at must be a date time")
      end
    end

    context "when max number of entries per day meal is exceeded" do
      let(:meal) { create(:meal, user: user, max_entries_per_day: 0) }
      let(:params) do
        {
          user: user,
          meal: meal,
          name: "steak",
          calories: 1000,
          eaten_at: "2022-04-10 21:37:38"
        }
      end

      it "returns a failure with with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq(
          "Maximum food entries reached for #{meal.name} on #{params[:eaten_at].to_date}"
        )
      end
    end
  end
end
