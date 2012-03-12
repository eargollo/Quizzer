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
require 'view/pretty_button'
require 'view/border_highlight_button'
require 'view/border_highlight_panel'
require 'view/quizzer_frame'

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
  
    class QuizzerMain < QuizzerFrame
      
      BORDER_COLOR = Color.new(0.7, 0.8, 0.6, 1.0)
      BORDER_HIGHLIGHT = Color.new(0.6, 0.8, 0.6, 1.0)
      TEXT_BG_COLOR = Color::WHITE
      BT_MARGIN = 2
      BT_BORDER = 4
      
      FONT_NAME = "Kristen ITC"
      
      def self.getMainWindow
        @@mainWindow
      end
      
      def initialize
        super("Quizzer")
        @@mainWindow = self
        @@qm = Quizzer::View.get_controller(:manager)
        @cm = Quizzer::View.get_controller(:configuration)
        @word_database = Quizzer::View.get_controller(:dictionary)
        self.add_system_tray
        self.init_ui
      end
    
      def init_ui
        self.setSize(550,300)
        self.getContentPane.setBackground(Color::WHITE)
        self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
        
        #Main panel: side for stats and middle for everything else
        main_panel = JPanel.new(BorderLayout.new)
        
        @question_panel = JPanel.new(BorderLayout.new)
        @stats_panel = StatisticsPanel.new
        
        main_panel.add(@stats_panel, BorderLayout::EAST)
        main_panel.add(@question_panel, BorderLayout::CENTER)
        
        font = java.awt.Font.new(FONT_NAME, java.awt.Font::PLAIN, 18)
        @ans_font = java.awt.Font.new(FONT_NAME, java.awt.Font::PLAIN, 16)
        
        #Question panel has the question north, some stats and button south and answers middle
        @question_label = JLabel.new
        @question_label.setBorder(javax.swing.border.EmptyBorder.new(10,10,10,10))
        @question_label.setHorizontalAlignment(JLabel::CENTER)
        
        @question_label.setFont(font)

        @answers_panel = JPanel.new(GridLayout.new)
        
        south_panel = JPanel.new(BorderLayout.new)
        @session_stats_text = JLabel.new

        south_panel.add(@session_stats_text, BorderLayout::CENTER);
        #south_panel.add(bt_stat, BorderLayout::LINE_END)

        @question_panel.add(@question_label, BorderLayout::NORTH)
        @question_panel.add(@answers_panel, BorderLayout::CENTER)
        @question_panel.add(south_panel, BorderLayout::SOUTH)
        
        self.getContentPane.add(main_panel)
        
        if @word_database.size(Model::Word) < 4
          @no_words = true
          self.set_stats
          self.noWordsWarning
        else
          @no_words = false
          self.ask(@@qm.get_question)  
        end
        
        self.setVisible(true)
      end
            
      def noWordsWarning
        @question_label.setText("<html>Not enough words in the dictionary to ask questions. Add/Import words in orther to start.</html>")
      end
      
      def statsText
        stat = Quizzer::Controller::StatisticsManager.get_statistics.get_session
        perc = stat[:questions] == 0 ? nil : (100 * stat[:correct])/stat[:questions]
        st = "<html>Session: Correct answered #{stat[:correct]}/#{stat[:questions]} (#{perc} %) Attempt map #{stat[:error_attempt].join('/')}"
        stat = Quizzer::Controller::StatisticsManager.get_statistics.get_general
        perc = stat[:questions] == 0 ? nil : (100 * stat[:correct])/stat[:questions]
        st += "<br>General: Correct answered #{stat[:correct]}/#{stat[:questions]} (#{perc} %) Attempt map #{stat[:error_attempt].join('/')}</html>"
      end
      
      def set_stats
        if @no_words == true
          #No words to ask, check if threshold was reached
          if @word_database.size(Model::Word) >= 4
            @no_words = false
            self.ask(@@qm.get_question)
          end
        end
        
        @stats_panel.updateStats
        @session_stats_text.setText(self.statsText)
      end
      
      def ask(question)
        attempt = 0
        
        self.set_stats
        #Set Question title
        @question_label.setText(question.title)
        #@label.setForeground(Color::WHITE)
        
        @question_panel.remove(@answers_panel)
        @answers_panel = JPanel.new(GridLayout.new)
        @answers_panel.setBackground(Color::WHITE)
        #@in_panel.removeAll
        #sleep(4)
        @answers_panel.getLayout.setRows(question.answers.size)
        @answers_panel.getLayout.setColumns(1)
        
        border_color = Color.new(0.4, 0.4, 0.4, 1.0)
        text_color = Color.new(1.0, 1.0, 1.0, 1.0)
        hover_color = Color.new(0.4, 0.5, 0.4, 1.0)
        
        question.answers.each_with_index.each do |q, i|
          button = BorderHighlightButton.new(border_color, hover_color, text_color, q, BT_MARGIN, BT_BORDER) do 
            if question.correct?(i)
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
              button.setBorderColor(java.awt.Color::red)
            end
            button.setEnabled(false)
          end
          button.setHorizontalAlignment(JLabel::CENTER)
          
          button.setFont(@ans_font)
          
          @answers_panel.add button
          @question_panel.add(@answers_panel, BorderLayout::CENTER);
        end
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
        image = java.awt.Toolkit::default_toolkit.get_image(self.get_image_url("quizzer.png"))
        tray_icon = TrayIcon.new(image, "Quizzer!", popup)
        tray_icon.image_auto_size = true
        
        # Finally add the tray icon to the tray
        tray = java.awt.SystemTray::system_tray
        tray.add(tray_icon)
      end
    end
    
    import javax.swing.ImageIcon
    import javax.swing.JButton
    import javax.swing.JMenuBar
    import javax.swing.JMenu
    import javax.swing.JToolBar
    
    class StatisticsPanel < JPanel
      STATS = 5#4
      def initialize
        super(GridLayout.new)
        self.getLayout.setRows(STATS)
        
        self.addToolBar
        
        @total_score = StatView.new("Total Score")
        @avg_score   = StatView.new("Avg Score")
        @known_words = StatView.new("Known Words") do
          AddWords.new
        end

        #bt_stat = ActionButton.new("Words Details") do
        #  Statistics.new
        #end

        #@total_score = StatView.new("Total Score", 0)
        self.add(@total_score)
        self.add(@avg_score)
        self.add(@known_words) 
        #self.add(bt_stat)
      end
      
      def addToolBar
        #menubar = JMenuBar.new
        #fileMenu = JMenu.new "File"
        #menubar.add fileMenu

        toolbar = JToolBar.new

        iconAdd = ImageIcon.new(Quizzer::View::QuizzerMain.getMainWindow.get_image_url("plus_32.png"))

        addButton = JButton.new iconAdd
        addButton.addActionListener do |e|
          AddWords.new  
        end
        
        toolbar.add addButton

        iconImport = ImageIcon.new(Quizzer::View::QuizzerMain.getMainWindow.get_image_url("upload.png"))

        importButton = JButton.new iconImport
        importButton.addActionListener do |e|
            ImportFiles.new
        end
        
        toolbar.add importButton

        iconList = ImageIcon.new(Quizzer::View::QuizzerMain.getMainWindow.get_image_url("word.png"))

        listButton = JButton.new iconList
        listButton.addActionListener do |e|
          Statistics.new  
        end

        toolbar.add listButton


        self.add toolbar #, BorderLayout::NORTH

        #self.setJMenuBar menubar
        
        #self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
        #self.setSize 350, 250
        #self.setLocationRelativeTo nil
        #self.setVisible true
      end
      
      def updateStats
        stat = Quizzer::Controller::StatisticsManager.get_statistics.get_words_summary
        @known_words.setValue("#{stat[:known]} / #{stat[:amount]}")
        
        val = ( stat[:average_score] * 10000 ).round / 100.0
        @avg_score.setValue(val)
        
        val = ( stat[:total_score]*100).round 
        @total_score.setValue(val)
      end
    end
  
    class StatView < BorderHighlightPanel
      BORDER_COLOR = Color.new(0.7, 0.8, 0.6, 1.0)
      BORDER_HIGHLIGHT = Color.new(0.6, 0.8, 0.6, 1.0)
      TEXT_BG_COLOR = Color::WHITE
      BT_MARGIN = 0
      BT_BORDER = 2

      def initialize(title = "", value = "", &blk)
        super(GridLayout.new(2,0), BORDER_COLOR, BORDER_HIGHLIGHT, BT_MARGIN, BT_BORDER, &blk)
        #self.setHorizontalAlignment(JLabel::CENTER)
        
        @title_label = JLabel.new(title.to_s)
        @title_label.setHorizontalAlignment(JLabel::CENTER)
        @value_label = JLabel.new(value.to_s)
        @value_label.setHorizontalAlignment(JLabel::CENTER)
        
        self.add(@title_label)
        self.add(@value_label)
        
      end
      
      def setValue(value)
        @value_label.setText(value.to_s)
      end
      
      def setTitle(title)
        @title_label.setText(title.to_s)
      end
      
    end

  end
  
end
