class AddPriorityToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :priority, :float
  end
end
