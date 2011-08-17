require 'sdbm'

dir = File.dirname(__FILE__)
puts dir

db_dir = dir + "/data/data.dbm"

db = SDBM.open(db_dir)

class Test
  def initialize
    @data = {}
    @data['my'] = 'data'
    @data["int"] = 32
  end
  
  def to_s
    @data.inspect
  end
end

#db["a"] = "data"

db["obj"] = {:key => :data}

#db.each do |k,d|
#  puts "[#{k}] = [#{d}]"
#end

#db = FSDB::Database.new(dir+"/data/test.yaml")

#db["first"] = "second"
