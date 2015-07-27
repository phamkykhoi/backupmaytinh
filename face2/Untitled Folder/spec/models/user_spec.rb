require "rails_helper"

RSpec.describe User, type: :model do
  let(:user){FactoryGirl.create :user}

  describe "Validation" do
    subject{user}

    [:name].each do |attribute|
      context "when #{attribute} is nil" do
        before{user.send "#{attribute}=", nil}

        it {is_expected.to be_invalid}
      end
    end

    context "when email is precense and password is nil" do
      let(:user){FactoryGirl.build :user}

      before do
        user.email = "example@example.com"
        user.password = nil
      end

      it {is_expected.to be_invalid}
    end

    context "when password is precense and email is nil" do
      before do
        user.email = nil
        user.password = "password"
      end

      it {is_expected.to be_invalid}
    end

    context "when login_id is not unique" do
      let(:other_user){FactoryGirl.create :user}

      before{user.login_id = other_user.login_id}

      it {is_expected.to be_invalid}
    end

    [:google, :twitter].each do |sns|
      context "where there is #{sns}_id and there is not #{sns}_token" do
        before do
          user.send "#{sns}_id=", "456"
          user.send "#{sns}_token=", "token"
          user.save

          user.send "#{sns}_id=", "456"
          user.send "#{sns}_token=", nil
        end

        it {is_expected.to be_invalid}
      end
    end
  end

  describe "#followership_id_with" do
    subject{user.followership_id_with other_user}

    let(:other_user){FactoryGirl.create :user}

    context "when user is following user as argument" do
      let!(:followership) do
        FactoryGirl.create :followership, followee: other_user, follower: user
      end

      it {is_expected.to eq followership.id}
    end

    context "when user is not following user as argument" do
      it {is_expected.to eq nil}
    end
  end

  describe "#latest_monthly_rank" do
    subject{user.latest_monthly_rank}

    let!(:monthly_ranking){FactoryGirl.create MonthlyRanking, m_ranking_type_id: 3}

    context "Get latest monthly rank" do
      before do
        monthly_ranking.ranking_subtotals.create user_id: user.id, rank: 21
      end

      it {is_expected.to eq monthly_ranking.ranking_subtotals.last.try :rank}
    end
  end

  describe "#login?" do
    subject{current_user.login?}

    let!(:current_user){FactoryGirl.create User}

    context "content not null" do
      it {is_expected.to eq true}
    end

    context "content null" do
      before do
        current_user.request_token.update content: nil
      end

      it {is_expected.to eq false}
    end
  end

  describe "::new_remember_token" do
    it do
      expect(SecureRandom).to receive(:urlsafe_base64)
      User.new_remember_token
    end
  end

  describe "::encrypt" do
    let(:token){"token"}

    it do
      expect(Digest::SHA1).to receive(:hexdigest).with token.to_s
      User.encrypt token
    end
  end
end
