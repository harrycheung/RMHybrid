class MyLabel
  attr_accessor :activity, :label
  
  def self.build(activity)
    margin = 20
    l = MyLabel.new
    l.activity = activity
    l.label = UILabel.new
    l.label.font = UIFont.systemFontOfSize(30)
    l.label.text = 'Tap to start'
    l.label.textAlignment = UITextAlignmentCenter
    l.label.textColor = UIColor.whiteColor
    l.label.backgroundColor = UIColor.clearColor
    l.label.frame = [[margin, 200], [activity.view.frame.size.width - margin * 2, 40]]
    l
  end
  
  def setText(text)
    @label.text = text
  end
end

class MyButton
  attr_accessor :activity, :button, :timing
  
  def self.build(activity)
    margin = 20
    b = MyButton.new
    b.timing = false
    b.activity = activity
    b.button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    b.button.setTitle('Start', forState:UIControlStateNormal)
    b.button.addTarget(b, action:'onClick', forControlEvents:UIControlEventTouchUpInside)
    b.button.frame = [[margin, 260], [activity.view.frame.size.width - margin * 2, 40]]
    b
  end
  
  def onClick
    if @timing
      @activity.stopTimer
      @timing = false
      @button.setTitle("Start", forState:UIControlStateNormal)
    else
      @activity.startTimer
      @timing = true
      @button.setTitle("Stop", forState:UIControlStateNormal)
    end
  end
end

class TimerTask
  attr_accessor :activity, :block
  
  def initialize(activity, &block)
    @activity = activity
    @block = block
    @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'run', userInfo:nil, repeats:true)
  end

  def run
    # This method will be called from another thread, and UI work must
    # happen in the main thread, so we dispatch it via a Handler object.
    @block.call
  end
  
  def stop
    @timer.invalidate
  end
end

class MainActivity < UIViewController
  attr_reader :timer

  def viewDidLoad
    doLoad    
  end
  
  def addItem(item)
    view.addSubview(item)
  end
end
