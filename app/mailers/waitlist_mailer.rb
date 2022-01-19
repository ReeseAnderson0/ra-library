class WaitlistMailer < ApplicationMailer
  
  def waitlist_notice
    @book_id = params[:book_id]
    @waitlist_users = Waitlist.where(:book_id => 210)
    @waitlist_emails = Array.new
    @book_title = Book.find_by(id: @book_id).title

    for x in @waitlist_users
      @waitlist_emails << x.email
    end

    mail(
    to: @waitlist_emails,
    subject: ("Waitlist Book Available - #{@book_title}")
    )

  end
end
