require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    subject { User.new(email: email, password: password) }

    let(:email) { "test@example.com" }
    let(:password) { "password123" }

    context "when valid" do
      it "is valid with a unique email and a password" do
        expect(subject).to be_valid
      end
    end

    context "when invalid" do
      context "without an email" do
        let(:email) { nil }

        it "is not valid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:email]).to include("can't be blank")
        end
      end

      context "without a password" do
        let(:password) { nil }

        it "is not valid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:password]).to include("can't be blank")
        end
      end

      context "with a short password" do
        let(:password) { "short" }

        it "is not valid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:password]).to include("is too short (minimum is 6 characters)")
        end
      end

      context "with a duplicate email" do
        before { User.create(email: email, password: password) } # Create a user with the same email

        it "is not valid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:email]).to include("has already been taken")
        end
      end
    end
  end
end
