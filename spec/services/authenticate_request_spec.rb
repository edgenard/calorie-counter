require "rails_helper"

describe AuthenticateRequest do
  describe ".call" do
    let(:user) { create(:user) }
    context "when request is valid" do
      let(:token) { RequestToken.encode({user_id: user.id}) }

      it "returns successful result" do
        result = described_class.call(token)

        expect(result.success?).to eq(true)
      end

      it "returns an instance of the current user in result" do
        result = described_class.call(token)

        expect(result.success).to eq(user)
      end
    end

    context "when request is invalid" do
      let(:token) { RequestToken.encode({user_id: user.id}, 1.hour.ago) }

      it "returns a failure" do
        result = described_class.call(token)

        expect(result.failure?).to eq(true)
      end
    end
  end
end
