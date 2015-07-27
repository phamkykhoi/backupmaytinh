require "rails_helper"

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    before {get :index}
    it {expect(response).to render_template :index}
  end
end
