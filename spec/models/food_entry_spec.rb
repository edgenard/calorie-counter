require "rails_helper"

RSpec.describe FoodEntry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:meal) }
  it { should validate_presence_of(:calories) }
  it { should validate_presence_of(:eaten_at_date) }
  it { should validate_presence_of(:eaten_at_time) }
  it { should validate_presence_of(:name) }
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

  describe ".by_date_eaten" do
    context "when food entries are at different dates" do
      it "returns entries in descending order of eaten at date" do
        entry1 = create(:food_entry, name: "Entry 1", eaten_at: "2022-04-11")
        entry2 = create(:food_entry, name: "Entry 2", eaten_at: "2022-04-10")
        entry3 = create(:food_entry, name: "Entry 3", eaten_at: "2022-04-15")

        expect(FoodEntry.by_date_eaten).to eq([entry3, entry1, entry2])
      end
    end

    context "when food entries are the same day" do
      it "returns entries from earliest to latest" do
        entry1 = create(:food_entry, name: "Breakfast", eaten_at: "2022-04-11 08:00AM")
        entry2 = create(:food_entry, name: "Lunch", eaten_at: "2022-04-11 12:00PM")
        entry3 = create(:food_entry, name: "Dinner", eaten_at: "2022-04-11 6:00PM")

        expect(FoodEntry.by_date_eaten).to eq([entry1, entry2, entry3])
      end
    end
  end

  describe ".find_by_params" do
    let(:food_entry) { create(:food_entry) }
    let(:params) do
      {
        name: food_entry.name,
        meal: food_entry.meal,
        calories: food_entry.calories,
        eaten_at: food_entry.eaten_at
      }
    end

    context "when given all possible params" do
      it "returns the right record" do
        create(:food_entry, name: food_entry.name, meal: food_entry.meal, calories: food_entry.calories)
        expect(FoodEntry.find_by_params(params)).to eq(food_entry)
      end
    end

    context "when just given eaten_at param" do
      it "returns the right record" do
        expect(FoodEntry.find_by_params(eaten_at: food_entry.eaten_at)).to eq(food_entry)
      end
    end

    context "when given no params" do
      it "returns nil" do
        expect(FoodEntry.find_by_params({})).to eq(nil)
      end
    end

    context "when not given eaten_at" do
      it "returns the right record" do
        expect(FoodEntry.find_by_params(params.except(:eaten_at))).to eq(food_entry)
      end
    end
  end

  describe "#eaten_at" do
    let(:food_entry) { create(:food_entry, eaten_at: "2022-04-11 08:00PM") }

    it "populates eaten_at_date as a a date" do
      expect(food_entry.eaten_at_date).to eq(Date.new(2022, 04,11))
    end

    it "populates eaten_at_time as a string" do
      expect(food_entry.eaten_at_time).to eq("20:00:00")
    end

    context "when there is no eaten_at_date" do
      it "returns nil"
    end

    context "when there is no eaten_at_time" do
      it "return nil"
    end
  end
end
