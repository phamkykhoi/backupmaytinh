require "rails_helper"

describe V2::AppDriverHistoriesController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}
  let(:device_id){"device_id"}
  let(:app_driver_history) do
    FactoryGirl.create :app_driver_history,
      identifier: identifier
  end
  let(:identifier) do
    "{\"user_id\": \"#{user.id}\", \"device_id\": \"#{device_id}\"}"
  end

  describe "GET index" do
    subject{response.body}
    let!(:json) do
      {
        app_driver_histories: [{
          identifier: app_driver_history.identifier,
          achieve_id: app_driver_history.achieve_id,
          accepted_time: app_driver_history.accepted_time,
          campaign_id: app_driver_history.campaign_id,
          campaign_name: app_driver_history.campaign_name,
          advertisement_id: app_driver_history.advertisement_id,
          advertisement_name: app_driver_history.advertisement_name
        }]
      }.to_json
    end

    before do
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
      xhr :get, :index, q: {identifier_eq: identifier}
    end

    it {is_expected.to eq json}
  end

  describe "GET point_up" do
    context "where user have advertisement" do
      let(:attributes) do
        {
          identifier: identifier,
          achieve_id: app_driver_history.achieve_id,
          accepted_time: app_driver_history.accepted_time,
          campaign_id: app_driver_history.campaign_id,
          campaign_name: app_driver_history.campaign_name,
          advertisement_id: app_driver_history.advertisement_id,
          advertisement_name: app_driver_history.advertisement_name,
          point: app_driver_history.point,
          payment: app_driver_history.payment
        }
      end

      context "when ip address is valid" do
        before  do
          request.env["REMOTE_ADDR"] = "59.106.111.156"
          get :point_up, attributes
        end

        it do
          expect(response.body)
            .to eq V2::AppDriverHistoriesController::RESPONSES[:do_not_take_point].to_s
        end
      end

      context "when ip address is invalid" do
        before  do
          request.env["REMOTE_ADDR"] = "192.168.0.104"
          get :point_up, attributes
        end

        it do
          expect(response.body).to eq controller.head 403
        end
      end
    end

    context "when user doesn't have advertisement" do
      let(:other_user){FactoryGirl.create :user}
      let(:other_identifier) do
        "{\"user_id\": \"#{other_user.id}\", \"device_id\": \"#{device_id}\"}"
      end
      let!(:attributes) do
        {
          identifier: other_identifier,
          achieve_id: app_driver_history.achieve_id,
          accepted_time: app_driver_history.accepted_time,
          campaign_id: app_driver_history.campaign_id,
          campaign_name: app_driver_history.campaign_name,
          advertisement_id: app_driver_history.advertisement_id,
          advertisement_name: app_driver_history.advertisement_name,
          point: app_driver_history.point,
          payment: app_driver_history.payment
        }
      end

      context "when ip address is valid" do
        describe "Check response" do
          before do
            request.env["REMOTE_ADDR"] = "59.106.111.156"
            get :point_up, attributes
          end

          it do
            expect(response.body)
              .to eq V2::AppDriverHistoriesController::RESPONSES[:take_point].to_s
          end
        end

        describe "Check whether to save AppDriverHistory" do
          it do
            expect do
              request.env["REMOTE_ADDR"] = "59.106.111.156"
              get :point_up, attributes
            end.to change(AppDriverHistory, :count).by 1
          end
        end
      end

      context "when ip address is invalid" do
        before do
          request.env["REMOTE_ADDR"] = "192.168.0.104"
          get :point_up, attributes
        end

        it do
          expect(response.body).to eq controller.head 403
        end
      end
    end
  end
end
