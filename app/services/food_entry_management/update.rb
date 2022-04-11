module FoodEntryManagement
  class Update
    include Dry::Monads[:result, :do]
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call
      validated_params = yield validate_params
      food_entry = validated_params[:food_entry]
      food_entry.update!(validated_params[:changes])
      Success(food_entry)
    end

    private

    attr_reader :params
    private_class_method :new

    def validate_params
      result = UpdateContract.new.call(params)
      if result.success?
        Success(result.to_h)
      else
        error_messages = result.errors(full: true).to_h.values.join(", ")
        Failure(error_messages)
      end
    end
  end

  class UpdateContract < Dry::Validation::Contract
    params do
      required(:user).value(type?: User)
      required(:food_entry).value(type?: FoodEntry)
      required(:changes).hash do
        optional(:calories).value(:integer, gteq?: 0)
        optional(:meal).value(type?: Meal)
        optional(:eaten_at).value(:date_time)
        optional(:name).value(:string)
      end
    end

    rule(:user) do
      if values[:user] && values[:food_entry]
        user = values[:user]
        food_entry = values[:food_entry]
        base.failure("user is not authorized") unless food_entry.user == user
      end
    end

    rule(changes: :meal) do
      if key? && values[:food_entry] && values[:user]
        eaten_at_date = values[:food_entry].eaten_at.to_date
        meal = value
        user = values[:user]
        entries_count = user.food_entries.meal_entries_for_day(meal, eaten_at_date).count

        if entries_count >= value.max_entries_per_day
          base.failure("Maximum food entries reached for #{meal.name} on #{eaten_at_date}")
        end
      end
    end

    rule(changes: :eaten_at) do
      if key? && values[:food_entry] && values[:user]
        eaten_at_date = value.to_date
        meal = values[:food_entry].meal
        user = values[:user]
        entries_count = user.food_entries.meal_entries_for_day(meal, eaten_at_date).count

        if entries_count >= meal.max_entries_per_day
          base.failure("Maximum food entries reached for #{meal.name} on #{eaten_at_date}")
        end
      end
    end

    rule(changes: [:eaten_at, :meal]) do
      if value.compact.count == 2 && values[:food_entry] && values[:user]
        eaten_at_date = value[0].to_date
        meal = value[1]
        user = values[:user]
        entries_count = user.food_entries.meal_entries_for_day(meal, eaten_at_date).count

        if entries_count >= meal.max_entries_per_day
          base.failure("Maximum food entries reached for #{meal.name} on #{eaten_at_date}")
        end
      end
    end
  end

  private_constant :UpdateContract
end
