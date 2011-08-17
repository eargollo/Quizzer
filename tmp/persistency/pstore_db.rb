require 'pstore'


def create_database
  dir = File.dirname(__FILE__)
  puts dir
  
  db_dir = dir + "/data/data.pstore"
  
  db = PStore.new(db_dir)
  return db  
end

def save_string(db)
  db.transaction do 
    db["a"] = "data"
  end
end


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

def save_class(db)
  db.transaction do 
    db["teste"] = Test.new
  end
end

def browse(db)
  db.transaction(true) do
    db.roots.each do |k|
      puts "#{k} - #{db[k]}"
    end
  end
end

db = create_database
#save_string(db)
#save_class(db)
browse(db)