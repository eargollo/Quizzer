$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'controller/questions_manager'
require 'controller/statistics_manager'
require 'controller/configuration_manager'
  
module Quizzer
  module Controller
    VERSION = '0.0.1'
  end
end