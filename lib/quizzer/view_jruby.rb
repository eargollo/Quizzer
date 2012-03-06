$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'view'
require 'view_jruby/statistics'
require 'view_jruby/quizzer_main'

module Quizzer
  VERSION = '0.5'
  RELEASE = Time.utc(2012,3,5, 22, 05, 0)

  module View
    def run
      #Quizzer::View::Systray.new
      Quizzer::View::QuizzerMain.new
    end
    
    module_function :run
  end
end
