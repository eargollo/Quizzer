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

class DictionaryQuestion
  def initialize(dictionary, order=:both, options=4)
    @answer = rand(options)   
    @order = order
    @elements = get_words(dictionary, options)
    @listeners = []
    if @order == :both
      @order = rand(2) == 0 ? :straight : :reverse
    end
    @attempt = 0
  end
  
  def element(id=nil)
    id = @answer if id == nil
    return @elements[id]
  end
  
  def title
    return @elements[@answer][0] if @order == :straight
    return @elements[@answer][1]
  end
  
  def answers
    ans = []
    idx = @order == :straight ? 1 : 0
    @elements.each {|el| ans << el[idx]}
    return ans
  end
  
  def correct?(id)
    @attempt = @attempt + 1
    @listeners.each {|al| al.answerTrigger(self, id, @attempt, id == @answer)}
    return id == @answer
  end
  
  def correct
    return @answer
  end
  
  def show
    puts "---> #{self.title}"
    puts
    self.answers.each_with_index do |el, i|
      puts "#{i+1}) #{el}"
    end  
  end
  
  def add_listener(elm)
    @answer_listeners << elm
  end    
  
  def get_words(dict, options)
    els = []
    attempts = options * 100
    total_words = dict.size
    raise "Dictionary does not have enough words" if total_words < options
    while els.size < options
      t = dict.retrieve(:id => rand(total_words)) 
      #puts "Try word '#{t[0]}' - '#{t[1]}'"
      a = els.find {|el| el[0] == t[0] || el[1] == t[1]}
      if a==nil || a.size == 0
        #puts "Adding"
        els << t
      else
        attempts = attempts - 1 
        raise "Could not formulate single answer question. Failed #{options * 100} attempts." if attempts <= 0
        #puts "Found result '#{a[0]}' - '#{a[1]}'"
        #puts "Skipping"
      end
      #gets 
    end
    return els
  end  
end
