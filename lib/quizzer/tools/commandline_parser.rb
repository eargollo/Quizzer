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

require 'optparse'

module Quizzer
  module Tools
    class CommandlineParser
      def self.parse(progname, args)
        options = {:action => :run, :duplicate => :ignore}
        
        opts = OptionParser.new do |parser|
          parser.banner = "Usage: #{progname} [options]"
          parser.separator "Specific options:"
          
          parser.on("-i", "--import [CSVFILE]", "Import words in a CSV file") do |file|
            options[:action] = :import
            options[:file] = file
          end
          
          parser.on("-h", "--help", "Show this message") do
            puts parser
            exit(0)
          end
          
          parser.on("-o", "--[no-]overwrite", "Overwrite when importing or inserting duplicated words") do |ow|
            if ow
              options[:duplicate] = :replace
            else
              options[:duplicate] = :ignore
            end
          end
        end
        
        opts.parse!(args)
        return(options)
      end
    end
  end
end