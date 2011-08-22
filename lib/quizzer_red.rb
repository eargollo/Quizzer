#!/usr/bin/ruby

#Add local folder to include path
$: << File.expand_path(File.dirname(__FILE__)+'/../lib/quizzer')

require "quizzer/controller"
require "quizzer/model"
require "quizzer/tools"
require 'quizzer/view_red_shoes'
