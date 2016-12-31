class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.string :description
      t.string :notify_chronic
      t.boolean :repeat
      t.time :notify_at
      t.time :sent_at
      t.time :cancelled

      t.timestamps
    end
  end
end
