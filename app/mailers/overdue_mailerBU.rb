class OverdueMailer < ApplicationMailer
  
  def overdue_notice
    @Overdue_users = BooksUser.all
    @UserIDs = Array.new
    @BooksIDs = Array.new
    
    puts "Here 1"

    for x in @Overdue_users
      @UserIDs << @Overdue_users.find_by(user_id: x).user_id
      @BooksIDs << @Overdue_users.find_by(user_id: x).book_id
    end

    @uniqIDs = Array.new
    @uniqIDs = @UserIDs.uniq

    puts "Here 2"
    
    @overdueIDs = Array.new
    n = 0
    for x in @uniqIDs
      @length = User.find_by(id: x).book.count
      while n < @length
        @overdueTime = User.find_by(id: x).book.find_by(id: @BooksIDs[n]).updated_at - 10.days
        if (User.find_by(id: x).book.find_by(id: @BooksIDs[n]).status == false &&
          (User.find_by(id: x).book.find_by(id: @BooksIDs[n]).updated_at >  @overdueTime))
          @overdueIDs << x
        end
        n += 1
      end
      @BooksIDs.shift(2)
      n = 0
    end
    
    @overdueIDs = @overdueIDs.uniq
    
    @overdueEmails = Array.new
    for q in @overdueIDs
      @overdueEmails << User.find_by(id: q).email
    end
    
    puts "Here 3"

    mail(
    to: @overdueEmails,
    subject: "Overdue Books"
    )
  end
end
