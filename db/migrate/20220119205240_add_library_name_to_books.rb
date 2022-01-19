class AddLibraryNameToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :library_name, :string
  end
end
