include Java
import javax.swing.JFrame
import javax.swing.JLabel
#import javax.swing.JPanel
import java.awt.GridLayout
import java.awt.Color

class HoverActionLabel < JLabel
  def initialize(color, hover, *arg, &blk)
    super(*arg)
    @action = blk
    @color = color
    @hover = hover
    self.setBackground(@color)
    self.setOpaque(true)
    self.enableEvents(java.awt.AWTEvent::MOUSE_EVENT_MASK)
  end
  
  def processMouseEvent(e)
    #puts "event #{e.getID} "
    if e.getID == java.awt.event.MouseEvent::MOUSE_ENTERED
      puts "ENTERED, hovering"
      self.setBackground(@hover)
    end
    if e.getID == java.awt.event.MouseEvent::MOUSE_EXITED
      puts "EXITED back"
      self.setBackground(@color)
    end
    if e.getID == java.awt.event.MouseEvent::MOUSE_PRESSED
      #puts "PRESSED"
      if @action != nil
        @action.call
      end
    end
  end
end


import javax.swing.JPanel
import javax.swing.border.EmptyBorder
import javax.swing.JLabel
class PrettyButton < JPanel
  def initialize(color, hover, label, border_size, &action)
    super(GridLayout.new(1,0))
    @border = EmptyBorder.new(border_size, border_size, border_size, border_size)
    self.setBorder(@border)
    @label = HoverActionLabel.new(color, hover, label, &action)
    self.add(@label)
  end
end


class HTest < JFrame
  
  def initialize
    super("Test Hoover Buttom")
    self.init_ui
  end

  def init_ui
    self.setSize(450,300)
    self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    
    in_panel = JPanel.new(GridLayout.new(5,1))
    in_panel.setBorder(javax.swing.border.EmptyBorder.new(10,10,10,10))
    (1..5).each do |lid|
      #round_panel = JPanel.new(GridLayout.new(1,0))
      #round_panel.setBorder(javax.swing.border.EmptyBorder.new(5,5,5,5))
#      lb = HoverActionLabel.new(Color.new(1.0,lid/10.0,lid/10.0), Color.new(lid/10.0,1.0, lid/10.0),"I am the option #{lid}")
#      lb.setHorizontalAlignment(JLabel::CENTER)
      #round_panel.add(lb)
#      in_panel.add(lb)
      cl = Color.new(1.0,lid/10.0,lid/10.0)
      hv = Color.new(lid/10.0,1.0, lid/10.0)
      bt = PrettyButton.new(cl,hv, "Text of bt number #{lid}", 5) do
        puts "Button #{lid} click"
      end
      in_panel.add(bt)
    end
    
    self.getContentPane.add(in_panel);
    self.setVisible(true);
  end
end

HTest.new
