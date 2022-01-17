class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.string :title
      t.string :author
      t.string :email

      t.timestamps
    end
  end
end
