json.books do |json|
  json.array! @books, partial: 'books/book', as: :book
end
