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

#require 'green_shoes'

require 'view/pretty_button'

module Quizzer
  module View
    
    class Main < Shoes
      DEFAULTS = {:dict_dbfile => "~/.pangea/quizzer/data/dictionary.pstore"}
      
      url '/', :index
      
      def init
        dbfile = File.expand_path(DEFAULTS[:dict_dbfile])
        if !File.exists?(File.dirname(dbfile))
          #puts "Creating folder #{dbfile}"
          FileUtils.mkdir_p(File.dirname(dbfile))
        end
        @@db = Model::Dictionary.new(dbfile)
        @@qm = Controller::QuestionsManager.new(@@db)
      end

      
      def index
        init
        
        background black
        @title_stack = stack :margin => 20
        @question_stack = stack :margin => 20
         
        @debug_stack = stack :margin =>20 
         
        flow do
          @inscription = inscription "Database has #{@@db.size} definitions", :stroke => white
        end

        show_question @@qm.get_question #DictionaryQuestion.new(@dict)
      end

      def show_question(question)
        bg_color = rgb(rand * 0.5 + 0.25, rand * 0.5 + 0.25, rand * 0.5 + 0.25)
        button_color = rgb(rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7, 0.5)
    
        @title_stack.clear { background bg_color, :curve => 20; caption question.title, :align => 'center' }
        
        @pbs = []  
          
        @question_stack.clear do
          background bg_color, :curve => 20
    
          question.answers.each_with_index do | item, id |
            @pbs[id] = pretty_button(item, button_color) do 
              #alert("#{question.correct?(id)}")
              #debug id
              #debug question.correct?(id)
              if question.correct?(id)
                @pbs[id].changeHighlight(green)
                show_question(@@qm.get_question)
              else
                @pbs[id].changeHighlight(red)
              end
            end
          end
        end
      end
#      
    end
    
#    class Quizzer < Shoes
#      url '/', :index
##      url '/settings', :settings
##      url '/nothing', :nothing
#      
##      @@qm = QuestionsManager.new
#      
#      def index
#        background black #mediumspringgreen..hotpink, angle: 90
##        button("Click me!"){alert("Good job.")}
##        puts Settings.instance.initialized?
##        if !Settings.instance.initialized?
##          puts "Before visit"
##          visit "/settings"
##          puts "After visit"
##          return
##        end
##
##        puts  "Hello world"
##        puts "Dictionary has #{View.get_controller(:dictionary).size} elements"
##        background black
##        puts  "2"
##        @title_stack = stack :margin => 20
##        puts  "3"
##        @question_stack = stack :margin => 20
##        puts  "4"
#         
##        @debug_stack = stack :margin =>20 
##        puts  "5"
#         
#        flow do
#          @inscription = inscription "Dictionary has #{View.get_controller(:dictionary).size} definitions" ,:stroke => white
#         # prepend { @add_button = button "+" do
#         #   add_entry(@db, @inscription)
#         # end }
#        end
##        puts  "6"
#         
#        #while(true) do
#          show_question View.get_controller(:manager).get_question
#        #end
#      end
#      
#      def settings
##        puts "Entering setting"
##        stack :width => 1.0 do 
##          caption "Quizz Settings"
##          inscription "Quizz requires a folder where the study words database and other Quizz data will be saved. Please select a folder for Quizz data."
##          flow do
##            para "Data folder:"
##            @el = edit_line :width => 0.7
##            if Settings.instance.initialized?
##              @el.text = Settings.instance.dataPath
##            else
##              @el.text = File.expand_path("~/Quizz") 
##            end
##            button "..." do
##              folder = ask_save_folder()
##              @el.text = folder + "/Quizz" if folder != nil
##            end
##          end
##          flow do
##            button "Ok" do 
##              Settings.instance.setDataPath(@el.text)
##              visit '/'
##            end
##            if Settings.instance.initialized?
##              para link("Cancel", :click => "/" )
##            else
##              #para link("Quit", :click => Proc.new { quit } )
##              para link("Quit") { quit  }
##            end
##          end
##        end
#      end
#      
#      def nothing
#        #width = 10
#        #self.title = "Abacaxi"
##        hidden = true
##        right = 0
##        left = 0
##        button "back" do
##          visit "/"
##        end
#      end
#      def show_question(question)
#        puts question.to_s
#        bg_color = rgb(rand * 0.5 + 0.25, rand * 0.5 + 0.25, rand * 0.5 + 0.25)
#        button_color = rgb(rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7, 0.5)
#    
#        @title_stack.clear { background bg_color, :curve => 20; caption question.title, :align => 'center' }
#        
#        @pbs = []  
#          
#        @question_stack.clear do
#          background bg_color, :curve => 20
#    
#          question.answers.each_with_index do | item, id |
#            @pbs[id] = pretty_button(item, button_color) do 
#              #alert("#{question.correct?(id)}")
#              #debug id
#              #debug question.correct?(id)
#              if question.correct?(id)
#                @pbs[id].changeHighlight(green)
#                show_question(View.get_controller(:manager).get_question)
#              else
#                @pbs[id].changeHighlight(red)
#              end
#            end
#          end
#        end
#      end
#    end
  end
end

Shoes.app :width => 600, :title => 'Language Quizzer' #, :hidden => true

