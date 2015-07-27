require "rails_helper"

RSpec.describe V2::BansController, type: :controller do
  render_views

  let(:_post){FactoryGirl.create :post}
  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "POST create" do
    context "when params has post_id" do
      it "is expected to increase count" do
        expect do
          xhr :post, :create, ban: {post_id: _post.id}
        end.to change(Ban, :count).by 1
      end
    end

    context "when params does not have post_id" do
      it "is expected to increase count" do
        expect do
          xhr :post, :create, ban: {
            reportable_id: _post.id, reportable_type: "Post"
          }
        end.to change(Ban, :count).by 1
      end
    end
  end
end
