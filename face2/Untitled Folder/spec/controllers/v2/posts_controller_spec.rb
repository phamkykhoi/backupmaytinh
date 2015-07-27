require "rails_helper"

describe V2::PostsController, type: :controller do
  subject{response}

  render_views

  let(:_post){FactoryGirl.create :post}
  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    context "when m_genre_ids is nil" do
      let(:background_color){"#dcdcdc"}
      let(:posts_json) do
        posts = Post.limit(Settings.returning_post_num)
          .each_with_object [] do |post, posts|
          posts << {
            id: post.id,
            user_name: post.user.name,
            user_id: post.user_id,
            supporters_count: post.supporters_count,
            followers_count: post.user.followers_count,
            numberFollower: post.user.followers_count,
            photo_url: post.photos.with_main.content.thumb_small.url,
            width_ratio: post.photos.with_main.width_ratio,
            height_ratio: post.photos.with_main.height_ratio,
            description: post.photos.with_main.description,
            background_color: background_color,
            photo2_url: post.photos.without_main[0].content.thumb_small.url,
            photo2_width_ratio: post.photos.without_main[0].width_ratio,
            photo2_height_ratio: post.photos.without_main[0].height_ratio,
            photo2_description: post.photos.without_main[0].description,
            photo3_url: post.photos.without_main[1].content.thumb_small.url,
            photo3_width_ratio: post.photos.without_main[1].width_ratio,
            photo3_height_ratio: post.photos.without_main[1].height_ratio,
            photo3_description: post.photos.without_main[1].description,
            photo4_url: post.photos.without_main[2].content.thumb_small.url,
            photo4_width_ratio: post.photos.without_main[2].width_ratio,
            photo4_height_ratio: post.photos.without_main[2].height_ratio,
            photo4_description: post.photos.without_main[2].description,
            photo5_url: post.photos.without_main[3].content.thumb_small.url,
            photo5_width_ratio: post.photos.without_main[3].width_ratio,
            photo5_height_ratio: post.photos.without_main[3].height_ratio,
            photo5_description: post.photos.without_main[3].description
          }
        end

        {posts: posts, total_count: posts.count}.to_json
      end

      before do
        allow_any_instance_of(Photo).to receive(:background_color)
          .and_return background_color
        FactoryGirl.create_list :post, 10
        xhr :get, :index
      end

      it {is_expected.to be_success}

      it "is expected to return all posts"do
        expect(subject.body).to eq posts_json
      end
    end

    context "when m_genre_ids is not nil" do
      let(:m_genre_id){M::Genre.first.id.to_s}
      let(:posts){[FactoryGirl.create(:post, m_genre_id: m_genre_id)]}

      before do
        load Rails.root.join "db/seeds.rb"
        FactoryGirl.create_list :post, 10
        xhr :get, :index, q: {m_genre_id_eq: posts.first.m_genre_id}
      end

      it {is_expected.to be_success}

      it "is expected to return all posts"do
        expect(assigns :posts).to eq posts
      end
    end

    context "when there is user_name_cont_any in params" do
      let!(:_post){FactoryGirl.create :post, user: user}
      let(:user){FactoryGirl.create :user, name: user_name}
      let(:user_name){"bar"}

      before do
        FactoryGirl.create_list :post, 5
        xhr :get, :index, q: {user_name_cont_any: [user_name]}
      end

      it {expect(assigns :posts).to eq [_post]}
    end

    context "when there is posted_user_followed_by in params" do
      let!(:_post){FactoryGirl.create :post, user: followee}
      let(:followee){FactoryGirl.create :user}

      before do
        FactoryGirl.create :followership, followee: followee, follower: user
        3.times do
          FactoryGirl.create :post, user: user
        end
        xhr :get, :index, q: {posted_user_followed_by: user.id}
      end

      it {expect(assigns :posts).to eq [_post]}
    end
  end

  describe "POST create" do
    let!(:attributes) do
      photos_attributes = _post.photos
        .each_with_object [] do |photo, photos|
        photos << {
          description: photo.description,
          content: fixture_file_upload("spec/files/test_image1.jpg", "image/jpg"),
          width_ratio: photo.width_ratio,
          height_ratio: photo.height_ratio,
          main: photo.main
        }
      end

      {
        m_genre_id: _post.m_genre_id,
        photos_attributes: photos_attributes
      }
    end

    it "is expected to increase count" do
      expect do
        xhr :post, :create, post: attributes
      end.to change(Post, :count).by 1
    end

    it "is expected to be success" do
      xhr :post, :create, post: attributes
      is_expected.to be_success
    end
  end

  describe "GET show" do
    let(:post){FactoryGirl.create :post}
    let(:photo_url) do
      if post.photos.with_main.content.high_definition.file.exists?
        post.photos.with_main.content.high_definition.try :url
      else
        post.photos.with_main.content_url
      end
    end
    let(:json) do
      _post = {
        post: {
          user_name: post.user.name,
          user_id: post.user.id,
          user_profile_photo_url: post.user.profile_photo.thumb_small.url,
          m_genre_name: post.m_genre.name,
          supporters_count_from_user: post.supporters_count_from_user(:user),
          supporters_count: post.supporters_count,
          reported: post.reported?(user),
          mine: post.user.id == user.id,
          tags: post.tags.pluck(:name),
          download: post.download,
          camera_name: (post.camera.try(:name) || ""),
          location: post.location || "",
          photographer_name: (post.photographer.try(:name) || ""),
          photo1_url: photo_url,
          photo1_description: post.photos.with_main.description,
          photo1_width_ratio: post.photos.with_main.width_ratio,
          photo1_height_ratio: post.photos.with_main.height_ratio
        }
      }

      post.photos.without_main.each.with_index 2 do |photo, i|
        if photo.content.high_definition.file.exists?
          _post[:post]["photo#{i}_url"] = photo.content.high_definition.try :url
        else
          _post[:post]["photo#{i}_url"] = photo.content_url
        end
        _post[:post]["photo#{i}_description"] = photo.description
        _post[:post]["photo#{i}_width_ratio"] = photo.width_ratio
        _post[:post]["photo#{i}_height_ratio"] = photo.height_ratio
      end
      _post.to_json
    end

    before do
      xhr :get, :show, id: post.id
    end

    it {expect(response.body).to eq json}
  end

  describe "Post #destroy" do
    context "Destroy self post" do
      let!(:post){FactoryGirl.create :post, user_id: user.id}
      before do
        xhr :delete, :destroy, id: post.id
      end

      it {expect(response.code).to eq "200"}
    end

    context "Destroy not self Post" do
      let!(:post){FactoryGirl.create :post}

      before do
        xhr :delete, :destroy, id: post.id
      end

      it {expect(response.code).to eq "400"}
    end
  end
end
