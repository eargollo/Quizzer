require 'csv' 

raise "File missing" if ARGV.size == 0

puts "Inverting file: #{ARGV[0]}"

filename = File.expand_path(ARGV[0])

data = CSV.read(filename)
File.open("#{filename}.inv", "w") do |f|
	data.each do |d|
		f.puts("#{d.reverse.join(", ")}")
	end
end
