require "rails_helper"

RSpec.describe FoodEntryManagement::Update do
  describe ".call" do
    let(:user) { create(:user) }
    let(:food_entry) { create(:food_entry, user: user) }
    let(:meal) { create(:meal, name: "new meal") }
    context "when successful" do
      let(:params) do
        {
          user: user,
          food_entry: food_entry,
          changes: {
            calories: 12345,
            meal: meal,
            eaten_at: "2022-04-09 20:37:38",
            name: "Orange Juice"
          }
        }
      end
      it "updates the food entry record" do
        described_class.call(params)
        params[:changes][:eaten_at] = params[:changes][:eaten_at].to_datetime

        expect(food_entry.reload).to have_attributes(params[:changes])
      end

      it "returns success result with the updated food entry" do
        result = described_class.call(params)

        expect(result.success).to eq(food_entry.reload)
      end
    end

    context "when food entry doesn't belong to user" do
      let(:other_user) { create(:user) }
      let(:params) do
        {
          user: other_user,
          food_entry: food_entry,
          changes: {
            calories: 12345,
            meal: meal,
            eaten_at: "2022-04-09 20:37:38",
            name: "Orange Juice"
          }
        }
      end
      it "returns a failure result with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq("user is not authorized")
      end
    end

    context "when params are invalid" do
      let(:params) do
        {
          user: nil,
          food_entry: food_entry,
          changes: {
            calories: 12345,
            meal: meal,
            eaten_at: "2022-04-09 20:37:38",
            name: "Orange Juice"
          }
        }
      end
      it "returns a failure result with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq("user must be User")
      end
    end
  end
end
