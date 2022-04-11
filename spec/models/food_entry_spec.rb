require "rails_helper"

RSpec.describe FoodEntry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:meal) }
  it { should validate_presence_of(:calories) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:eaten_at) }
  it { should validate_numericality_of(:calories).is_greater_than_or_equal_to(0) }

  describe ".meal_entries_for_day" do
    let(:meal) { create(:meal) }
    let(:day_1) { Time.current.middle_of_day }
    let(:day_2) { 1.day.ago.middle_of_day }
    context "when entries have the same meal" do
      let!(:entries_for_today) do
        [
          create(:food_entry, meal: meal, eaten_at: day_1 - 1.hour),
          create(:food_entry, meal: meal, eaten_at: day_1 + 2.hours),
          create(:food_entry, meal: meal, eaten_at: day_1)
        ]
      end
      let!(:entries_for_yesterday) do
        [
          create(:food_entry, meal: meal, eaten_at: day_2),
          create(:food_entry, meal: meal, eaten_at: day_2 - 1.hour),
          create(:food_entry, meal: meal, eaten_at: day_2 + 1.hour)
        ]
      end

      it "only finds entries for the day given" do
        expect(FoodEntry.meal_entries_for_day(meal, day_1)).to eq(entries_for_today)
        expect(FoodEntry.meal_entries_for_day(meal, day_2)).to eq(entries_for_yesterday)
      end
    end

    context "when entries have different meals on the same day" do
      let(:meal_2) { create(:meal) }
      let!(:entries_with_same_meal) do
        [
          create(:food_entry, meal: meal, eaten_at: day_1 - 1.hour),
          create(:food_entry, meal: meal, eaten_at: day_1 + 2.hours),
          create(:food_entry, meal: meal, eaten_at: day_1)
        ]
      end

      let!(:entries_with_different_meal) do
        [
          create(:food_entry, meal: meal_2, eaten_at: day_1 - 1.hour),
          create(:food_entry, meal: meal_2, eaten_at: day_1 + 2.hours),
          create(:food_entry, meal: meal_2, eaten_at: day_1)
        ]
      end
      it "only finds entries for the meal given" do
        expect(FoodEntry.meal_entries_for_day(meal, day_1)).to eq(entries_with_same_meal)
      end
    end
  end
end
