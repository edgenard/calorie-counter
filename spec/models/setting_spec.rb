require "rails_helper"

RSpec.describe Setting, type: :model do
  it { should belong_to(:user) }
  it { should validate_numericality_of(:max_calories_per_day).is_greater_than_or_equal_to(1) }
end
