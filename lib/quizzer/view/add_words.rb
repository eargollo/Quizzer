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

module Quizzer
  module View
    import javax.swing.JFrame
    import javax.swing.JTable
    import javax.swing.BoxLayout
    import java.awt.BorderLayout
    import java.awt.FlowLayout
    import java.awt.TextField
    import java.awt.Button
  
    class AddWords < JFrame
      BORDER = 8
      
      def initialize
        super("Add words")
        @@st = Quizzer::View.get_controller(:statistics)
        @word_database = Quizzer::View.get_controller(:dictionary)
        self.init_ui
      end
    
      def init_ui
        self.setSize(440,165)
        
        main_panel = JPanel.new
        main_panel.setLayout(BoxLayout.new(main_panel, BoxLayout::Y_AXIS))
        
        word_import_panel = JPanel.new(BorderLayout.new)
        
        word_form_panel = JPanel.new
        word_form_panel.setLayout(BoxLayout.new(word_form_panel, BoxLayout::Y_AXIS))
        
        word_panel = JPanel.new(FlowLayout.new)
        
        lb1 = javax.swing.JLabel.new("   Word:")
        lb1.setBorder(javax.swing.border.EmptyBorder.new(BORDER,BORDER,BORDER,BORDER))
        
        @tf_word = TextField.new("", 30)
        
        word_panel.add(lb1)
        word_panel.add(@tf_word)

        mean_panel = JPanel.new(FlowLayout.new)

        lb2 = javax.swing.JLabel.new("Meaning:")
        lb2.setBorder(javax.swing.border.EmptyBorder.new(BORDER,BORDER,BORDER,BORDER))

        @tf_meaning = TextField.new("", 30)
        
        import_bt = ActionButton.new("Add Word") do
          word = @tf_word.getText.chomp
          meaning = @tf_meaning.getText.chomp
          
          if word.size > 0 && meaning.size > 0
            word_obj = Model::Word.new({:word => word, :meaning => meaning}, true)
            puts "Key '#{word_obj.key}'"
            @word_database.insert(word_obj, :duplicate => :replace)
          end
        end
        
        mean_panel.add(lb2)
        mean_panel.add(@tf_meaning)
        mean_panel.add(import_bt)

        file_import_panel = JPanel.new(FlowLayout.new)
        file_bt = ActionButton.new("Import File") do
          fc = javax.swing.JFileChooser.new
          res = fc.showOpenDialog(self)
          if(res == javax.swing.JFileChooser::APPROVE_OPTION) 
            file = fc.getSelectedFile().getName()
          end
        end
        file_import_panel.add(file_bt)

        word_form_panel.add(word_panel)
        word_form_panel.add(mean_panel)
        word_form_panel.add(file_import_panel)
        
        #import_bt = Button.new("Import")
        
        #word_import_panel.add(import_bt, BorderLayout::EAST)

        word_import_panel.add(word_form_panel)
        
        main_panel.add(word_import_panel)
        

        self.getContentPane.add(main_panel);
        self.setVisible(true);
      end
    end  
  end
end
