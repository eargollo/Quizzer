
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
      
      def wait_next_period #(obj)
        #@target = obj
        #if @period > 0
        #  @thread = Thread.new do
        #    obj.setVisible(false)
        #    sleep(@period)
        #    obj.setVisible(true)
        #  end
        #end


        @thread = Thread.new { sleep(@period) }
        puts "Waiting for thread to finish sleeping..."
        @thread.join
        puts "Joinned thread ... releasing"
        @thread = nil
      end
      
      def interrupt_period
        if @thread != nil && @thread.alive?
          puts "Killing thread"
          Thread.kill(@thread)
        #  if @target != nil
        #    @target.setVisible(true)
        #  end
        end
      end
    end
  end
end
