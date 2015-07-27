class AddIncreaseTicketToAppDriverHistory < ActiveRecord::Migration
  def change
    add_column :app_driver_histories, :increase_ticket, :integer
  end
end
