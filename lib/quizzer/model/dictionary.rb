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

require 'pstore'
require 'csv'
require 'thread'

require "model/word"

module Quizzer
  module Model
    class Dictionary
      def initialize(dbfile)
        @semaphore = Mutex.new
        if !File.exists?(File.dirname(dbfile))
          raise "Path #{File.expand_path(File.dirname(dbfile))} does not exist."
        end
        
        first_time = !File.exists?(dbfile)
        
        @db = PStore.new(dbfile)
        @words = {}
        @semaphore.synchronize do
          if first_time
            @db.transaction do
              @db[:created_at] = Time.now
              @db["data"] = {}
            end
          else
            @db.transaction(true) do
              @db["data"].each do |k, d|
                word = Word.new(d)
                @words[word.key] = word
              end
            end
          end
        end
      end
      
      def size
        return @words.size
      end
      
      def retrieve(options = {})
        words = []
        if options[:id]
          #Get the element at a specific position in hash
          word = nil
          @semaphore.synchronize do
            word = @words.values[options[:id]]
          end
          return word
        end
        #TODO: Get by filter
        return words
      end
      
      #Options: :duplicate - :ignore, :replace, :fail - default :fail
      def insert(data, options ={})
        options = {:duplicate => :fail}.merge(options)
        word = nil
        if data.is_a?(Hash)
          word = Word.new(data)
        else
          if data.is_a?(Array)
            insert_batch(data, options)
          else
            if data.is_a?(Word)
              word = data
            else
              raise "It is not possible to insert data of type #{data.class}"
            end          
          end
        end
        
        raise "Could not parse data #{data.inspect}" if word == nil

        @semaphore.synchronize do
          if @words[word.key] == nil || options[:duplicate] == :replace
            @db.transaction do
              @db["data"][word.key] = word.dump
              @words[word.key] = word
            end
          else
            if options[:duplicate] ==:fail 
              raise "Word #{word} already exists" 
            end
          end
        end
        
        return word
      end
      
      def insert_batch(data, options = {})
        options = {:duplicate => :fail}.merge(options)
        words = []
        data.each do |el|
          if el.is_a?(Hash)
            words << Word.new(el)
          else
            if el.is_a?(Word)
              words << el
            else
              raise "It is not possible to add data of type #{el.class} to the dictionary"
            end
          end
        end
        
        @semaphore.synchronize do
          old_words = @words.dup
          @db.transaction do
            words.each do |word|
              if @db["data"][word.key] == nil || options[:duplicate] == :replace
                @db["data"][word.key] = word.dump
                @words[word.key] = word
              else
                if options[:duplicate] == :fail
                  @words = old_words
                  raise "Word #{word} already exists" 
                end
              end
            end
          end
        end
        return words
      end
      
      def insert_csv(filename, options = {})
        options = {:duplicate => :fail}.merge(options)
        words = []
        
        data = CSV.read(filename)
        data.each do |el|
          if el.size > 1 && el[0][0] != "#"[0]
            words << Word.new(:word => el[0], :meaning => el[1])
          end
        end
        insert_batch(words, options)
      end
    end
  end
end