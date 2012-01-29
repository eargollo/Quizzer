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

require 'observer'

module Quizzer
  module Model
    class Question
      include Observable
      
      #Should receive a hash or nothing
      #Hash options:
      # title, options(choosable options), correct_id (id of the chosable option that is correct)
      #Other arguments will be saved as well
      def initialize(data = nil)
        @data = {}
        @data[:time] = Time.now
        if data != nil
          #VALIDATE
          raise "Data must be a hash" if !data.is_a?(Hash)
          [:title, :options, :correct_id].each do |key|
            raise "Parameter #{key} not found" if data[key] == nil
          end
          raise "Parameter option must be an array and it is #{data[:options].class}" if !data[:options].is_a?(Array)
          @data = data.merge(@data)
        end
        @data[:finished] = false
        @data[:answered_correct] = nil
        @data[:answers] = []
      end
      
      def option(id=nil)
        id = @data[:correct_id] if id == nil
        return @data[:options][id]
      end
      
      def question
        title
      end
      
      def title
        return @data[:title]
      end
      
      def options
        return @data[:options]
      end
      
      def answers
        options
      end
      
      def get(key)
        @data[key]
      end
      
      def attempts
        @data[:answers]
      end
      
      def size
        @data[:options].size
      end
      
      def correct?(id)
        is_correct = (id == @data[:correct_id])
        if @data[:answered_correct] == nil
          @data[:answered_correct] = is_correct
        end
        @data[:finished] = @data[:finished] || is_correct
        @data[:answers] << {:time => Time.now, :answer => id, :correct => is_correct}
        changed
        #The Question object, if this answer was correct (NOT THE QUESTION CORRECTLY ANSERED)
        # To get if the question was correctly answered call answered_correct? from the object
        notify_observers(self, id, @data[:answers].size, is_correct, @data[:finished])
        return is_correct
      end
      
      def answered_correct?
        @data[:answered_correct]
      end
      
      def correct
        return @data[:correct_id]
      end
      
      def to_s
        st = "Question: #{self.title}\n" 
        self.answers.each_with_index do |el, i|
          st += "\t#{i+1}) #{el}\n"
        end
        return st
      end
      
      def key
        return @data[:time]
      end
      
      def load(data)
        #TODO: Should do all the checking
        @data = data
        return self
      end
      
      def dump
        @data
      end
      
    end
  end
end