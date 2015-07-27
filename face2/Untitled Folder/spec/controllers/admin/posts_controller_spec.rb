require "rails_helper"

RSpec.describe Admin::PostsController, type: :controller do
  let(:admin){FactoryGirl.create :admin}

  before {sign_in admin}

  describe "GET #index" do
    let(:page_param) {1}

    context "when template is nothing" do
      before do
        2.times{FactoryGirl.create :post}
        get :index
      end

      it {expect(response).to render_template :index}
    end

    context "when template is bans" do
      before do
        2.times{FactoryGirl.create :post}
        get :index, q: {bans_count_eq: 0}, template: :bans
      end

      it {expect(response).to render_template :bans}
    end

  end


  describe "DELETE destroy" do
    let!(:_post){FactoryGirl.create :post}

    before do
      @request.env["HTTP_REFERER"] = admin_root_path
    end

    it do
      expect do
        delete :destroy, id: _post.id
      end.to change(Post, :count).by(-1)
    end
  end
end
