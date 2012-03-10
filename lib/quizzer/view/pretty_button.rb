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

require 'view/hover_action_label'
module Quizzer
  module View
    import javax.swing.JPanel
    import javax.swing.border.EmptyBorder
    import javax.swing.JLabel
    class PrettyButton < JPanel
      alias :super_setBackground :setBackground
      
      def initialize(color, hover, label, border_size, &action)
        super(GridLayout.new(1,0))
        self.super_setBackground(java.awt.Color.new(0,0,0,1.0))
        @border = EmptyBorder.new(border_size, border_size, border_size, border_size)
        self.setBorder(@border)
        @label = HoverActionLabel.new(color, hover, label, &action)
        self.add(@label)
      end
      
      def setBackground(color)
        @label.setBackcolor(color)
      end
      
      def setEnabled(en)
        @label.setEnabled(en)
      end
      
      def setHorizontalAlignment(orientation)
        @label.setHorizontalAlignment(orientation)
      end
      
      def setText(text)
        @label.setText(text)
      end
    end
  end
end
