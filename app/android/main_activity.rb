class TimerTask < Java::Util::TimerTask
  attr_accessor :activity, :block
  
  def initialize(activity, &block)
    @activity = activity
    @block = block
    @timer = Java::Util::Timer.new
    @timer.schedule self , 0, 100
  end

  def run
    # This method will be called from another thread, and UI work must
    # happen in the main thread, so we dispatch it via a Handler object.
    @activity.handler.post @block
  end
  
  def stop
    @timer.cancel
  end
end

class MainActivity < Android::App::Activity
  attr_reader :handler
  
  def onCreate(savedInstanceState)
    super
    @handler = Android::Os::Handler.new
    
    doLoad
  end
  
  def addItem(item)
    @layout ||= begin
      layout = Android::Widget::LinearLayout.new(self)
      layout.orientation = Android::Widget::LinearLayout::VERTICAL
      self.contentView = layout
      layout
    end
    @layout.addView item
  end
end

class MyLabel
  attr_accessor :activity, :label
  
  def self.build(activity)
    l = MyLabel.new
    l.activity = activity
    l.label = Android::Widget::TextView.new(activity)
    l.label.text = 'Tap to callback'
    l.label.textSize = 80.0
    l.label.gravity = Android::View::Gravity::CENTER_HORIZONTAL
    l
  end
  
  def setText(text)
    @label.text = text
  end
end

class MyButton
  attr_accessor :activity, :button, :timing
  
  def self.build(activity)
    b = MyButton.new
    b.timing = false
    b.activity = activity
    b.button = Android::Widget::Button.new(activity)
    b.button.text = 'Start'
    b.button.onClickListener = b
    b
  end
  
  def onClick(view)
    if @timing
      @activity.stopTimer
      @timing = false
      @button.text = "Start"
    else
      @activity.startTimer
      @timing = true
      @button.text = "Stop"
    end
  end
end
