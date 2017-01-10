class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.references :context, foreign_key: true
      t.string :title
      t.references :tags
      t.text :description
      t.datetime :show_at
      t.datetime :complete_at

      t.timestamps
    end
  end
end
