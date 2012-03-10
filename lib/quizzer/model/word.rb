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
    class Word
      VERSION = 1
      VERSIONS = [1]
    
      TYPES = [:substantive, :verb]
      GENDERS = { "der" => :masculine, "die" => :feminine, "das" => :neutral}
      
      def initialize(data = nil, encoded = false)
	return if data == nil
        if data[:version] != nil
          load(data)
        else
          parse(data, encoded)
        end
      end
      
      def to_s
        @data[:word]
      end
      
      def word
        @data[:word]
      end
      
      def [](key)
      	@data[key]
      end
     
      def key
        @data[:word_parsed]
      end
      
      def get_complement(key)
      	@data[:original][key]
      end
      
      def meaning
        @data[:meaning]
      end
      
      def means?(meaning)
        @data[:meaning] == meaning
      end
      
      def <=>(word)
        self.to_s == word.to_s 
      end
      
      def serialize
        @data
      end
    
      def type
      	@data[:type]
      end
      
      def load_csv(data)
	raise "Expected a CSV array" if !data.is_a?(Array)
	raise "Insufficient elements" if data.size < 2
	dhash = {}
	dhash[:word] = data.shift
	dhash[:meaning] = data.shift
	dhash[:other_csv_fields] = data
	parse(dhash)
	return self
      end
      
      def load(data)
        raise "Non existent version of word data #{data[:version]}. Actual versions are #{VERSIONS.join(",")}" if !VERSIONS.include?(data[:version])
        raise "Word is required" if data[:word] == nil
        raise "Meaning is required" if data[:meaning] == nil
        @data = data.dup
        return self
      end
      
      def dump
        @data
      end
      
      def self.validate_csv(data)
	#Requires at least two fields: Word and Meaning (others will be kept away)
	if data.is_a?(Array)
	  if data.size >= 2
	    return true
	  end
	end
	return false
      end
      
      private
      
      def parse(data, encoded = false)
        raise "Word is required" if data[:word] == nil
        raise "Meaning is required" if data[:meaning] == nil
        if data[:version] != nil
          @data = data.dup
        else
          @data = {}
          @data[:version] = VERSION
          @data[:original] = data.dup
          @data[:time] = Time.now
          parts = data[:word].split(" ")
          possible_article = parts[0].strip.downcase
          if GENDERS.keys.include?(possible_article)
            @data[:type] = :substantive
            @data[:gender] = GENDERS[possible_article]
            @data[:article] = possible_article
            #puts "Word '#{data[:word]}' enconding" + data[:word].encoding.name
            @data[:word_parsed] = encoded ? parts[1..-1].join(" ").strip : parts[1..-1].join(" ").strip.unpack("C*").pack("U*")
          else
            @data[:type] = :unknown
	    @data[:word_parsed] = encoded ? data[:word].strip : data[:word].strip.unpack("C*").pack("U*")
          end
	  @data[:word] = encoded ? data[:word].strip : data[:word].strip.unpack("C*").pack("U*")
	  @data[:meaning] = encoded ? data[:meaning].strip : data[:meaning].strip.unpack("C*").pack("U*")
        end
      end
    end
  end
end