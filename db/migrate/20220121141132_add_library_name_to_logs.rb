class AddLibraryNameToLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :logs, :library_name, :string
  end
end
