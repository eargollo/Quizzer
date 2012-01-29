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
      
      class WordsStatistics
        def initialize
          dictionary = Quizzer::View.get_controller(:dictionary)
          tb = dictionary.retrieve_all(Model::Word)
          @words = {}
          tb.each { |k,w| @words[k] = create_stat}
        end
        
        def create_stat
          { :score => 0.15, :asked => 0, :right => 0, :wrong => 0, :participated => 0, :part_at_wrong => 0, :wrong_answered => 0 } 
        end
        
        def add(question)
          #Each right increases in 0.1 until it reaches 1.0
          #Each asked wrong decreases depending on the attempt up to 50% (50 * attempt / possible attepts)
          #Clicked wrong in an attempt decreases 0.1 to a minimum of 0
          #Participated at a wrong and was not chosen 0.001
          keys = question.get(:keys)
          answer = question.correct
          answer_key = keys[answer]
          keys.each do |k|
            if @words[k] == nil
              @words[k] = create_stat
            end
            if k == answer_key
              @words[k][:asked] += 1
            else
              @words[k][:participated] += 1
              if !question.answered_correct?
                @words[k][:part_at_wrong] += 1
                @words[k][:score] = (@words[k][:score] + 0.001) > 1 ? 1 : (@words[k][:score] + 0.001)
              end
            end
          end
          if question.answered_correct?
            #Correct
            #Increase score
            @words[answer_key][:score] = (@words[answer_key][:score] + 0.1) > 1.0 ? 1.0 : (@words[answer_key][:score] + 0.1)
            @words[answer_key][:right] += 1 
          else
            @words[answer_key][:wrong] += 1 
            #Decrement the asked
            atpt = question.attempts.size - 1
            dec = (0.5 * atpt ) / ( question.options.size - 1)
            @words[answer_key][:score] = @words[answer_key][:score] * (1 - dec)
            #Increases all answers in 0.001 at begiinging so decrease 0f .101
            #Decrease of each incorrectly answered
            question.attempts.each do |attempt|
              if !attempt[:correct]
                key = keys[attempt[:answer]]
                @words[key][:score] = (@words[key][:score] - 0.101) < 0.0 ? 0.0 : (@words[key][:score] - 0.101)
                @words[key][:wrong_answered] += 1
              end
            end
          end
        end
        
        def get_stats
          @words
        end
      end
      
      def initialize(questions = nil)
        init_stats
        if questions
          questions.values.each do |question|
            @general.add(question.answered_correct?, question.attempts.size)
            @words_stats.add(question)
          end
          
          #Dump workds stats
          #words = get_words
          #sorted = words.to_a.sort {|a,b| b[1][:score] <=> a[1][:score] }
          #sorted.each_with_index do |w,i|
          #  puts "#{i+1}) #{w[0]} - Score: #{w[1][:score]} asked/r/w #{w[1][:asked]}/#{w[1][:right]}/#{w[1][:wrong]} Part/P@W/W #{w[1][:participated]}/#{w[1][:part_at_wrong]}/#{w[1][:wrong_answered]}"
          #end
        end
      end
      
      def init_stats
        @general = SummaryStatistic.new 
        @session = SummaryStatistic.new
        @words_stats = WordsStatistics.new
      end
      
      def get_general(key = nil)
        return @general.get_stats if key == nil
        return @general.get_stats[key]
      end
      
      def get_session(key = nil)
        return @session.get_stats if key == nil
        return @session.get_stats[key]
      end
      
      def get_words(key = nil)
        return @words_stats.get_stats if key == nil
        return @words_stats.get_stats[key]
      end
      
      def update(question, guessed_id, attempts, correct, finished)
        if finished
          @general.add(question.answered_correct?, attempts)
          @session.add(question.answered_correct?, attempts)
          @words_stats.add(question)
	end 
      end
    end
  end
end
