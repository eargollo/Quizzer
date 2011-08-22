$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "quizzer/controller"
require "quizzer/model"
require "quizzer/tools"
#require "quizzer/view"

module Quizzer
  VERSION = '0.0.1'
  
  DEFAULTS = {:dict_dbfile => "~/.pangea/quizzer/data/dictionary.pstore"}
  
  class Main
    def self.run(argv, env, configuration)
      puts "Quizzer"
      
      options = Tools::CommandlineParser.parse(File.basename($0), argv)
      options = DEFAULTS.merge(options)
      
      options[:dict_dbfile] = File.expand_path(options[:dict_dbfile])
      
      if !File.exists?(File.dirname(options[:dict_dbfile]))
        Main.init(options)
      end
      
      dictionary = Model::Dictionary.new(options[:dict_dbfile])
      
      #If set to import, import file and end execution
      if options[:action] == :import
        options[:file] = File.expand_path(options[:file])
        puts "Importing CSV file: #{options[:file]}"
        if options[:duplicate] == :replace
          puts "   Replacing words if existent"
        else
          puts "   Keeping existent words"
        end
        if !File.exists?(options[:file])
          raise "Could not import file #{file}: File not found"
        end
        newwords = dictionary.size
        imported = dictionary.insert_csv(options[:file], :duplicate => options[:duplicate])
        newwords = dictionary.size - newwords
        puts "#{imported.size} words parsed and #{newwords} new words added"
        return 0
      end
      
      #dictionary = 
      qm = Controller::QuestionsManager.new(dictionary)
      delay = 10
      #while true
      #  question = qm.get_question
      #  puts question.to_s
      #  sleep(delay)
      #end
      
      #Start graphic
#      Quizzer::View.add_controller(:dictionary, dictionary)
#      View.add_controller(:manager, qm)
#      Shoes.app :width => 400, :height => 400, :title => 'Language Quizzer' #, :hidden => true

      return 0
    end
    
    def self.init(options)
      puts "Creating folder #{options[:dict_dbfile]}"
      FileUtils.mkdir_p(File.dirname(options[:dict_dbfile]))
    end
  end
end
