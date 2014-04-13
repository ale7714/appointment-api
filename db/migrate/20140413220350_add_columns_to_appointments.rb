class AddColumnsToAppointments < ActiveRecord::Migration
  def change
    change_table :appointments do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :comment
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

    end
    add_index :appointments, :id, unique: true
  end
end