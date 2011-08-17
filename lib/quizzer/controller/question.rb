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
  module Controller
    class Question
      def initialize(question, options, answer)
        @question = question
        @options = options   
        @answer = answer
        @listeners = []
        @attempt = 0
      end
      
      def option(id=nil)
        id = @answer if id == nil
        return @options[id]
      end
      
      def question
        title
      end
      
      def title
        return @question
      end
      
      def options
        return @options
      end
      
      def size
        @options.size
      end
      
      def correct?(id)
        @attempt = @attempt + 1
        @listeners.each {|al| al.answer_trigger(self, id, @attempt, id == @answer)}
        return id == @answer
      end
      
      def correct
        return @answer
      end
      
      def show
        puts "---> #{self.title}"
        puts
        self.answers.each_with_index do |el, i|
          puts "#{i+1}) #{el}"
        end  
      end
      
      def add_listener(listener)
        @listeners << listener
      end    
    end
  end
end