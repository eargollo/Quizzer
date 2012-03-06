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


#require 'view_jruby/hover_action_label'
module Quizzer
  module View
    import javax.swing.JPanel
    import javax.swing.border.EmptyBorder
    import javax.swing.JLabel

    class BorderHighlightPanel < JPanel
      alias :super_setBackground :setBackground
      alias :super_add :add
      
      TRANSPARENT = java.awt.Color.new(0,0,0,0.0)
      
      def initialize(layout = java.awt.BorderLayout.new,
                     border_color = TRANSPARENT,
                     hover_color = TRANSPARENT,
                     margin_size = 0,
                     border_size = 1,
                     &action)
        
        super(GridLayout.new(1,0))
        
        @action = action
        @enable = true
        @border_color = border_color
        @hover_color = hover_color
        
        #TODO: take this out or put a transparent back
        self.super_setBackground(TRANSPARENT)
        
        margin = EmptyBorder.new(margin_size, margin_size, margin_size, margin_size)
        self.setBorder(margin)
        
        @in_panel = JPanel.new(GridLayout.new(1,0))
        @in_panel.setBackground(@border_color)
        border = EmptyBorder.new(border_size, border_size, border_size, border_size)
        @in_panel.setBorder(border)
        
        @panel = JPanel.new(layout)
        
        @in_panel.add(@panel)
        self.super_add(@in_panel)

        self.enableEvents(java.awt.AWTEvent::MOUSE_EVENT_MASK)
      end
      
      def setBackground(color)
        @panel.setBackground(color)
      end
      
      def setBorderColor(color)
        @border_color = color
        @in_panel.setBackground(@border_color)
      end
      
      def setEnabled(en)
        @enable = en
        if @enable == false
          @in_panel.setBackground(@border_color)
        end

        @panel.setEnabled(en)
      end
      
      def add(*parms)
        @panel.add(*parms)
      end
      
      def processMouseEvent(e)
        if @enable
          if e.getID == java.awt.event.MouseEvent::MOUSE_ENTERED
            @in_panel.setBackground(@hover_color)
          end
          if e.getID == java.awt.event.MouseEvent::MOUSE_EXITED
            @in_panel.setBackground(@border_color)
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
