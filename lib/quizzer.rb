$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "quizzer/model"
require "quizzer/controller"
require "quizzer/tools"
require "quizzer/view"

module Quizzer
  DEFAULTS = {:dict_dbfile   => "~/.pangea/quizzer/data/dictionary.pstore",
              :database_file => "~/.pangea/quizzer/data/database.pstore" ,
              }

  VERSION = '0.5'
  RELEASE = Time.utc(2012,3,5, 22, 5, 0)

  class Main
    def self.run(argv, env, configuration)
      options = Tools::CommandlineParser.parse(File.basename($0), argv)
      options = DEFAULTS.merge(options)
      
      options[:dict_dbfile] = File.expand_path(options[:dict_dbfile])
      
      #If dictionary file does not exist, creates it
      if !File.exists?(File.dirname(options[:dict_dbfile]))
        puts "Creating folder #{options[:dict_dbfile]}"
        FileUtils.mkdir_p(File.dirname(options[:dict_dbfile]))
      else
        dictionary = Model::Database.new(options[:dict_dbfile])
      end     
      
      dictionary = Model::Database.new(options[:dict_dbfile])
      dictionary.create_table(Model::Word) if !dictionary.exists_table?(Model::Word)
      
      database = Model::Database.new(options[:database_file])
      
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
        newwords = dictionary.size(Model::Word)
        imported = dictionary.load_insert_csv(Model::Word, options[:file], :duplicate => options[:duplicate])
        newwords = dictionary.size(Model::Word) - newwords
        puts "#{imported.size} words parsed and #{newwords} new words added"
        return 0
      end
      
      if options[:action] == :dump
        dictionary.dump
        puts
        
        database.dump
        return 0
      end

      qm = Controller::QuestionsManager.new(dictionary)
      #Start view
      Quizzer::View.add_controller(:dictionary, dictionary)
      Quizzer::View.add_controller(:manager, qm)
      Controller::StatisticsManager.set_database(database)
      Quizzer::View.add_controller(:configuration, Controller::ConfigurationManager.new(dictionary, 0))
      Quizzer::View::run
      
      return 0
    end
    
  end
end
