clean_list = [
  "bin/quizzer",
  "bin/quizzer.bat",
  "bin/quizzer_red.bat",
  "lib/quizzer/view",
  "lib/quizzer/view_red_shoes",
  "lib/quizzer/view_green_shoes.rb",
  "lib/quizzer/view_red_shoes.rb",
  "lib/quizzer_green.rb",
  "lib/quizzer_red.rb",
  "tmp",
  "script",
  "test",
  "Rakefile",
  "Manifest.txt",
  "PostInstall.txt"
]


require "fileutils"
base_path = File.expand_path(File.dirname(__FILE__) + "/..")

puts base_path

error = false
clean_list.each do |file|
  extended_name = "#{base_path}/#{file}"
  if !File.exists?(extended_name)
    puts "File #{extended_name} does not exist"
    error = true
  end
end
raise "Errors found " if error

clean_list.each do |file|
  extended_name = "#{base_path}/#{file}"
  raise "File #{extended_name} does not exist" if !File.exists?(extended_name)
  if File.directory?(extended_name)
  `git rm #{extended_name} -r`
  #  FileUtils.rm_r(extended_name)
  else
  #  FileUtils.rm(extended_name)
    `git rm #{extended_name}`
  end
end
