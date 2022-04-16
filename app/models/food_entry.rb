class FoodEntry < ApplicationRecord
  belongs_to :user
  belongs_to :meal
  validates_presence_of :name, :eaten_at_date, :eaten_at_time, :calories
  validates_numericality_of :calories, greater_than_or_equal_to: 0
  attribute :eaten_at_time, :string
  scope :meal_entries_for_day, ->(meal, time) { where(meal: meal, eaten_at_date: time.to_date) }
  scope :by_date_eaten, -> { order(eaten_at_date: :desc) }

  # Main job of this is to  deal with eaten_at, other parameters are passed through to ApplicationRecord.find_by
  # @ returns a FoodEntry that matches params passed in or Nil
  def self.find_by_params(params)
    params_eaten_at = params.delete(:eaten_at)
    if params_eaten_at
      eaten_at_date = params_eaten_at.to_date
      eaten_at_time = params_eaten_at.to_time.strftime("%H:%M:%S")
      find_by(params.merge(eaten_at_date: eaten_at_date, eaten_at_time: eaten_at_time))
    else
      find_by(params)
    end
  end

  def eaten_at
    if eaten_at_date
      "#{eaten_at_date} #{eaten_at_time}".to_datetime
    end
  end

  def eaten_at=(eaten_at_datetime)
    self.eaten_at_date = eaten_at_datetime.to_date

    self.eaten_at_time = eaten_at_datetime.to_time.strftime("%H:%M:%S")
  end

  def eaten_at_time
      eaten_at_time_before_type_cast.to_s
  end

end
