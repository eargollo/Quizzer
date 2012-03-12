clean_list = [
  "tmp",
  "script",
  "test",
  "Manifest.txt",
  "PostInstall.txt",
  "Rakefile.template"
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
