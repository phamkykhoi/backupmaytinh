require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  let(:admin){FactoryGirl.create :admin}

  before {sign_in admin}

  describe "GET index" do
    before {get :index}
    it {expect(response).to render_template :index}
  end
end
