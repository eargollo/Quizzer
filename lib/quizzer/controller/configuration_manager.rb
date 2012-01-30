
require "thread"

module Quizzer
  module Controller
    class ConfigurationManager
      def initialize(database, id)
        @db = database
        if !@db.exists_table?(Model::Configuration)
          @db.create_table(Model::Configuration)
        end
        @configuration = @db.retrieve(Model::Configuration, :key => 0)
        if @configuration == nil
          @configuration = @db.instantiate(Model::Configuration)
        end
        @thread = nil
        @target = nil
      end
      
      def get_period
        @configuration.get(:period)
      end
      
      def set_period(period)
        res = @configuration.set(:period, period)
        @db.update(@configuration)
        return res
      end
      
      def wait_next_period
        @thread = Thread.new { sleep(self.get_period) }
        @thread.join
        @thread = nil
      end
      
      def get(key)
        @configuration.get(key)
      end
      
      def set(key, value)
        res = @configuration.set(key, value)
        @db.update(@configuration)
        return res
      end
      
      def interrupt_period
        if @thread != nil && @thread.alive?
          Thread.kill(@thread)
        end
      end
    end
  end
end
