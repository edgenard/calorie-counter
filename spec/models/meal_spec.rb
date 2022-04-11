require "rails_helper"

RSpec.describe Meal, type: :model do
  describe "validations" do
    it { should belong_to(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:max_entries_per_day) }
    it { should validate_numericality_of(:max_entries_per_day).is_greater_than_or_equal_to(0) }
  end
end
