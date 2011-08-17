$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "quizzer/controller"

module Quizzer
  VERSION = '0.0.1'
  
  class Main
    def self.run(argv, env, configuration)
      puts "Quizzer"
      return 0
    end
  end
end