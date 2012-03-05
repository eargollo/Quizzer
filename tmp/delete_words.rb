path = File.expand_path(File.dirname(__FILE__))
puts "Requiring #{path + '/../lib/quizzer.rb'}"
#require path + '/../lib/quizzer/model.rb'
require path + '/../lib/quizzer.rb'

include Quizzer
db = Quizzer::Model::Database.new("~/.pangea/quizzer/data/dictionary.pstore")
dbq = Quizzer::Model::Database.new("~/.pangea/quizzer/data/database.pstore")

table = db.retrieve_all(Model::Word)

before = table.size
puts "Words: #{before}"

table.each do |k,d|
  puts "Word: (#{d.key}, #{d.meaning})"
  puts "Delete?"
  del = gets
  if del.strip == "y"
	puts "Deleting #{d.key}"
    db.delete(d)
  end
  if del.strip == "f"
    break
  end
end

after = db.retrieve_all(Model::Word).size
puts "Deleted #{before - after} words. Before #{before} after #{after}"


questions = dbq.retrieve_all(Model::Question)
before = questions.size
puts "Questions before #{before}"

id = 0
questions.each do |k, q|
  op = nil
  del = false
  q.get(:keys).each do |op|
    if table[op] == nil
	  del = true
	  break
	end
  end
  if del
    puts "Word #{op} does not exist for question id #{id}"
    puts q
    puts "Delete question?"
    res = gets
    if res.strip == "y"
      dbq.delete(q)
    end
  end
  id += 1
end

after = dbq.retrieve_all(Model::Question).size
puts "Deleted #{before - after} words. Before #{before} after #{after}"

