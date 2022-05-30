class BooksController < ApplicationController
    before_action :correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    # @user = current_user不要
    @user = @book.user
    @book_show = Book.new
    # form.html.erbに空のモデルを渡す。(21)
    @book_comments = @book.book_comments
    # each文に代入する@book(投稿).book_comment(複数の)
    @book_comment = BookComment.new
    # form_withに代入する空のモデル
  end

  def index
    @book = Book.new
    @books = Book.all
    # @user = current_user不要
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      # @user = current_user
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to books_path, notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private


  def book_params
    params.require(:book).permit(:title, :body, :profile_image)
    # require(:book).を削除/param is missing or the value is empty: book
  end
  
     
  def correct_user
       @book = Book.find(params[:id])
       @user = @book.user
      unless @user == current_user
        redirect_to books_path
      end
  end
  
   
end
