class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :zipcode
      t.string :ip_address

      t.timestamps
    end
  end
end