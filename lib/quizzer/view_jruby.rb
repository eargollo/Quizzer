$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'view'
require 'view_jruby/quizzer'

module Quizzer
  VERSION = '0.2'
  RELEASE = Time.utc(2012,1,28, 22, 05, 0)

  module View
    def run
      Quizzer::View::JQuizzer.new
    end
    
    module_function :run
  end
end
