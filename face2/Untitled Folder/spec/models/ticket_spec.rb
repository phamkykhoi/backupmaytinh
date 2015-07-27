require "rails_helper"

RSpec.describe Ticket, type: :model do
  let(:ticket){FactoryGirl.create :ticket}

  describe "#enqueue_for_notification" do
    subject{ticket.send :enqueue_for_notification}

    context "when ticket_recover_notice of user is true" do
      it do
        expect{subject}.to change(Delayed::Job, :count).by 1
      end
    end

    context "when ticket_recover_notice of user is not true" do
      before do
        ticket.user.ticket_recover_notice = false
      end

      it {is_expected.to eq nil}
    end
  end

  describe "#queue_name" do
    subject{ticket.send :queue_name}

    it {is_expected.to eq "users:#{ticket.user.id}:ticket_recover_notice"}
  end

  describe "#delete_queue_for_notification" do
    before do
      ticket.send :enqueue_for_notification
      ticket.send :delete_queue_for_notification
    end

    it do
      expect(Delayed::Job.where(queue: ticket.send(:queue_name))
        .count).to eq 0
    end
  end

  describe "#current_count" do
    subject{ticket.current_count}

    context "when over_count is 0" do
      context "when recovers_all_at is over time now" do
        before do
          ticket.recovers_all_at = Time.zone.now - Ticket::RECOVER_TIME
        end

        it {is_expected.to eq ticket.max_count}
      end

      context "when recovers_all_at is over time now" do
        let(:ticket_count){1.5}

        before do
          ticket.recovers_all_at = Time.zone.now +
            (ticket_count * Ticket::RECOVER_TIME)
        end

        it {is_expected.to eq (ticket.max_count - ticket_count.ceil)}
      end
    end

    context "when over_count is not 0" do
      before do
        ticket.over_count = 1
      end

      it {is_expected.to eq (ticket.over_count + ticket.max_count)}
    end
  end

  describe "#decrease=" do
    context "when current_count is 0" do
      let(:recovers_all_at){Time.zone.now + 3.days}

      before do
        ticket.update recovers_all_at: recovers_all_at
        ticket.decrease = 1
      end

      it {expect(ticket.current_count).to eq 0}
    end

    context "when over_count is 0" do
      context "when recovers_all_at is over time now" do
        before do
          ticket.recovers_all_at = Time.zone.now + 10.minutes
          ticket.decrease = 1
        end

        it do
          expect(ticket.current_count).to eq (ticket.max_count - 2)
        end
      end

      context "when recovers_all_at is not over time now" do
        before do
          ticket.recovers_all_at = Time.zone.now - 10.minutes
          ticket.decrease = 1
        end

        it do
          expect(ticket.current_count).to eq (ticket.max_count - 1)
        end
      end
    end

    context "when over_count is not 0" do
      let(:over_count){10}

      before do
        ticket.over_count = over_count
        ticket.decrease = 1
      end

      it do
        expect(ticket.current_count).to eq (ticket.max_count + over_count - 1)
      end
    end
  end

  describe "#increase=" do
    let(:increase_count){1}

    context "when current_count + value is over max count" do
      let(:over_count){1}
      before do
        ticket.over_count = over_count
        ticket.increase = increase_count
      end

      it do
        expect(ticket.current_count)
          .to eq (over_count + increase_count + ticket.max_count)
      end
    end

    context "when current_count + value is not over max count" do
      let(:ticket_count){1.5}

      before do
        ticket.recovers_all_at = Time.zone.now +
          (ticket_count * Ticket::RECOVER_TIME)
        ticket.increase = increase_count
      end

      it do
        expect(ticket.current_count)
          .to eq (ticket.max_count - ticket_count.ceil + increase_count)
      end
    end
  end

  describe "#next_recover" do
    subject{ticket.next_recover}

    let(:next_recover_time){10.minutes}
    let(:current_datetime){Time.zone.now}
    let(:ticket){FactoryGirl.create :ticket}

    context "when current_count is less than max_count" do
      before do
        allow(Time.zone).to receive(:now).and_return current_datetime
        ticket.recovers_all_at = current_datetime + next_recover_time
      end

      it {is_expected.to eq next_recover_time}
    end

    context "when current_count is less than max_count" do
      before do
        ticket.recovers_all_at = Time.zone.now - 1.day
      end

      it {is_expected.to eq 0}
    end
  end
end
