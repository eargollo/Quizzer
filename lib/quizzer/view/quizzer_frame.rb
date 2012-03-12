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
  
    class QuizzerFrame < JFrame
      def initialize(*args)
        super(*args)
        set_icon
      end
      
      def set_icon
        file = self.get_image_url("quizzer.png")
        setIconImage(Toolkit.getDefaultToolkit().getImage(file))
      end
      
      def get_image_url(filename)
        path = File.expand_path(File.dirname(__FILE__))
        image_path = File.expand_path("#{path}/../images/#{filename}")
        if File.exists?(image_path)
          return image_path
        else
          file = "lib/quizzer/images/#{filename}"
          url = getClass.getClassLoader.getResource(file)
          return url
        end
      end
    end
  end
  
end
