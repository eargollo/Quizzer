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

class HooverButton < Shoes::Widget
  def initialize(properties = {} )
    @col = properties[:color] || white
    @hovercol = properties[:hover_color] 
    @label = "\n#{properties[:label]}\n" || ""
    #In here to partially solve problems with Green shoes margins and spacing
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
