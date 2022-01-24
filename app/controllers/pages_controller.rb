class PagesController < ApplicationController
  def home
  end

  def user
    if (current_user)
    @BooksUser = BooksUser.all
    @User = User.all
    @Book = Book.all
    @Waitlist = Waitlist.all
    else
      redirect_to root_path, alert: ("Missing Permissions")
    end
  end
end
