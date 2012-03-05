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
require 'view_jruby/pretty_button'
require 'view_jruby/border_highlight_button'

module Quizzer
  module View
    import javax.swing.JFrame
    import javax.swing.JPanel
    import java.awt.GridLayout
    import java.awt.BorderLayout
    import javax.swing.JLabel
    import java.awt.TrayIcon
    import java.awt.Toolkit
    import java.awt.Color
  
    class QuizzerMain < JFrame
      
      def initialize
        super("Quizzer")
        @@qm = Quizzer::View.get_controller(:manager)
        @@st = Quizzer::View.get_controller(:statistics)
        @cm = Quizzer::View.get_controller(:configuration)
        self.add_system_tray
        self.init_ui
      end
    
      def init_ui
        self.setSize(450,300)
        self.getContentPane.setBackground(Color::WHITE)
        self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
        
        @label = JLabel.new
        bkcolor = Color.new(rand * 0.5 + 0.25, rand * 0.5 + 0.25, rand * 0.5 + 0.25)
        
        #Other stats
        rightstats = JPanel.new(GridLayout.new(6, 0))
        label = JLabel.new("<html>Known<br>Words</html>")
        @known_words = JLabel.new
        rightstats.add(label)
        rightstats.add(@known_words)
        label = JLabel.new("<html>Avg<br>Score</html>")
        @average_score = JLabel.new
        rightstats.add(label)
        rightstats.add(@average_score)
        label = JLabel.new("<html>Total<br>Score</html>")
        @total_score = JLabel.new
        rightstats.add(label)
        rightstats.add(@total_score)
        self.getContentPane.add(rightstats, BorderLayout::EAST)
        
        
        @in_panel = JPanel.new(GridLayout.new)
        @in_panel.setBackground(Color::WHITE)
        @south_label = JLabel.new
        @bt_stat = ActionButton.new("W") do
          Statistics.new
        end
        south_panel = JPanel.new(BorderLayout.new)
        south_panel.add(@south_label, BorderLayout::CENTER);
        south_panel.add(@bt_stat, BorderLayout::LINE_END)
        self.getContentPane.add(@label, BorderLayout::NORTH);
        self.getContentPane.add(south_panel, BorderLayout::SOUTH);
        #self.getContentPane.add(@in_panel, BorderLayout::CENTER);
        self.ask(@@qm.get_question)
        self.setVisible(true)
      end
      
      def statsText
        stat = @@st.get_session
        perc = stat[:questions] == 0 ? nil : (100 * stat[:correct])/stat[:questions]
        st = "<html>Session: Correct answered #{stat[:correct]}/#{stat[:questions]} (#{perc} %) Attempt map #{stat[:error_attempt].join('/')}"
        stat = @@st.get_general
        perc = stat[:questions] == 0 ? nil : (100 * stat[:correct])/stat[:questions]
        st += "<br>General: Correct answered #{stat[:correct]}/#{stat[:questions]} (#{perc} %) Attempt map #{stat[:error_attempt].join('/')}</html>"
      end
      
      def set_stats
        stat = @@st.get_words_summary
        @known_words.setText("#{stat[:known]} / #{stat[:amount]}")
        val = ( stat[:average_score] * 10000 ).round / 100.0
        @average_score.setText("#{val}")
        val = ( stat[:total_score]*100).round
        @total_score.setText("#{val}")
        @south_label.setText(self.statsText)
      end
      
      def ask(question)
        attempt = 0
        
        self.set_stats
        #Set Question title
        @label.setText(question.title)
        #@label.setForeground(Color::WHITE)
        @label.setBorder(javax.swing.border.EmptyBorder.new(10,10,10,10))
        @label.setHorizontalAlignment(JLabel::CENTER)
        
        self.getContentPane.remove(@in_panel)
        @in_panel = JPanel.new(GridLayout.new)
        @in_panel.setBackground(Color::WHITE)
        #@in_panel.removeAll
        #sleep(4)
        @in_panel.getLayout.setRows(question.answers.size)
        @in_panel.getLayout.setColumns(1)
        
        border_color = Color.new(0.4, 0.4, 0.4, 1.0)
        text_color = Color.new(1.0, 1.0, 1.0, 1.0)
        hover_color = Color.new(0.4, 0.5, 0.4, 1.0)
        
        #r = rand * 0.3 + 0.4
        #g = rand * 0.3 + 0.4
        #b = rand * 0.3 + 0.4
        question.answers.each_with_index.each do |q, i|
          #button = ActionButton.new(q) do
          #cl = Color.new(r,g,b)
          #hv = Color.new((2+r)/3,(2+g)/3,(2+b)/3) 
          #hv = Color.new(1.0,1.0,1.0,0.5) #Color.new(i/10.0,1.0, i/10.0)
          button = BorderHighlightButton.new(border_color, hover_color, text_color, q, 4, 6) do 
          #button = PrettyButton.new(cl, hv, q, 4) do
            if question.correct?(i)
              #button.setBackground(java.awt.Color::green)
              button.setBorderColor(java.awt.Color::green)
              ask(@@qm.get_question)
              #@cm.wait_next_period(self)
              if @cm.get_period > 0
                Thread.new do 
                  self.setVisible(false)
                  @cm.wait_next_period
                  self.setVisible(true)
                end
              end
            else
              #button.setBackground(java.awt.Color::red)
              button.setBorderColor(java.awt.Color::red)
            end
            button.setEnabled(false)
          end
          button.setHorizontalAlignment(JLabel::CENTER)
          @in_panel.add button
          self.getContentPane.add(@in_panel, BorderLayout::CENTER);
        end
        
        #self.getContentPane.add(@in_panel, BorderLayout::CENTER);
        
        #period = @cm.get_period
        #if period > 0
        #  self.setVisible(false);
        #  #@cm.wait_next_period
        #  sleep(period)
        #end
        #self.setVisible(true);
        
      end
      
      TIMES = [ { :name => "Continuous quiz", :time => 0 },
              { :name => "Quiz every 5 seconds", :time => 5 },
              { :name => "Quiz every 5 minutes", :time => 300 },
              { :name => "Quiz every 10 minutes", :time => 600 },
              { :name => "Quiz every 15 minutes", :time => 900 },
      ]
      
      def add_system_tray
        @configuration = View.get_controller(:configuration)
        
        # Setup menu items
        menu_items = []

        mitem = java.awt.MenuItem.new("Quiz NOW!")
        mitem.add_action_listener { @configuration.interrupt_period }
        #TODO: Set the about window start as action listener here
        menu_items << mitem
        
        TIMES.each do |it|
          mitem = java.awt.MenuItem.new(it[:name])
          mitem.add_action_listener { @configuration.set_period(it[:time]) }
          menu_items << mitem
        end
        mitem = java.awt.MenuItem.new("About")
        #TODO: Set the about window start as action listener here
        menu_items << mitem

        mitem = java.awt.MenuItem.new("Exit")
        mitem.add_action_listener { java.lang.System::exit(0)}
        menu_items << mitem
        
        #Create popup menu
        popup = java.awt.PopupMenu.new
        # Add the items to the popup menu itself
        menu_items.each do |mi|
          popup.add(mi)
        end
        
        # Give the tray an icon and attach the popup menu to it
        path = File.expand_path(File.dirname(__FILE__))
        image_path = "#{path}/images/systray.gif"
        image = java.awt.Toolkit::default_toolkit.get_image(image_path)
        tray_icon = TrayIcon.new(image, "Quizzer!", popup)
        tray_icon.image_auto_size = true
        
        # Finally add the tray icon to the tray
        tray = java.awt.SystemTray::system_tray
        tray.add(tray_icon)
      end
    end  
  end
end
