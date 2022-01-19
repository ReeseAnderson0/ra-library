class PagesController < ApplicationController
  def home
  end

  def user
    @BooksUser = BooksUser.all
    @User = User.all
    @Book = Book.all
    @Waitlist = Waitlist.all
  end
end
