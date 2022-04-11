module FoodEntryManagement
  class Delete
    include Dry::Monads[:result, :do]
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call
    end

    private

    attr_reader :params
    private_class_method :new
  end

  class DeleteContract < Dry::Validation::Contract
  end

  private_constant :DeleteContract
end
