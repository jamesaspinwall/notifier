class ChangeStartAtToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :todos, :show_at, :integer
  end
end
