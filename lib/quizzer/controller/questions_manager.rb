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
require "model/word"

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

      #def generate_question(options)
      #  word_count = @dictionary.size(Model::Word)
      #  words = []
      #  raise "Dictionary does not have enough words" if word_count < options[:answers]
      #  
      #  rows = []
      #  while rows.size < options[:answers]
      #    row = rand(word_count)
      #    while rows.include?(row)
      #      row = (row + 1) % word_count
      #    end
      #    rows << row
      #  end
      #  #Get words
      #  rows.each {|wrow| words << @dictionary.retrieve(Model::Word, :row => wrow) }
      #  
      #  answer = rand(words.size)
      #  keys = words.map {|w| w.key}
      #  words_text = words.map {|w| w.word} 
      #  meanings = words.map {|w| w.meaning }
      #  
      #  q = nil
      #  if rand(2) == 0
      #    #Compose straigh question 
      #    q = Model::Question.new(:title => words_text[answer], :options => meanings, :correct_id => answer, :keys => keys)
      #  else
      #    #Compose reverse question
      #    q = Model::Question.new(:title => meanings[answer], :options => words_text, :correct_id => answer, :keys => keys)
      #  end
      #  obs = StatisticsManager.get_observer
      #  if obs.is_a?(Array)
      #    obs.each { |ob| q.add_observer(ob)}
      #  else
      #    q.add_observer obs  
      #  end
      #  
      #  return q
      #end
      
      def generate_question(options)
        all_words = []
        wordtable = @dictionary.retrieve_all(Model::Word)
        raise "Dictionary does not have enough words" if wordtable.size < options[:answers]
        wordtable.each do |k, w|
          st = Controller::StatisticsManager.get_statistics.get_words(w.key)
          tkts = 101 - ( st == nil ? 0 : (st[:score]*100).round )
          #puts "#{tkts} tickets for #{w.key}"
          tkts.times do
            all_words << w
          end
        end
        
        word_count =  all_words.size
        #puts "Alternatives = #{word_count}"
        
        words = []
        while words.size < options[:answers]
          row = rand(word_count)
          while words.include?(all_words[row])
            row = rand(word_count)
          end
          words << all_words[row]
        end
        
        answer = rand(words.size)
        keys = words.map {|w| w.key}
        words_text = words.map {|w| w.word} 
        meanings = words.map {|w| w.meaning }
        
        q = nil
        if rand(2) == 0
          #Compose straigh question 
          q = Model::Question.new(:title => words_text[answer], :options => meanings, :correct_id => answer, :keys => keys)
        else
          #Compose reverse question
          q = Model::Question.new(:title => meanings[answer], :options => words_text, :correct_id => answer, :keys => keys)
        end
        obs = StatisticsManager.get_observer
        if obs.is_a?(Array)
          obs.each { |ob| q.add_observer(ob)}
        else
          q.add_observer obs  
        end
        
        return q
      end
    end
  end
end
