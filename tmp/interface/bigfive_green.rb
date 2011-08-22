#Shoes.app :width => 600 do
#  def show_question(num=nil)
#    bg_color = rgb(rand * 0.5 + 0.25, rand * 0.5 + 0.25, rand * 0.5 + 0.25)
#    button_color = rgb(rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7, 0.5)
#    @title_stack.clear { background bg_color, :curve => 20; caption @title, :align => 'center' }
#    @question_stack.clear do
#      background bg_color, :curve => 20
#
#      if num < @questions.length
#        question = @questions[num]
#        caption "#{ num + 1 }/#{@questions.length}: #{question[:question]}", :align => 'center'
#
#        @value_sets[question[:value_set]].each do | item |
#          pretty_button(item[:label], button_color) do 
#            @answers[num] = item[:value]
#            show_question(num + 1)
#          end
#        end
#      else
#        sex = @answers[0]
#        @textual_summary = ""
#        @traits.each do |trait|
#          score = 0
#          trait[:questions].each do | num |
#            score = score + @answers[num]
#          end
#          interpretation = trait[:scoring][sex][score]
#
#          @textual_summary << caption( em(trait[:name])).text << "\n\n" <<
#            para( "level: ", em(interpretation)).text  << "\n" <<
#            para( "core mechanism: ", em(trait[:core_mechanism])).text << "\n" <<
#            para( "benefits: ", em(trait[:benefits])).text << "\n" <<
#            para( "costs: ", em(trait[:costs])).text << "\n\n"
#        end
#        pretty_button( "copy results to clipboard", button_color ) do
#          alert "copied results to clipboard."
#          self.clipboard = @textual_summary
#        end
#        pretty_button( "start over", button_color ) do
#          @answers = []
#          show_question 0
#        end
#      end
#    end
#  end
#
#  @test = YAML.load(TEST_DATA)
#  @title = @test[:title]
#  @questions = @test[:questions]
#  @value_sets = @test[:value_sets]
#  @traits = @test[:traits]
#  @answers = []
#
#  background black
#
#  @title_stack = stack :margin => 20
#  
#  @question_stack = stack :margin => 20
#  show_question 0
#
#end
require 'green_shoes'

class HoverButton < Shoes::Widget
  def initialize(properties = {} )
    @col = properties[:color] || green
    @hovercol = properties[:hover_color] 
    @label = "\n#{properties[:label]}\n" || ""
    @margin = properties[:margin] 
    @height = properties[:height] || 0
    puts "creating flow labeled #{@label}"
    if @margin
      stack :height => @margin do
        para ""
      end
    end
    @st = flow :height => @height do
      background @col, :curve => 20
      para @label, :align => 'center'
    end
    if @margin
      stack :height => @margin do
        para ""
      end
    end
    @st.click { yield }
    if @hovercol
      @st.hover { |me|
        hb_paint(me, @hovercol)
        puts "Enter #{@label}"
      }
      @st.leave { |me| 
        puts me.height
        
        hb_paint(me, @col)
        #me.style(:height => me.height + 16)
        puts "Leave #{@label}"
      }
    end
  end
  
  def hb_paint(obj, col)
    puts obj.style.inspect
    obj.clear do 
      background col, :curve => 20
      para @label, :align => 'center'
    end
  end
end

Shoes.app :width => 600, :height => 600 do
  question_color = rgb(rand * 0.5 + 0.25, rand * 0.5 + 0.25, rand * 0.5 + 0.25)
  button_color = rgb(rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7)#, 0.5)
  hover_color = rgb(0.5,0.5,0.5)#,0.5)
  background :black
  @title_stack = stack do
    hover_button(:label => "Asking a question", :color => question_color, :margin => 5) do
      alert("Good")
    end
  end
  
   @question_stack = stack do 
     hover_button(:label => "First answer", :color => button_color, :hover_color => hover_color, :margin => 5) do
       alert("First")
     end
     hover_button(:label => "Second answer", :color => button_color, :hover_color => hover_color, :margin => 5) do
       alert("Second")
     end
     hover_button(:label => "Third answer", :color => button_color, :hover_color => hover_color, :margin => 5) do
       alert("Third")
     end
     hover_button(:label => "Fourth answer", :color => button_color, :hover_color => hover_color, :margin => 5) do
       alert("Fourth")
     end
   end
 end
 