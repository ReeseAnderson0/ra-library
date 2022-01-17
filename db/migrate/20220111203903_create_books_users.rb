class CreateBooksUsers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :books, :users, , column_options: { null: false, foreign_key: true } do |t|
      t.index [:user_id, :book_id]
      t.index [:book_id, :user_id]
      
      t.timestamps
    end
  end
end
