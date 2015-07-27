require "rails_helper"

RSpec.describe V2::SupportershipsController, type: :controller do
  render_views

  let(:supporter){FactoryGirl.create :user}
  let(:_post){FactoryGirl.create :post}
  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "POST create" do
    describe "Check count after request" do
      it "is expected to increase count" do
        expect do
          xhr :post, :create, supportership: {post_id: _post.id}
        end.to change(Supportership, :count).by 1
      end
    end

    describe "Check response" do
      subject{response}

      let(:current_count){1}
      let(:next_recover){100}
      let(:ticket){FactoryGirl.create :ticket}
      let(:json) do
        {
          ticket: {
            current_count: current_count,
            next_recover: ticket.next_recover,
            recover_time: ticket.recover_time
          }
        }.to_json
      end

      before do
        allow_any_instance_of(Supportership)
          .to receive(:supporter).and_return user
        allow_any_instance_of(Supportership)
          .to receive_message_chain(:supporter, :ticket).and_return ticket
        allow_any_instance_of(Supportership)
          .to receive_message_chain(:supporter, :ticket, :current_count)
          .and_return current_count
        allow_any_instance_of(Supportership)
          .to receive_message_chain(:supporter, :ticket, :next_recover)
          .and_return next_recover
        xhr :post, :create, supportership: {post_id: _post.id}
      end

      it {expect(subject.body).to eq json}
      it {is_expected.to be_success}
    end
  end

  describe "GET index" do
    let(:supportee){FactoryGirl.create :user}
    let(:supportership) do
      FactoryGirl.create :supportership, supporter: supporter,
        supportee: supportee
    end
    let!(:json) do
      {
        supporterships: [{
          user_id: supportership.supporter_id,
          user_name: supportership.supporter.name,
          user_profile_photo_url: supportership.supporter.profile_photo.
            thumb_small.url,
          supportings_count: 1
        }]
      }.to_json
    end

    before do
      xhr :get, :index, q: {supporter_ranking: true}
    end

    it {expect(response.body).to eq json}
  end
end
