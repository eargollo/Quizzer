require 'fsdb'

dir = File.dirname(__FILE__)
puts dir
db = FSDB::Database.new(dir+"/data/test.yaml")

db["first"] = "second"
