json.book do |json|
  json.partial! 'books/book', book: @book
end
