require 'csv'

data = CSV.read(File.dirname(__FILE__)+"/file1.csv")

puts data.inspect