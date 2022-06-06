class FavoritesController < ApplicationController
  
  def create
    @book = Book.find(params[:book_id])
    @book_favorite = Favorite.new(user_id: current_user.id, book_id: params[:book_id])
    @book_favorite.save
    # redirect_to request.referer
    # 遷移元のURLを取得してリダイレクトする
  end
  
  def destroy
    @book = Book.find(params[:book_id])
    @book_favorite =  Favorite.find_by(user_id: current_user.id, book_id: params[:book_id])
    # byebug
    @book_favorite.destroy
    # redirect_to request.referer
  end
end
