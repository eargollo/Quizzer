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
#1) A method called key that should return the instance unique primary key
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
      
      def size(table_class)
        if table_class == nil
          #Returns the amount of tables
          return @tables.size  
        end
        raise "Table #{table_class} does not exist" if @tables[table_class] == nil
        return @tables[table_class].size
      end
      
      def retrieve(table_class, options = {})
        retdata = []
        
        raise "Table does not exist" if @tables[table_class] == nil
        
        if options[:row]
          #Get the element at a specific position in hash
          element = nil
          @semaphore.synchronize do
            element = @tables[table_class].values[options[:row]]
          end
          return element
        end
        if options[:key]
          return @tables[table_class][options[:key]]
        end
        
        return nil
      end
      
      #Instantiates and inserts an object at its table
      def instantiate(table_class, *data)
        ele = table_class.new(*data)
        ele = self.insert(ele)
        return ele
      end
      
      #Inserts an object at its class table
      #Options: :duplicate - :ignore, :replace, :fail - default :fail
      def insert(instance, options = {})
        table_class = instance.class
        options = {:duplicate => :fail}.merge(options)
        raise "Table for object class #{table_class} does not exist" if @tables[table_class] == nil
        #TODO: Check if method dump is declared in the class
        
        @semaphore.synchronize do
          if @tables[table_class][instance.key] == nil || options[:duplicate] == :replace
            @db.transaction do
              @db["tables"][table_class][instance.key] = instance.dump
              @tables[table_class][instance.key] = instance
            end
          else
            if options[:duplicate] ==:fail 
              raise "Element #{instance} already exists in table #{table_class}" 
            end
          end
        end
        
        return instance
      end
      
      #Instantiates and inserts an object at its table
      #Options: :duplicate - :ignore, :replace, :fail - default :fail
      def load_insert(table_class, data, options = {})
        raise "Table does not exist" if @tables[table_class] == nil
        element = table_class.new.load(data)
        return self.insert(element, options)
      end
      
      def load_insert_batch(table_class, data, options = {})
        elements = []
        data.each do |single_data|
          elements << load_insert(table_class, single_data, options)
        end
        
        return elements
      end
      
      def load_insert_csv(table_class, filename, options = {})
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
        inserted = []
        elements.each do |el|
          inserted << self.insert(el, options)
        end
        return inserted
      end
      
      def update_all
        @tables.each_key do |k|
          self.update_table(k)
        end
      end
      
      def update(obj)
        table_class = obj.class
        
        self.insert(obj, :duplicate => :replace)
      end
      
      def update_insert(obj)
        #TODO: Differentiate and fail with update when object does not exist
        #So far the behavior is the same
        self.update(obj)
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
        data = nil
        @semaphore.synchronize do
          data = @tables[table_class].dup
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