class OverdueMailer < ApplicationMailer
  
  def overdue_notice
    @greeting = "Hi"
    
    
    @Overdue_users = BooksUser.all
    @UserIDs = Array.new
    @BooksIDs = Array.new
    
    
    for x in @Overdue_users
      @UserIDs << @Overdue_users.find_by_id(x).user_id
      @BooksIDs << @Overdue_users.find_by_id(x).book_id
    end
    
    @uniqIDs = Array.new
    @uniqIDs = @UserIDs.uniq
    
    @overdueIDs = Array.new
    n = 0
    for x in @uniqIDs
      @length = User.find_by_id(x).book.count
      while n < @length
        puts @BooksIDs
        @overdueTime = User.find_by_id(x).book.find_by_id(@BooksIDs[n]).updated_at - 10.days
        if (User.find_by_id(x).book.find_by_id(@BooksIDs[n]).status == false &&
          (User.find_by_id(x).book.find_by_id(@BooksIDs[n]).updated_at >  @overdueTime))
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
      @overdueEmails << User.find_by_id(q).email
    end
    
    mail(
    to: @overdueEmails,
    subject: "Overdue Books"
    )
  end
end

#@overdueIDs = Array.new
#for x in @uniqIDs
#  @length = User.find_by_id(x).book.count
#  for n in @BooksIDs
#    @overdueTime = User.find_by_id(x).book.find_by_id(n).updated_at - 7.days
#    if (User.find_by_id(x).book.find_by_id(n).status == false &&
#       (User.find_by_id(x).book.find_by_id(n).updated_at >  @overdueTime))
#    @overdueIDs << x
#    end
#  end
#end