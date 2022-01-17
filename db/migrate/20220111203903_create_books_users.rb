class CreateBooksUsers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :books, :users do |t|
      t.primary_key :id
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
