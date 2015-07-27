require "rails_helper"

RSpec.describe V2::BulletinsController, :type => :controller do
  render_views
  subject{response.body}
  let(:user){FactoryGirl.create :user}

  before do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    let!(:bulletins){FactoryGirl.create_list :bulletin, 1}
    let(:bulletins_json) do
      _bulletins = Bulletin.all.each_with_object [] do |bulletin, bulletins|
        bulletins << {content: bulletin.content}
      end

      {bulletins: _bulletins}.to_json
    end

    before do
      xhr :get, :index, q: {}
    end

    it {is_expected.to eq bulletins_json}
  end
end
