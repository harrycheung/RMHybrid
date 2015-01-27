class HybridTimer < MainActivity
  def doLoad
    @label = MyLabel.build self
    addItem @label.label

    @button = MyButton.build self
    addItem @button.button
  end
  
  def startTimer
    @counter = 0
    @timer = TimerTask.new(self) { @label.setText("%.1f" % (@counter += 0.1)) }
  end
  
  def stopTimer
    @timer.stop
  end
end