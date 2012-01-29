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

require "model/question"

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
        raise "Dictionary does not have enough words" if word_count < options[:answers]
        
        ids = []
        while ids.size < options[:answers]
          id = rand(word_count)
          while ids.include?(id)
            id = (id + 1) % word_count
          end
          ids << id
        end
        ids.each {|idw| words << @dictionary.retrieve(:id => idw) } 
        answer = rand(words.size)
        answers = words.map {|w| w.meaning } 
        #Compose question 
        q = Model::Question.new(words[answer].word, answers, answer)
        obs = StatisticsManager.get_observer
        if obs.is_a?(Array)
          obs.each { |ob| q.add_observer(ob)}
        else
          q.add_observer obs  
        end
        
        return q
      end
      
      def update *a
        puts "self"
      end
    end
  end
end
