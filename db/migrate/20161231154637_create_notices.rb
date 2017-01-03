class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.string :description
      t.string :notify_chronic
      t.boolean :repeat
      t.datetime :notify_at
      t.datetime :scheduled_at
      t.datetime :sent_at
      t.datetime :cancelled
      t.binary :inst
      t.string :meth
      t.binary :args

      t.timestamps
    end
  end
end
