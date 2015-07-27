require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  let(:user){FactoryGirl.create :user}

  describe "#sign_in" do
    describe "Checking currnet_user" do
      it do
        helper.sign_in user
        expect(helper.current_user).to eq user
      end
    end

    describe "Checking remember_token" do
      let(:new_remember_token){"remember_token"}

      before do
        allow(User).to receive(:new_remember_token)
          .and_return new_remember_token
        helper.sign_in user
      end

      it do
        expect(user.remember_token).to eq User.encrypt(new_remember_token)
      end

      it do
        expect(helper.cookies[:remember_token]).to eq new_remember_token
      end
    end
  end

  describe "#currnet_user=" do
    before do
      helper.current_user = user
    end

    it do
      expect(helper.current_user).to eq user
    end
  end

  describe "currnet_user" do
    subject{helper.current_user}

    let(:remember_token){"remember_token"}

    before do
      helper.current_user = nil
      allow(User).to receive(:encrypt).and_return remember_token
      user.update remember_token: remember_token
    end

    it {is_expected.to eq user}
  end

  describe "signed_in?" do
    subject{helper.signed_in?}

    context "when user signed in" do
      before do
        helper.sign_in user
      end

      it {is_expected.to eq true}
    end

    context "when user didn't sign in" do
      it {is_expected.to eq false}
    end
  end

  describe "#sign_out" do
    before do
      helper.sign_in user
      helper.sign_out
    end

    it {expect(helper.current_user).to eq nil}
    it {expect(helper.cookies[:remember_token]).to eq nil}
  end
end
