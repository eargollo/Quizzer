# Quizzer - language quiz
# Copyright (C) 2012  Eduardo Argollo
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
  module View
    import javax.swing.JLabel

    class HoverActionLabel < JLabel
      def initialize(color, hover, *arg, &blk)
        super(*arg)
        @enable = true
        @action = blk
        @color = color
        @hover = hover
        self.setBackground(@color)
        self.setOpaque(true)
        self.enableEvents(java.awt.AWTEvent::MOUSE_EVENT_MASK)
      end
      
      def setBackcolor(color)
        @color = color
      end
      
      def setHovercolor(color)
        @hover = color
      end
      
      def setEnabled(en)
        @enable = en
        if @enable == false
          self.setBackground(@color)
        end
      end
      
      def processMouseEvent(e)
        if @enable
          if e.getID == java.awt.event.MouseEvent::MOUSE_ENTERED
            self.setBackground(@hover)
          end
          if e.getID == java.awt.event.MouseEvent::MOUSE_EXITED
            self.setBackground(@color)
          end
          if e.getID == java.awt.event.MouseEvent::MOUSE_PRESSED
            if @action != nil
              @action.call
            end
          end
        end
      end
    end    
  end
end
