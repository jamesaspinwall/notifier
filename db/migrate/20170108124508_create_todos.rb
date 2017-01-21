class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.references :category, foreign_key: true
      t.string :title
      t.text :description
      t.string :show_at_chronic
      t.datetime :show_at
      t.datetime :started_at
      t.datetime :complete_at

      t.timestamps
    end
  end
end
