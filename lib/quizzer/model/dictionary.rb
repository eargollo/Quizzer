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

require "model/word"

module Quizzer
  module Model
    class Dictionary
      def initialize(dbfile)
        if !File.exists?(File.dirname(dbfile))
          raise "Path #{File.expand_path(File.dirname(dbfile))} does not exist."
        end
        @db = PStore.new(dbfile)
        @db.transaction do
          @db[:created_at] = Time.now
          @db["data"] = {}
        end
      end
      
      def size
        sz = -1
      
        @db.transaction(true) do 
          sz = @db["data"].size
        end
        return sz
      end
      
      def retrieve(options = {})
        words = []
        if options[:id]
          #Get the element at a specific position in hash
          word = nil
          @db.transaction(true) do  # begin read-only transaction, no changes allowed
            #TODO: Check if it is greater than size
            word = @db["data"].values[options[:id]]
          end
          return word
        end
        #TODO: Get by filter
        return words
      end
      
      
      
      def insert(data)
        word = nil
        if data.is_a?(Hash)
          word = Word.new(data)
        else
          if data.is_a?(Word)
            word = data
          end          
        end
        
        raise "Could not parse data #{data.inspect}" if word == nil
        @db.transaction do
          raise "Word already exists" if @db[word.key] != nil
          @db["data"][word.key] = word
        end
        return word
      end
      
      #TODO: Insert a word
      #TODO: Insert an array of words
      #TODO: Insert an csv file
      #TODO: Insert an array of hash elements representing words
    end
  end
end