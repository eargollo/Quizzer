#!/usr/bin/ruby

#Add local folder to include path
$: << File.expand_path(File.dirname(__FILE__)+'/../lib')
require 'quizzer/view_jruby'
require 'quizzer'

#CONFIG_FILE = File.expand_path(File.dirname(__FILE__)+'/../etc/configuration.yml')
CONFIG_FILE = nil
result_code = Quizzer::Main.run(ARGV, ENV, CONFIG_FILE)
#exit(result_code)
#return(result_code)
