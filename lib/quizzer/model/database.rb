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

#In order to be stored at the database a class must have
#1) A method called key that should return the instance uniqui primary key
#2) A method load that pushes data into an instance. This method MUST return SELF
#3) new should not receive parameters or parameters should have default initialization 
#3) If it is to be instantiated as a csv, a method validate_csv (to be changed for cathing exceptions)
#4) A method called dump that should return the data to be stored


require 'pstore'
require 'csv'
require 'thread'

require "model/word"

module Quizzer
  module Model
    class Database
      def initialize(dbfile)
        @semaphore = Mutex.new
        dbfile = File.expand_path(dbfile)
        if !File.directory?(File.dirname(dbfile))
          raise "Path #{File.dirname(dbfile)} does not exist."
        end
        
        first_time = !File.exists?(dbfile)
        
        @db = PStore.new(dbfile)
        @tables = {}
        @semaphore.synchronize do
          if first_time
            @db.transaction do
              @db[:created_at] = Time.now
              @db["tables"] = {}
            end
          else
            @db.transaction(true) do
              @db["tables"].each do |tclass, tdata|
                @tables[tclass] = {}
                tdata.each do |data_key, data|
                  
                  @tables[tclass][data_key] = tclass.new.load(data)
                end
              end
            end
          end
        end
      end
      
      def create_table(table_class)
        @semaphore.synchronize do
          if @tables[table_class] == nil 
            @db.transaction do
              @db["tables"][table_class] = {}
              @tables[table_class] = {}
            end
          else 
            raise "Table #{table_class} already exists" 
          end
        end
      end
      
      def exists_table?(table_class)
        return @tables[table_class] != nil ? true : false
      end
      
      def size
        return @tables.size
      end
      
      def retrieve(table_class, options = {})
        retdata = []
        
        raise "Table does not exist" if @tables[table_class] == nil
        
        if options[:id]
          #Get the element at a specific position in hash
          element = nil
          @semaphore.synchronize do
            element = @tables[table_class].values[options[:id]]
          end
          return element
        end
        #TODO: Get by filter
        return retdata
      end
      
      def instantiate(table_class, *data)
        ele = table_class.new(*data)
        ele = self.insert(table_class, ele)
        return ele
      end
      
      #Options: :duplicate - :ignore, :replace, :fail - default :fail
      def insert(table_class, data, options ={})
        options = {:duplicate => :fail}.merge(options)
        raise "Table does not exist" if @tables[table_class] == nil
        element = nil
        if data.is_a?(Hash)
          element = table_class.new.load(data)
        else
          if data.is_a?(Array)
            insert_batch(table_class, data, options)
          else
            if data.is_a?(table_class)
              element = data
            else
              raise "It is not possible to insert data of type #{data.class}"
            end          
          end
        end
        
        raise "Could not parse data #{data.inspect}" if element == nil

        @semaphore.synchronize do
          if @tables[table_class][element.key] == nil || options[:duplicate] == :replace
            @db.transaction do
              @db["tables"][table_class][element.key] = element.dump
              @tables[table_class][element.key] = element
            end
          else
            if options[:duplicate] ==:fail 
              raise "Element #{element} already exists in table #{table_class}" 
            end
          end
        end
        
        return element
      end
      
      def insert_batch(table_class, data, options = {})
        options = {:duplicate => :fail}.merge(options)
        elements = []
        data.each do |el|
          if el.is_a?(Hash)
            elements << table_class.new.load(el)
          else
            if el.is_a?(table_class)
              elements << el
            else
              raise "It is not possible to add data of type #{el.class} to the database table #{table_class}"
            end
          end
        end
        
        @semaphore.synchronize do
          old_table = @tables[table_class].dup
          @db.transaction do
            elements.each do |el|
              if @db["tables"][table_class][el.key] == nil || options[:duplicate] == :replace
                @db["tables"][table_class][el.key] = el.dump
                @table[table_class][el.key] = el
              else
                if options[:duplicate] == :fail
                  @@tables[table_class] = old_table
                  raise "Element #{el} already exists in table #{table_class}" 
                end
              end
            end
          end
        end
        return elements
      end
      
      def insert_csv(table_class, filename, options = {})
        options = {:duplicate => :fail}.merge(options)
        elements = []
        
        data = CSV.read(filename)
        data.each do |el|
          if el.size > 1 && el[0][0] != "#"[0]
            if table_class.validate_csv(el)
              elements << table_class.new.load_csv(el)
            end
          end
        end
        insert_batch(elements, options)
      end
      
      def update_all
        @tables.each_key do |k|
          self.update_table(k)
        end
      end
      
      def update(table_class, obj)
        raise "Object is not from class #{table_class}. It is an #{obj.class}"
        
        self.insert(table_class, obj, :duplicate => :replace)
      end
      
      def update_table(table_class)

        @semaphore.synchronize do
          @db.transaction do
            @tables[table_class].each do |k, d|
              @db["tables"][table_class][k] = d.dump
            end
          end
        end
      end
    
      def retrieve_all(table_class)
        data = {}
        @semaphore.synchronize do
          @db.transaction do
            data = @db["tables"][table_class].dup
          end
        end
        return data
      end

      def dump
        @semaphore.synchronize do
          @db.transaction do
            puts @db.inspect
          end
        end
      end
    end
  end
end