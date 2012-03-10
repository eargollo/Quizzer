module Quizzer
  module View
    class ActionButton < import javax.swing.JButton
        def initialize(name="", &blk)
          @action = blk
          super(name)
        end
        def fireActionPerformed(e)
          super(e)
          if @action != nil
            @action.call
          end
        end
    end
  end
end
