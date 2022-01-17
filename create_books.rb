require 'csv'

CSV.foreach("tmp/books.csv") do |row|
    Book.create!(
        title: row[0],
        author: row[1],
        genre: row[2],
        subgenre: row[3],
        pages: row[4],
        publisher: row[5],
        copies: row[6]
    )
end 
