require "rails_helper"

RSpec.describe V2::SupportSubtotalsController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    subject{response.body}

    let(:support_subtotal) do
      FactoryGirl.create :support_subtotal, user: user,
        targeted_at: (Time.zone.now - 1.month).beginning_of_month
    end
    let(:json) do
      support_subtotals = SupportSubtotal.ransack(user_id_eq: user.id)
        .result.recent
      support_subtotals_attributes = (0..(Settings
        .month_displaying_support_subtotal - 1))
        .to_a.each_with_object [] do |i, _support_subtotals|
        datetime = Time.zone.now - (i + 1).month
        support_subtotal = {}

        if support_subtotals[i].try(:targeted_at) ==  datetime.beginning_of_month
          support_subtotal[:supporters_count] = support_subtotals[i].supporters_count
          support_subtotal[:month] = support_subtotals[i].targeted_at.strftime "%m, %Y"
        else
          support_subtotal[:supporters_count] = 0
          support_subtotal[:month] = datetime.strftime "%m, %Y"
        end

        _support_subtotals << support_subtotal
      end
      {
        support_subtotals: support_subtotals_attributes
      }.to_json
    end

    before do
      support_subtotal.update supporters_count: 1
      xhr :get, :index, q: {user_id_eq: user.id}
    end

    it {is_expected.to eq json}
  end
end
