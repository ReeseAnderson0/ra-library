class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy details history]
  before_action :authenticate_user!, except: [:show, :index]
  
  def removeWaitlist
    @waitlist = Waitlist.find(params[:id])
    @book = Book.find_by(id: @waitlist.id)
    @waitlist.destroy
    redirect_to "/user", alert: (@book.title + " - has already been removed from waitlist") 
  end
  
  def waitlist
    waitlist = Waitlist.all
    book = Book.find(params[:id])
    if (Waitlist.find_by(email: current_user.email, book_id: book.id).nil? && current_user.book.where(id: book.id).count == 0)
      redirect_to book_url(book), alert: ("You'll receive an email when the book is available")
      Waitlist.create(email: current_user.email, book_id: book.id)
    else
      redirect_to book_url(book), alert: ("You are already on the waitlist")
    end
  end
  
  
  # GET /books or /books.json
  def index
    @books = Book.where(library_name: params[:branch_search])
    @search_size = Book.where(library_name: params[:branch_search])
    @branch = Branch.all
  end
  
  def log
    if (current_user.admin != true)
      redirect_to root_path, alert: ("Missing Permissions")
    else
      @Log = Log.all
      @BooksWithHistory = Array.new
      for x in (@Log)
        @BooksWithHistory << [x.title, x.book_id, x.library_name]
      end
      for y in (BooksUser.distinct.pluck(:book_id))
        @BooksWithHistory << [Book.find_by(id: y).title, Book.find_by(id: y).id, Book.find_by(id: y).library_name]
      end
      @BooksWithHistory = @BooksWithHistory.uniq # All the uniq books that are borrowed or returned

    end
  end
    
    def details
      if (current_user.admin != true)
        redirect_to root_path, alert: ("Missing Permissions")
      else
        @BooksUser = BooksUser.all
        @User = User.all
        @books = Book.all
        @Log = Log.all
      end
    end
    
    def returnBook
      nbook = Book.find(params[:id])
      userbook = User.find_by_id(current_user.id).book.ids
      if (nbook.status == false)
        Log.create(title: nbook.title, author: nbook.author, email: current_user.email, library_name: nbook.library_name, book_id: nbook.id)
        
        # For deleting association between tables
        user = current_user
        del_book = Book.find_by(id: nbook.id)
        user.book.delete(del_book)

        nbook.copies = nbook.copies + 1
        nbook.save
        if !(Waitlist.find_by(book_id: nbook.id).nil?)
          WaitlistMailer.with(book_id: nbook.id).waitlist_notice.deliver_later
        end 
        redirect_to "/user", alert: (nbook.title + " - has been Returned")
      else
        redirect_to "/user", alert: (nbook.title + " - has already been Returned") 
      end
    end
    
    # GET /books/1 or /books/1.json
    def show
      @books = Book.all
    end
    
    def history
      if (current_user.admin != true)
        redirect_to root_path, alert: ("Missing Permissions")
      end
      @books = Book.all
      @BooksUser = BooksUser.all
      @Log = Log.all
    end
    
    # GET /books/new
    def new
      if (current_user.admin != true)
        redirect_to root_path, alert: ("Missing Permissions")
      end
      @book = Book.new
    end
    
    # GET /books/1/borrow
    def borrow
      user = User.find(current_user.id)
      nbook = Book.find(params[:id])
      if (user.book.find_by_id(nbook.id).nil? != false && nbook.copies >= 1) 
        user.book << nbook
        nbook.copies = nbook.copies - 1
        nbook.status = false
        nbook.save
        if !(Waitlist.find_by(book_id: nbook.id, email: user.email).nil?)
          Waitlist.find_by(book_id: nbook.id, email: user.email).destroy
          redirect_to "/user", alert: (nbook.title + " - has been borrowed and you have been removed from waitlist")
        else
          redirect_to "/user", alert: (nbook.title + " - has been Borrowed")
        end
      elsif (nbook.copies <= 0)
        redirect_to show_book_path(nbook.id), alert: (nbook.title + " - no more books are available") 
      else
        redirect_to "/user", alert: (nbook.title + " - is already Borrowed") 
      end
    end
    
    # POST /books or /books.json
    def create
      if (current_user.admin != true)
        redirect_to root_path, alert: ("Missing Permissions")
      else
        @book = Book.new(book_params)
        respond_to do |format|
          if @book.save
            format.html { redirect_to book_url(@book), alert: "Book was successfully created." }
            format.json { render :show, status: :created, location: @book }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @book.errors, status: :unprocessable_entity }
          end
        end
      end
    end
    
    def edit
      if (current_user.admin != true)
        redirect_to root_path, alert: ("Missing Permissions")
      end
    end

    # PATCH/PUT /books/1 or /books/1.json
    def update
      if (current_user.admin != true)
        redirect_to root_path, alert: ("Missing Permissions")
      else
        respond_to do |format|
          if @book.update(book_params)
            format.html { redirect_to book_url(@book), alert: "Book was successfully updated." }
            format.json { render :show, status: :ok, location: @book }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @book.errors, status: :unprocessable_entity }
          end
        end
      end
    end
    
    # DELETE /books/1 or /books/1.json
    def destroy
      if (current_user.admin != true)
        redirect_to root_path, alert: ("Missing Permissions")
      else
        @book.destroy
        respond_to do |format|
          format.html { redirect_to root_path, alert: "Book was successfully destroyed." }
          format.json { head :no_content }
        end
      end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :genre, :subgenre, :pages, :publisher, :copies, :library_name)
    end
  end
  