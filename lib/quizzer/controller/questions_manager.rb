# Quizzer - language quiz
# Copyright (C) 2011  Eduardo Argollo
#
#MIT License
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

require "controller/question"

module Quizzer
  module Controller
    class QuestionsManager
      QUESTION_DEFAULT = {:answers => 4, :order => :both}
      
      def initialize(dictionary)
        @dictionary = dictionary   
      end
      
      def get_question(options = {})
        qoptions = QUESTION_DEFAULT.merge(options)
        return generate_question(qoptions)
      end

      def generate_question(options)
        word_count = @dictionary.size
        words = []
        attempts = options[:answers] * 100
        raise "Dictionary does not have enough words" if word_count < options[:answers]
        while words.size < options[:answers]
          word = dict.retrieve(:id => rand(word_count)) 
          #puts "Try word '#{t[0]}' - '#{t[1]}'"
          #Check if word or meaning are duplicated
          #TODO: Check if word or meaning are duplicated
          
          #Add word to list
          words << word
        end
        #Compose question 
        q = Question.new("How are you?", ["Good", "So so", "Bad"], 0)
        return q
      end
    end
  end
end
