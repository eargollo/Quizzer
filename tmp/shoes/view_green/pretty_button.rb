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

class PrettyButton < Shoes::Widget
  def initialize(label, col=nil)
    col ||= rgb(rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7, 0.5)
    @label = label
    @flow = flow :margin => 20 do
      @back = background col, :curve => 20
      para label, :align => 'center'
      click { yield }
      hover { |me| me.append { @hoverbg = background rgb(1.0,1.0,1.0,0.5), :curve => 20 } }
      leave { @hoverbg.remove}
    end
  end
  
  def changeHighlight(col=nil)
    col ||= rgb(rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7, 0.5)
    
    debug @back.style 
    #debug @back.methods.join("\n")
    @back.remove
    @flow.prepend {background col, :curve => 20}
  end
end
