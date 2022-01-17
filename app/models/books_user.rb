class BooksUser < ApplicationRecord
  belongs_to :users
  belongs_to :books
end
