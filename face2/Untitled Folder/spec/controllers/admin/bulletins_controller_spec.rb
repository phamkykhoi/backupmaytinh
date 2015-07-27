require "rails_helper"

RSpec.describe Admin::BulletinsController, type: :controller do
  let(:param_content){"My String"}
  let(:admin){FactoryGirl.create :admin}

  before{sign_in admin}

  describe "GET #index" do
    let(:page_param) {1}

    before do
      2.times{FactoryGirl.create :bulletin}
      get :index, page: page_param
    end

    it {expect(response).to render_template :index}
    it {expect(assigns(:bulletins)).to eq Bulletin.latest.page page_param}
  end

  describe "POST #create" do
    it do
      expect{post :create, bulletin: {content: param_content}}
        .to change(Bulletin, :count).by(1)
    end

  end

  describe "POST #update" do
    let(:bulletin){FactoryGirl.create :bulletin}
    let(:param_content_new){"My String New"}
    before do
      post :update, id: bulletin.id, bulletin: {id: bulletin.id,
        content: param_content_new}
    end

    it {expect(Bulletin.last.content).to eq param_content_new}
  end

  describe "DELETE #destroy" do
    let(:url){"http://localhost:3000/admin/bulletins"}
    let(:bulletin){FactoryGirl.create :bulletin}

    before do
      @request.env["HTTP_REFERER"] = url
    end

    it do
      expect{delete :destroy, id: bulletin.id.to_s}
        .to change(Bulletin, :count).by(0)
    end
  end
end
