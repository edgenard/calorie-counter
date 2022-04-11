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

    context "when updating associated meal but max entries exceeded for that day" do
      let(:other_meal) { create(:meal, max_entries_per_day: 0) }
      let(:params) do
        {
          user: user,
          food_entry: food_entry,
          changes: {
            meal: other_meal
          }
        }
      end

      it "returns a failure result with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq(
          "Maximum food entries reached for #{other_meal.name} on #{food_entry[:eaten_at].to_date}"
        )
      end
    end

    context "when updating eaten_at but max_entries exceeded for that day" do
      let(:meal) { create(:meal, max_entries_per_day: 1) }
      let(:food_entry) { create(:food_entry, user: user, meal: meal) }
      let(:params) do
        {
          user: user,
          food_entry: food_entry,
          changes: {
            eaten_at: "2022-04-09 21:37:38"
          }
        }
      end

      before do
        # Creating previous FoodEntry that reached max entries for that day
        create(:food_entry, user: user, eaten_at: "2022-04-09 00:37:00", meal: meal)
      end

      it "returns a failure result with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq(
          "Maximum food entries reached for #{food_entry.meal.name} on #{params[:changes][:eaten_at].to_date}"
        )
      end
    end

    context "when updating eaten_at and meal but max entries exceeded for that meal for that day" do
      let(:meal) { create(:meal, max_entries_per_day: 1, name: "Other Meal") }
      let(:food_entry) { create(:food_entry, user: user) }
      let(:params) do
        {
          user: user,
          food_entry: food_entry,
          changes: {
            eaten_at: "2022-04-09 21:37:38",
            meal: meal
          }
        }
      end

      before do
        # Creating previous FoodEntry that reached max entries for that day
        create(:food_entry, user: user, eaten_at: "2022-04-09 00:37:00", meal: meal)
      end

      it "returns a failure result with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq(
          "Maximum food entries reached for #{meal.name} on #{params[:changes][:eaten_at].to_date}"
        )
      end
    end
  end
end
