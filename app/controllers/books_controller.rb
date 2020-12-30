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
      render :show, status: :ok
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if book_owned_by_user(@book)
      if @book.update_attributes(book_params)
        render :show, status: :ok
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
    book.user.id == current_user.id
  end

  def book_not_owned_by_user_error
    render json: { errors: { 'book' => ["not owned by #{current_user.username}"] } }, status: :forbidden
  end
end
