class AddTodoToNotice < ActiveRecord::Migration[5.0]
  def change
    add_reference :notices, :todo, foreign_key: true
  end
end
