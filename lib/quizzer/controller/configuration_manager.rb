
require "thread"

module Quizzer
  module Controller
    class ConfigurationManager
      def initialize(data = {})
        @period = data[:period] || 0
        @thread = nil
        @target = nil
      end
      
      def get_period
        @period
      end
      
      def set_period(period)
        @period = period
      end
      
      def wait_next_period
        @thread = Thread.new { sleep(@period) }
        @thread.join
        @thread = nil
      end
      
      def interrupt_period
        if @thread != nil && @thread.alive?
          Thread.kill(@thread)
        end
      end
    end
  end
end
