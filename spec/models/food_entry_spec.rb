require "rails_helper"

RSpec.describe FoodEntry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:meal) }
  it { should validate_presence_of(:calories) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:eaten_at) }
  it { should validate_numericality_of(:calories).is_greater_than_or_equal_to(0) }
end
