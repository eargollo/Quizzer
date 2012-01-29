$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'model/word'
require 'model/database'
require 'model/question'

module Quizzer
  module Model
    VERSION = '0.0.1'
  end
end