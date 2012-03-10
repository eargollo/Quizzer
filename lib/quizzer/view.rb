$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'view/statistics'
require 'view/quizzer_main'
require 'view/add_words'

module Quizzer
  module View
    VERSION = '0.0.1'
    @@controllers = {}
    
    def add_controller(type, obj)
      @@controllers[type] = obj
    end

    def get_controller(type)
      @@controllers[type]
    end
    
    def run
      #Quizzer::View::Systray.new
      Quizzer::View::QuizzerMain.new
    end
    
    module_function :add_controller, :get_controller, :run
  end
end

