class AddDeviceIdToAppDriverHistory < ActiveRecord::Migration
  def change
    add_column :app_driver_histories, :device_id, :text
  end
end
