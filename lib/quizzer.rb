$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "quizzer/controller"
require "quizzer/model"

module Quizzer
  VERSION = '0.0.1'
  
  DEFAULTS = {:dict_dbfile => "~/.pangea/quizzer/data/dictionary.pstore"}
  
  class Main
    def self.run(argv, env, configuration)
      puts "Quizzer"
      
      options = DEFAULTS
      options[:dict_dbfile] = File.expand_path(options[:dict_dbfile])
      
      if !File.exists?(File.dirname(options[:dict_dbfile]))
        puts "DOES NOT"
        Main.init(options)
      end
      
      dictionary = Model::Dictionary.new(options[:dict_dbfile])
      
      #dictionary = 
      qm = Controller::QuestionsManager.new(dictionary)
      delay = 10
      while true
        question = qm.get_question
        puts question.to_s
        sleep(delay)
      end
      return 0
    end
    
    def self.init(options)
      puts "Creating folder #{options[:dict_dbfile]}"
      FileUtils.mkdir_p(File.dirname(options[:dict_dbfile]))
    end
  end
end
