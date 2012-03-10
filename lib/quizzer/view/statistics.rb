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

module Quizzer
  module View
    import javax.swing.JFrame
    import javax.swing.JTable
  
    class Statistics < JFrame
      
      def initialize
        super("Statistics")
        @@st = Quizzer::View.get_controller(:statistics)
        @word_database = Quizzer::View.get_controller(:dictionary)
        self.init_ui
      end
    
      def init_ui
        self.setSize(800,600)
        #self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
        
        words = @@st.get_words
        columns = ["Rank", "Word", "Meaning", "Score", "Raw Score", "Asked", "Right", "Wrong", "Part", "Part at Wrong", "Sel Wrong"]
        sorted = words.to_a.sort {|a,b| b[1][:score] <=> a[1][:score] }
        data = []
        sorted.each_with_index do |w,i|
          word = @word_database.retrieve(Model::Word, :key => w[0])
          word_text = meaning = nil
          if word != nil
            word_text = word.word
            meaning = word.meaning
          else
            word_text = w[0]
          end
          data << [i+1, word_text, meaning, ((w[1][:score]*10000).round)/100.0, ((w[1][:raw_score]*1000).round)/1000.0, w[1][:asked], 
                   w[1][:right], w[1][:wrong], w[1][:participated], w[1][:part_at_wrong], w[1][:wrong_answered] ]
        end
        tm = javax.swing.table.DefaultTableModel.new

        columns.each do |c|
          tm.add_column(c)
        end
        
        data.each do |r|
          tm.add_row(r.to_java)
        end

        table = JTable.new(tm)
        
        self.getContentPane.add(javax.swing.JScrollPane.new(table));
        self.setVisible(true);
      end
    end  
  end
end
