class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy details history]
  before_action :authenticate_user!, except: [:show, :index]
  
  def waitlist
    book = Book.find(params[:id])
    if (Waitlist.find_by(email: current_user.email, book_id: book.id).nil?)
      redirect_to book_url(book), notice: ("You'll receive an email when the book is available")
      Waitlist.create(email: current_user.email, book_id: book.id)
    else
      redirect_to book_url(book), notice: ("You are already on the waitlist")
    end
  end


  # GET /books or /books.json
  def index
    @books = Book.all
  end
  
  def log
    @BooksUser = BooksUser.all
    @User = User.all
    @books = Book.all
    @Log = Log.all
  end
  
  def details
    @BooksUser = BooksUser.all
    @User = User.all
    @books = Book.all
  end
  
  def returnBook
    nbook = Book.find(params[:id])
    userbook = User.find_by_id(current_user.id).book.ids
    if (nbook.status == false)
      Log.create(title: nbook.title, author: nbook.author, email: current_user.email)
      current_user.book.destroy(Book.find_by_id(nbook))
      nbook.status = true
      nbook.copies = nbook.copies + 1
      nbook.save
      redirect_to "/user", notice: (nbook.title + " - has been Returned")
      if !(Waitlist.find_by(book_id: nbook.id).nil?)
        WaitlistMailer.with(book_id: nbook.id).waitlist_notice.deliver_later
      end 
    else
      redirect_to "/user", notice: (nbook.title + " - has already been Returned") 
    end
  end
  
  # GET /books/1 or /books/1.json
  def show
    @books = Book.all
  end

  def history
    @books = Book.all
    @BooksUser = BooksUser.all
    @Log = Log.all
  end
  
  # GET /books/new
  def new
    @book = Book.new
  end
  
  # GET /books/1/borrow
  def borrow
    user = User.find(current_user.id)
    nbook = Book.find(params[:id])
    if (user.book.find_by_id(nbook.id).nil? != false)
      user.book << nbook
      nbook.copies = nbook.copies - 1
      nbook.status = false
      nbook.save
      redirect_to "/user", notice: (nbook.title + " - has been Borrowed")
    else
      redirect_to "/user", notice: (nbook.title + " - is already Borrowed") 
    end
  end
  
  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end
  
  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :author, :genre, :subgenre, :pages, :publisher, :copies)
  end
end
