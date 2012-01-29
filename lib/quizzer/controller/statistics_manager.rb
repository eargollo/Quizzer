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
    class StatisticsManager
      
      def self.set_database(database)
        @@db = database
        if !@@db.exists_table?(Model::Question)
          @@db.create_table(Model::Question)
        end
        @@stats = Statistics.new(@@db.retrieve_all(Model::Question))
      end
    
      def self.get_observer
        return [self, @@stats]
      end

      def self.update(question, guessed_id, attempts, correct, finished)
        if finished
          @@db.update_insert(question)
        end
      end
      
      def self.get_statistics
        @@stats
      end
    end
    
    class Statistics
      class SummaryStatistic
        def initialize
          @stats = { :error_attempt => [] }
          [:questions, :correct, :error].each do |t|
            @stats[t] = 0
          end
        end
        
        def add(correct, amount_answers)
          @stats[:questions] += 1
          if correct
            @stats[:correct] += 1
          else
            @stats[:error] += 1
            attempt = amount_answers - 2
            @stats[:error_attempt][attempt] ||= 0
            @stats[:error_attempt][attempt] += 1
          end
        end
        
        def get_stats
          @stats.dup
        end
      end
      
      def WordsStatistics
        def initialize
          @dictionary = Quizzer::View.get_controller(:dictionary)
          
        end
      end
      
      def initialize(initial_data = nil)
        init_stats
        if initial_data
          initial_data.values.each do |question|
            @general.add(question.answered_correct?, question.attempts.size)
          end
        end
      end
      
      def init_stats
        @general = SummaryStatistic.new 
        @session = SummaryStatistic.new 
      end
      
      def get_general(key = nil)
        return @general.get_stats if key == nil
        return @general.get_stats[key]
      end
      
      def get_session(key = nil)
        return @session.get_stats if key == nil
        return @session.get_stats[key]
      end
      
      def update(question, guessed_id, attempts, correct, finished)
        if finished
          @general.add(question.answered_correct?, attempts)
          @session.add(question.answered_correct?, attempts)
	end 
      end
    end
  end
end
