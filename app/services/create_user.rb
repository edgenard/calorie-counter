class CreateUser
  include Dry::Monads[:result, :do]

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      user = yield create_user
      yield create_starter_meals(user)
      yield create_user_setting(user)
      Success(user)
    end
  end

  private

  attr_reader :params, :user
  private_class_method :new

  def create_user
    @user = User.create(params)
    if user.persisted?
      Success(user)
    else
      Failure(user: user, message: user.errors.full_messages.join(", "))
    end
  end

  def create_starter_meals(user)
    meals = Meal.create([
      {user: user, name: Meal::DINNER, max_entries_per_day: Meal::DEFAULT_MAX_ENTRIES},
      {user: user, name: Meal::LUNCH, max_entries_per_day: Meal::DEFAULT_MAX_ENTRIES},
      {user: user, name: Meal::BREAKFAST, max_entries_per_day: Meal::DEFAULT_MAX_ENTRIES}
    ])

    if meals.all?(&:persisted?)
      Success()
    else
      error_messages = meals.map { |meal| meal.errors.full_messages.join(", ") }
      Failure(user: user, message: error_messages)
    end
  end

  def create_user_setting(user)
    setting = Setting.new(user: user, max_calories_per_day: Setting::DEFAULT_MAX_CALORIES)
    if setting.save
      Success()
    else
      Failure(user: user, messsage: setting.errors.full_messages.join(", "))
    end
  end
end
