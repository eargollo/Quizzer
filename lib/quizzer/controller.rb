$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'controller/question'
require 'controller/questions_manager'
  
module Quizzer
  module Controller
    VERSION = '0.0.1'
  end
end