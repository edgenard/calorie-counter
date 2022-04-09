require "rails_helper"

describe AuthenticateUser do
  describe ".authenticate" do
    context "when authentication parameters are correct" do
      let(:user) { create(:user) }
      let(:authentication_params) { {email: user.email, password: user.password} }
      it "returns a successful result" do
        result = described_class.call(authentication_params)

        expect(result.success?).to eq(true)
      end

      it "result includes authenticated user" do
        value = described_class.call(authentication_params).value!

        expect(value[:user]).to eq(user)
      end

      it "result includes token with authenticated user id" do
        value = described_class.call(authentication_params).value!
        token = RequestToken.decode(value[:token])

        expect(token[:user_id]).to eq(user.id)
      end
    end
  end
end
