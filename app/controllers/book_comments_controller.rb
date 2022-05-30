class BookCommentsController < ApplicationController
    
   def create
       book = Book.find(params[:book_id])
    # :book_idはrailsroutesの記述を参照
     @book_comment = BookComment.new(book_comment_params)
     @book_comment.user_id = current_user.id
    # 誰が投稿したか user_id(カラム)
     @book_comment.book_id = book.id
    # どの投稿にコメントしたか book_id(カラム)
       @book_comment.save
       redirect_to book_path(book.id)
   end
    
    def destroy
     @book_comment = BookComment.find(params[:id])
     @book_comment.destroy
     redirect_to book_path(book.id)
    end
    
      private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
  
end