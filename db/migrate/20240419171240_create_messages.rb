class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :number, null: false
      t.references :user, null: false, index: false, foreign_key: true
      t.references :chat, null: false, index: false, foreign_key: true
      t.index [:number, :chat_id], unique: true

      t.timestamps
    end
  end
end
