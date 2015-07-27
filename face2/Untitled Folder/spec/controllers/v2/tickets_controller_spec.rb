require "rails_helper"

RSpec.describe V2::TicketsController, type: :controller do
  render_views

  let(:ticket){FactoryGirl.create :ticket}
  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET show" do
    subject{response.body}

    let(:json) do
      {
        ticket: {
          current_count: ticket.current_count,
          next_recover: ticket.next_recover,
          recover_time: ticket.recover_time,
          limited: ticket.limited.present?
        }
      }.to_json
    end

    before do
      allow_any_instance_of(Ticket).to receive(:current_count)
        .and_return ticket.current_count
      allow_any_instance_of(Ticket).to receive(:next_recover)
        .and_return ticket.next_recover
      xhr :get, :show, id: ticket.id
    end

    it {is_expected.to eq json}
  end
end
