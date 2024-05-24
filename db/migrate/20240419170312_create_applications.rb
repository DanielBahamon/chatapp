class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :name, null: false
      t.string :token, null: false
      t.integer :chats_count, null: false, default: 0
      t.index :token, unique: true

      t.timestamps
    end
  end
end
