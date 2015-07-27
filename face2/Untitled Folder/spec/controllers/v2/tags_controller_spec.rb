require "rails_helper"

RSpec.describe V2::TagsController, type: :controller do
    render_views

    let(:user){FactoryGirl.create :user}

    before  do
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
    end

    describe "GET index" do
      subject{response.body}

      let!(:tag_list) do
        FactoryGirl.create_list :tag, 5, name: "tag name"
      end

      let(:tags_json) do
        _tags = Tag.all.each_with_object [] do |tag, tags|
          tags << {
            id: tag.id,
            name: tag.name,
          }
        end

        {tags: _tags}.to_json
      end

      before do
        xhr :get, :index
      end

      it {is_expected.to eq tags_json}
    end
end
