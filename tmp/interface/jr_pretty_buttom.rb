include Java
import javax.swing.JFrame
import javax.swing.JLabel
import javax.swing.JPanel
import java.awt.GridLayout
import java.awt.Color
#    import java.awt.BorderLayout
#mport javax.swing.JTable

class HoverActionLabel < JLabel
  include java.awt.event.MouseListener
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
  
  def mouseEntered
    puts "Entered"
  end
  def mouseExited
    puts "Exited"
  end
  def mousePressed
    puts "FIRE"
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
      round_panel = JPanel.new(GridLayout.new(1,0))
      round_panel.setBorder(javax.swing.border.EmptyBorder.new(5,5,5,5))
      lb = HoverActionLabel.new(Color.new(1.0,lid/10.0,lid/10.0), Color.new(lid/10.0,1.0, lid/10.0),"I am the option #{lid}")
      lb.setHorizontalAlignment(JLabel::CENTER)
      #  setVerticalTextPosition(JLabel::TOP)#CENTER);
      #lb.setHorizontalTextPosition(javax.swing.SwingConstants::RIGHT) #JLabel::CENTER);
      #lb.setBorder(javax.swing.border.EmptyBorder.new(10,10,10,10))
      round_panel.add(lb)
      in_panel.add(round_panel)
    end
    
    self.getContentPane.add(in_panel);
    self.setVisible(true);
  end
end

HTest.new
