require "rails_helper"

describe CreateUser do
  describe ".call" do
    context "when successful" do
      let(:params) { {email: "user@example.com", password: "abcd1234", password_confirmation: "abcd1234"} }

      it "creates a new user with email in params" do
        described_class.call(params)

        expect(User.find_by(email: params[:email])).not_to be_nil
      end

      it "creates dinner meal for user with default values" do
        described_class.call(params)
        user = User.find_by(email: params[:email])

        expect(Meal.find_by(user: user, name: Meal::DINNER, max_entries_per_day: Meal::DEFAULT_MAX_ENTRIES)).not_to be_nil
      end

      it "creates lunch meal for user with default values" do
        described_class.call(params)
        user = User.find_by(email: params[:email])

        expect(Meal.find_by(user: user, name: Meal::LUNCH, max_entries_per_day: Meal::DEFAULT_MAX_ENTRIES)).not_to be_nil
      end

      it "creates breakfast meal for user with default values" do
        described_class.call(params)
        user = User.find_by(email: params[:email])

        expect(Meal.find_by(user: user, name: Meal::BREAKFAST, max_entries_per_day: Meal::DEFAULT_MAX_ENTRIES)).not_to be_nil
      end

      it "creates a setting for user with default values" do
        described_class.call(params)
        user = User.find_by(email: params[:email])

        expect(Setting.find_by(user: user, max_calories_per_day: Setting::DEFAULT_MAX_CALORIES)).not_to be_nil
      end

      it "returns the new user in the result" do
        result = described_class.call(params)
        user = User.find_by(email: params[:email])

        expect(result.success).to eq(user)
      end
    end

    context "when user creation fails" do
      let(:params) { {email: "user@example.com", password: "abcd1234", password_confirmation: "abcd12345"} }
      it "returns a failure result with user and error message" do
        result = described_class.call(params)

        expect(result.failure).to include(user: be_a(User), message: be_a(String))
      end
    end

    context "when creating any entity fails" do
      let(:params) { {email: "user@example.com", password: "abcd1234", password_confirmation: "abcd1234"} }
      let(:setting_stub) {
        instance_double(
          Setting,
          errors: OpenStruct.new({full_messages: ["Some error creating Settings"]})
        )
      }

      before do
        allow(Setting).to receive(:new).and_return(setting_stub)
        allow(setting_stub).to receive(:save).and_return(false)
      end

      it "does not create any records" do
        described_class.call(params)

        expect(User.find_by(email: params[:email])).to be_nil
        expect(Meal.all).to be_empty
        expect(Setting.all).to be_empty
      end

      it "returns a failure result with error message" do
        result = described_class.call(params)

        expect(result.failure).not_to be_nil
      end
    end
  end
end
