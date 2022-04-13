module FoodEntryManagement
  class Delete
    include Dry::Monads[:result, :do]

    # params { user: User, food_entry: FoodEntry }
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call
      yield validate_params
      food_entry = params[:food_entry]

      food_entry.destroy
      Success()
    end

    private

    attr_reader :params
    private_class_method :new

    def validate_params
      result = DeleteContract.new.call(params)
      if result.success?
        Success()
      else
        error_messages = result.errors(full: true).to_h.values.join(", ")
        Failure(error_messages)
      end
    end
  end

  class DeleteContract < Dry::Validation::Contract
    params do
      required(:user).value(type?: User)
      required(:food_entry).value(type?: FoodEntry)
    end

    rule(:user) do
      if values[:user] && values[:food_entry]
        user = values[:user]
        food_entry = values[:food_entry]
        base.failure("user is not authorized") unless food_entry.user == user
      end
    end
  end

  private_constant :DeleteContract
end
