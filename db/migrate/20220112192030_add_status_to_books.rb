class AddStatusToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :status, :boolean,:default => false
  end
end
