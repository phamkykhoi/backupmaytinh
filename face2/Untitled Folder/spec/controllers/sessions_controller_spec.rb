require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "POST create" do
    let(:password){"12345678"}
    let(:user) do
      FactoryGirl.create :user, email: "example@example.com",
        password: password
    end

    context "when sign in is success" do
      before do
        post :create, session: {email: user.email, password: password}
      end

      it {expect(response).to redirect_to new_post_path}
    end

    context "when sign in is failure" do
      before do
        post :create, session: {email: user.email, password: "password"}
      end

      it {expect(response).to render_template :new}
    end
  end
end
