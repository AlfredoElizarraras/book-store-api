class BooksController < ApplicationController
  before_action :authenticate_user

  def index
    @books = current_user.books
  rescue => error
    render json: { errors: { 'user' => [error] } }
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user

    if @book.save
      render json: { messages: { 'book' => ['created successfuly'] } }, status: :ok
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  def update
    @book = book.find(params[:id])

    if book_owned_by_user(@book)
      if @book.update_attributes(params[:book])
        render json: { messages: { 'book' => ['updated successfuly'] } }, status: :ok
      else
        render json: { errors: @book.errors }, status: :unprocessable_entity
      end
    else
      book_not_owned_by_user_error
    end
  end

  def destroy
    @book = Book.find(params[:id])

    if book_owned_by_user(@book)
      if @book.destroy
        render json: { messages: { 'book' => ['deleted successfuly'] } }, status: :ok
      else
        render json: { errors: @book.errors }, status: :unprocessable_entity
      end
    else
      book_not_owned_by_user_error
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :category, :progress, :author,
                                 :progress_measure, :progress_measure_value,
                                 :max_progress_value, :current_progress_value)
  end

  def book_owned_by_user(book)
    book.id == current_user.id
  end

  def book_not_owned_by_user_error
    render json: { errors: { 'book' => ["not owned by #{current_user.username}"] } }, status: :forbidden
  end
end
