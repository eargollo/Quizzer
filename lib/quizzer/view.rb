$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Quizzer
  module View
    VERSION = '0.0.1'
    @@controllers = {}
    
    def add_controller(type, obj)
      @@controllers[type] = obj
    end

    def get_controller(type)
      @@controllers[type]
    end
    
    module_function :add_controller, :get_controller
  end
end

