require "rails_helper"

RSpec.describe FoodEntryManagement::Delete do
  describe ".call" do
    let(:user) { create(:user) }
    let(:food_entry) { create(:food_entry, user: user) }
    let(:params) do
      {
        user: user,
        food_entry: food_entry
      }
    end

    context "when successful" do
      it "deletes the food entry" do
        described_class.call(params)
        expect { food_entry.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns a successful result" do
        result = described_class.call(params)

        expect(result.success?).to eq(true)
      end
    end

    context "when food entry doesn't belong to user" do
      let(:other_user) { create(:user) }
      let(:params) do
        {
          user: other_user,
          food_entry: food_entry
        }
      end
      it "returns a failure with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq("user is not authorized")
      end
    end

    context "when parameters are invalid" do
      let(:params) do
        {
          user: user,
          food_entry: nil
        }
      end
      it "returns a failure with error message" do
        result = described_class.call(params)

        expect(result.failure).to eq("food_entry must be FoodEntry")
      end

    end
  end
end
