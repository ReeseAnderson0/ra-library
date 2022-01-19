require 'csv'

CSV.foreach("branches.csv") do |row|
    Branch.create!(
        branch_name: row[0],
        address: row[1],
        phone: row[2],
    )
end 
