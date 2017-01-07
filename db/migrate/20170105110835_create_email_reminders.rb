class CreateEmailReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :email_reminders do |t|
      t.string :chronic
      t.datetime :send_at
      t.string :title
      t.text :description
      t.references(:notice)

      t.timestamps
    end
  end
end
