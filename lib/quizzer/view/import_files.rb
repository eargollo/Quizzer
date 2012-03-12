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
    import javax.swing.border.LineBorder;
    import javax.swing.table.DefaultTableModel;
    import javax.swing.JFileChooser
    import javax.swing.JOptionPane
    import javax.swing.JScrollPane
    import java.awt.Dimension;
    
    class ImportFiles < QuizzerFrame
      def initialize
        super
        @word_database = Quizzer::View.get_controller(:dictionary)
        @elements = []
        init_ui
        self.setVisible(true)
      end
      
      def init_ui
	setTitle("Import files");
	#setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE);
	setBounds(100, 100, 450, 350);
	contentPane = JPanel.new;
	contentPane.setBorder(EmptyBorder.new(5, 5, 5, 5));
	setContentPane(contentPane);
	contentPane.setLayout(nil);
		
	panel = Panel.new;
	panel.setBackground(Color::WHITE);
	panel.setBounds(0, 0, 434, 85);
	contentPane.add(panel);
	panel.setLayout(nil);
		
	lblNewLabel = JLabel.new("<html>Select a file, click on \"Load\" to preview the words to be imported and \"Save\" for importing all the words.</html>");
	lblNewLabel.setBounds(10, 11, 414, 64);
	panel.add(lblNewLabel);
		
	lblSelectFileTo = JLabel.new("File To Import:");
	lblSelectFileTo.setBounds(10, 100, 125, 14);
	contentPane.add(lblSelectFileTo);
	
	textField = JTextField.new;
	textField.setBounds(126, 97, 145, 20);
	contentPane.add(textField);
	textField.setColumns(10);
		
	btnSelect = ActionButton.new("...") do
          fc = JFileChooser.new;
          returnVal = fc.showOpenDialog(self);
          file = fc.getSelectedFile();
          textField.setText(file.getAbsolutePath)  
	end
	
	btnSelect.setBounds(281, 96, 25, 23);
	contentPane.add(btnSelect);
	
	
		
	table = JTable.new;
	tm = DefaultTableModel.new
        tm.addColumn("Word")
        tm.addColumn("Meaning")
	
	table.setModel(tm)
                                             
	
	table.getColumnModel().getColumn(0).setPreferredWidth(200);
	table.getColumnModel().getColumn(1).setPreferredWidth(200);
	table.setBorder(javax.swing.border.LineBorder.new(Color.new(0, 0, 0)));
	table.setBounds(0, 0, 414, 149);
	table.setPreferredScrollableViewportSize(Dimension.new(400, 125));
	table.setFillsViewportHeight(true);
	
	table_panel = JPanel.new
	table_panel.setBounds(10,125,414,149)
	table_panel.add(table)
	
	table_panel.add(JScrollPane.new(table));
	
	contentPane.add(table_panel) #table);
		
		
	btnNewButton = ActionButton.new("Load") do
          file = textField.getText
          file = file.chomp
          if !File.exists?(file)
            JOptionPane.showMessageDialog(self,
                                          "File '#{file}' could not be found.",
                                          "Quizzer Error",
                                          JOptionPane::ERROR_MESSAGE);
          else
            @elements = []
            data = CSV.read(file)
            data.each do |el|
              if el.size > 1 && el[0][0] != "#"[0]
                if Model::Word.validate_csv(el)
                  @elements << Model::Word.new.load_csv(el)
                end
              end  
            end
            #Clean and fulfill table
            tm.setRowCount(0)
            @elements.each do |w|
              tm.addRow([w.word, w.meaning].to_java)
            end
          end
	end
	btnNewButton.setBounds(316, 96, 89, 23);
	contentPane.add(btnNewButton);
		
	button = ActionButton.new("Save") do
          @elements.each do |word|
            @word_database.insert(word, :duplicate => :replace)
          end
          
          Quizzer::Controller::StatisticsManager.load
          Quizzer::View::QuizzerMain.getMainWindow.set_stats
          
          self.dispose
	end
	button.setBounds(258, 280, 80, 22);
	contentPane.add(button);
		
	button_1 = ActionButton.new("Cancel") do
          self.dispose
	end
	button_1.setBounds(344, 280, 80, 22);
	contentPane.add(button_1);
      end
    end
  end
end
