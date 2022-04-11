module FoodEntryManagement
  class Create
    include Dry::Monads[:result, :do]
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call
      validated_params = yield validate_params
      Success(FoodEntry.create!(validated_params))
    end

    private

    attr_reader :params
    private_class_method :new

    def validate_params
      result = CreateContract.new.call(params)
      if result.success?
        Success(result.to_h)
      else
        error_messages = result.errors(full: true).to_h.values.join(", ")
        Failure(error_messages)
      end
    end
  end

  class CreateContract < Dry::Validation::Contract
    params do
      required(:user).value(type?: User)
      required(:meal).value(type?: Meal)
      required(:name).value(:string)
      required(:calories).value(:integer, gteq?: 0)
      required(:eaten_at).value(:date_time)
    end

    rule(:meal) do
      eaten_at_date = values[:eaten_at].to_date
      entries_count = FoodEntry.where(
        meal: value,
        user: values[:user],
        eaten_at: eaten_at_date.beginning_of_day..eaten_at_date.end_of_day
      ).count

      if entries_count >= value.max_entries_per_day
        base.failure("Maximum food entries reached for #{value.name} on #{eaten_at_date}")
      end
    end
  end

  private_constant :CreateContract
end
