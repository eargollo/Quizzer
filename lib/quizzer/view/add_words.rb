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
require 'view/action_button'
require 'view/quizzer_frame'

module Quizzer
  module View
    import java.awt.BorderLayout;
    import java.awt.EventQueue;
    
    import javax.swing.JFrame;
    import javax.swing.JPanel;
    import javax.swing.border.EmptyBorder;
    import java.awt.Panel;
    import java.awt.Color;
    import javax.swing.JLabel;
    #import java.awt.Window.Type;
    import javax.swing.JTextField;
    import javax.swing.SwingConstants;
    import java.awt.Button;
    
    class AddWords < QuizzerFrame
      def initialize
        super
        @word_database = Quizzer::View.get_controller(:dictionary)
        self.init_ui
      end
      
      def init_ui
        self.setTitle("Add a word to dictionary");
        #self.setType(Window.Type::UTILITY);
        self.setResizable(false);
        #self.setUndecorated(true)
        #self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE);
        self.setBounds(100, 100, 279, 185);
        contentPane = JPanel.new;
        contentPane.setBorder(EmptyBorder.new(5, 5, 5, 5));
        self.setContentPane(contentPane);
        contentPane.setLayout(nil);
                    
        topPanel = Panel.new;
        topPanel.setBackground(Color::WHITE);
        topPanel.setBounds(0, 0, 279, 60);
        contentPane.add(topPanel);
        topPanel.setLayout(nil);
                    
        lblTop = JLabel.new("<html>In order to add a new word to the dictionary, write the word in the language you are learning, its meaning and click add.</html>");
        lblTop.setBounds(10, 8, 255, 42);
        topPanel.add(lblTop);
                    
        lblWord = JLabel.new("Word:");
        lblWord.setBounds(10, 69, 66, 14);
        contentPane.add(lblWord);
                    
        textWord = JTextField.new;
        textWord.setBounds(71, 66, 188, 20);
        contentPane.add(textWord);
        textWord.setColumns(10);
                    
        textMeaning = JTextField.new;
        textMeaning.setBounds(71, 97, 188, 20);
        contentPane.add(textMeaning);
        textMeaning.setColumns(10);
                    
        lblMeaning = JLabel.new("Meaning:");
        lblMeaning.setVerticalAlignment(SwingConstants::BOTTOM);
        lblMeaning.setBounds(10, 100, 66, 14);
        contentPane.add(lblMeaning);
                    
        button = ActionButton.new("Add") do
          word = textWord.getText.chomp
          meaning = textMeaning.getText.chomp
          
          if word.size > 0 && meaning.size > 0
            word_obj = Model::Word.new({:word => word, :meaning => meaning}, true)
            @word_database.insert(word_obj, :duplicate => :replace)
          end
          
          Quizzer::Controller::StatisticsManager.load
          Quizzer::View::QuizzerMain.getMainWindow.set_stats
          
          textWord.setText("")
          textMeaning.setText("")
        end
        
        button.setBounds(103, 131, 80, 22);
        contentPane.add(button);
                    
        button_cancel = ActionButton.new("Close") do
          self.dispose
        end
        button_cancel.setBounds(189, 131, 80, 22);
        contentPane.add(button_cancel);

        self.setVisible(true);
      end
    end
  end
end
