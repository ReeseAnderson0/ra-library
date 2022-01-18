class OverdueMailer < ApplicationMailer
  
  def overdue_notice
    @BooksUser = BooksUser.all
    @CurrentUsers = Array.new
    @OverdueEmails = Array.new
    @overdueUsers = Array.new

    for x in @BooksUser
      @CurrentUsers << User.find_by(id: x.user_id).id
    end

    @CurrentUsers = @CurrentUsers.uniq
    
    n = 0
    for z in @CurrentUsers
      @length = User.find_by(id: z).book.count
      while n < @length
        @overdueTime = User.find_by(id: z).book[n].updated_at - 10.days
        if (User.find_by(id: z).book[n].status == false &&
          (User.find_by(id: z).book[n].updated_at >  @overdueTime))
          @overdueUsers << User.find_by(id: z)
          n = @length
        end
        n += 1
      end
      n = 0
    end

    for y in @overdueUsers
      @OverdueEmails << User.find_by(id: y).email
    end
    
    mail(
    to: @OverdueEmails,
    subject: "Overdue Books"
    )

  end
end
