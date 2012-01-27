require 'green_shoes'

class HoverButton < Shoes::Widget
  def initialize(properties = {} )
    @col = properties[:color] || green
    @hovercol = properties[:hover_color] 
    @label = "\n#{properties[:label]}\n" || ""
    @margin = properties[:margin] 
    @height = properties[:height] || 0
    if @margin
      stack :height => @margin do
        para ""
      end
    end
    @st = flow :height => @height do
      @bg = background @col, :left=> 20, :curve => 20
      if @hovercol
        @hg = background @hovercol, :curve => 20
        @hg.hide
      end
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
        @bg.hide
        @hg.show
      }
      @st.leave { |me| 
        @bg.show
        @hg.hide
      }
    end
  end
end

Shoes.app :width => 600, :height => 600 do
  background :black
  question_color = rgb(rand * 0.5 + 0.25, rand * 0.5 + 0.25, rand * 0.5 + 0.25)
  r,g,b = rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7 
  button_color = rgb(r, g, b, 0.5)
  hover_color = rgb(r, g, b, 0.9)
  @title_stack = stack do
    hover_button(:label => "Asking a question", :color => question_color, :margin => 5) do
      alert("Good")
    end
  end
  
   @question_stack = stack do 
     background question_color, :curve => 20 
     margin = 10
     hover_button(:label => "First answer", :color => button_color, :hover_color => hover_color, :margin => margin) do
       alert("First")
     end
     hover_button(:label => "Second answer", :color => button_color, :hover_color => hover_color, :margin => margin) do
       alert("Second")
     end
     hover_button(:label => "Third answer", :color => button_color, :hover_color => hover_color, :margin => margin) do
       alert("Third")
     end
     hover_button(:label => "Fourth answer", :color => button_color, :hover_color => hover_color, :margin => margin) do
       alert("Fourth")
     end
   end
 end
 