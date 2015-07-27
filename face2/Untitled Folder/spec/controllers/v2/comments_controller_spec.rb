require "rails_helper"

RSpec.describe V2::CommentsController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "POST create" do
    let(:_post){FactoryGirl.create :post}

    it "is expected to increase count" do
      expect do
        xhr :post, :create, comment: {post_id: _post.id, content: "content"}
      end.to change(Comment, :count).by 1
    end
  end

  describe "GET index" do
    subject{response.body}

    let(:_post){FactoryGirl.create :post}
    let!(:comments) do
      FactoryGirl.create_list :comment, 5, post: _post, user: user
    end
    let(:comments_json) do
      _comments = Comment.where(user_id: user.id)
        .each_with_object [] do |comment, comments|
        comments << {
          id: comment.id,
          user_id: comment.user_id,
          user_name: comment.user.name,
          user_profile_photo_url: comment.user.profile_photo.thumb_small.try(:url),
          content: comment.content,
          updated_at: comment.updated_at,
          reported: comment.reported?(user),
          mine: comment.user_id == user.id,
        }
      end

      {comments: _comments}.to_json
    end

    before do
      xhr :get, :index, q: {post_id_eq: _post.id}
    end

    it {is_expected.to eq comments_json}
  end

  describe "Comment #destroy" do
    let(:_post){FactoryGirl.create :post}

    context "Destroy self-comment" do
      let!(:comment){FactoryGirl.create :comment, user_id: user.id, post_id: _post.id}
      before do
        xhr :delete, :destroy, id: comment.id
      end

      it {expect(response.code).to eq "200"}
    end

    context "Destroy not self-comment" do
      let!(:comment){FactoryGirl.create :comment, post_id: _post.id}

      before do
        xhr :delete, :destroy, id: comment.id
      end

      it {expect(response.code).to eq "400"}
    end
  end
end
