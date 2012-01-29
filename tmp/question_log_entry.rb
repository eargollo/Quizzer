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

module Quizzer
  module Model
    class QuestionLogEntry
      VERSION = 1
      VERSIONS = [1]
    
      def initialize
	@data = {}
	@data[:time] = Time.now
        @data[:statistics] = {}
        @data[:statistics][:attempts] = []
      end
      
      def update(question, guessed_id, attempts, correct)
	if attempts == 1
	  #First attempt, record question data
	  @data[:title] = question.title
	  @data[:answers] = question.answers
	  @data[:statistics][:correct_answer] = correct
	end
        @data[:statistics][:attempts] << {:guess => guessed_id, :correct => correct, :time => Time.now}
      end
      
      def to_s
        "#{@data[:time]} - #{@data[:question]}"
      end
      
      def question
        @data[:question]
      end
      
      def [](key)
      	@data[key]
      end
     
      def key
        @data[:time]
      end
      
      def load(data)
        @data = QuestionLogEntry.parse(data)
        return self
      end
      
      def dump
        @data
      end
      
      private
      def self.parse(data)
	data[:time] = data[:time] || Time.now
	return data
      end
    end
  end
end