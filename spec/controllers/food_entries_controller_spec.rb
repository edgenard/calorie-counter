require "rails_helper"

RSpec.describe FoodEntriesController, type: :controller do
  let(:user) { create(:user, :with_meals) }
  let(:user_token) { AuthenticateUser.call({email: user.email, password: user.password}).value![:token] }
  let(:result_double) { double("result", success?: true) }
  describe "#create" do
    before do
      allow(FoodEntryManagement::Create).to receive(:call).and_return(result_double)
    end
    context "when params have all attributes" do
      let(:request_params) do
        {
          food_entry:
            {
              name: "Steak",
              calories: "1100",
              eaten_at: "2022-04-10T19:33",
              meal: user.meals.first.id.to_s
            },
          user_id: user.id.to_s
        }
      end
      let(:transformed_params) do
        {
          user: user,
          name: "Steak",
          calories: "1100",
          eaten_at: "2022-04-10T19:33",
          meal: user.meals.first
        }
      end

      it "transform request parameters to match service object contract" do
        post :create, params: request_params, session: {token: user_token}

        expect(FoodEntryManagement::Create).to have_received(:call).with(transformed_params)
      end
    end

    context "when params include empty strings in values" do
      let(:request_params) do
        {
          food_entry:
            {
              name: "",
              calories: "1100",
              eaten_at: "2022-04-10T19:33",
              meal: user.meals.first.id.to_s
            },
          user_id: user.id.to_s
        }
      end
      let(:transformed_params) do
        {
          user: user,
          name: nil,
          calories: "1100",
          eaten_at: "2022-04-10T19:33",
          meal: user.meals.first
        }
      end

      it "transform values to nil" do
        post :create, params: request_params, session: {token: user_token}

        expect(FoodEntryManagement::Create).to have_received(:call).with(transformed_params)
      end
    end
  end

  describe "#update" do
    let(:food_entry) { create(:food_entry, meal: user.meals.first) }
    let(:request_params) do
      {
        food_entry:
          {
            name: "Steak",
            calories: "1100",
            eaten_at: "2022-04-10T19:33",
            meal: user.meals.first.id.to_s
          },
        user_id: user.id.to_s,
        id: food_entry.id.to_s,
      }
    end
    let(:transformed_params) do
      {
        user: user,
        food_entry: food_entry,
        changes: {
          name: "Steak",
          calories: "1100",
          eaten_at: "2022-04-10T19:33",
          meal: user.meals.first
        }
      }
    end

    it "transforms parameters to match service object contract" do
      allow(FoodEntryManagement::Update).to receive(:call).and_return(result_double)

      put :update, params: request_params, session: { token: user_token }

      expect(FoodEntryManagement::Update).to have_received(:call).with(transformed_params)
    end
  end

  describe "#destroy" do
    let(:food_entry) { create(:food_entry, user: user) }
    let(:request_params) do
      {
        user_id: user.id.to_s,
        id: food_entry.id.to_s
      }
    end

    let(:transformed_params) do
      {
        user: user,
        food_entry: food_entry
      }
    end

    it "transforms parameters to match service object contract" do
      allow(FoodEntryManagement::Delete).to receive(:call).and_return(result_double)

      delete :destroy, params: request_params, session: {token: user_token }

      expect(FoodEntryManagement::Delete).to have_received(:call).with(transformed_params)
    end
  end
end
