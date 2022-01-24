class AddBookIdToLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :logs, :book_id, :integer
  end
end
