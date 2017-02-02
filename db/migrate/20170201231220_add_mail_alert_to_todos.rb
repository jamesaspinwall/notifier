class AddMailAlertToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :mail, :boolean
    add_column :todos, :alert, :boolean
  end
end
