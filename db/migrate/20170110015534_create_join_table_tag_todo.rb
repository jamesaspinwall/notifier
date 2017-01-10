class CreateJoinTableTagTodo < ActiveRecord::Migration[5.0]
  def change
    create_join_table :todos, :tags do |t|
      t.index [:todo_id, :tag_id]
      t.index [:tag_id, :todo_id]
    end
  end
end
