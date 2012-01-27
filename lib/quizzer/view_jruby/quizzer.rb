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

include Java
require 'view_jruby/action_button'

module Quizzer
  module View
    import javax.swing.JFrame
    import javax.swing.JPanel
    import java.awt.GridLayout
    import java.awt.BorderLayout
    import javax.swing.JLabel
  
    class JQuizzer < JFrame
      
      def initialize
        super("Quizzer")
        @@db = Quizzer::View.get_controller(:dictionary)
        @@qm = Quizzer::View.get_controller(:manager)
        self.initUI
      end
    
      def initUI
        self.setSize(400,300)
        self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
        
        @label = JLabel.new
        @in_panel = JPanel.new(GridLayout.new)
        self.getContentPane.add(@label, BorderLayout::NORTH);
        self.getContentPane.add(JLabel.new("Database has #{@@db.size} definitions"), BorderLayout::SOUTH);
        ask(@@qm.get_question)
      end
      
      def ask(question)
        #Set Question title
        @label.setText(question.title)
        
        @in_panel.removeAll
        @in_panel.getLayout.setRows(question.answers.size)
        @in_panel.getLayout.setColumns(1)
        question.answers.each_with_index.each do |q, i|
          button = ActionButton.new(q) do
            puts q
            if question.correct?(i)
              button.setBackground(java.awt.Color::green)
              ask(@@qm.get_question)
            else
              button.setBackground(java.awt.Color::red)
            end
            button.setEnabled(false)
          end
          @in_panel.add button
        end
        
        self.getContentPane.add(@in_panel, BorderLayout::CENTER);
        self.setVisible(true);
      end
    end  
  end
end
