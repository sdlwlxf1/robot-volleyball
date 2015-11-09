package ui 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.Fonts;
	import customObjects.Font;
	
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class TimeCountBoard extends Sprite 
	{
		public var timeRate:Number = 1000 / 60;
		private var _timerCountText:TextField;
		private var _timerCountTimer:Timer;
		
		private var _secondCount:Number;
		private var _microsecondCount:Number;
		
		private var _maxSecondCount:Number;
		private var _maxMicrosecondCount:Number;
		
		
		private var _secondCountString:String;
		private var _microsecondCountString:String;
		private var _fontMessage:Font;
		
		public var  onComplete:Signal;
		
		public function TimeCountBoard() 
		{
			super();
			
			onComplete = new Signal();
			
			_fontMessage = Fonts.getFont("harlowSolidItalic");
			
			_timerCountText = new TextField(100, 60, "0:00", _fontMessage.fontName, _fontMessage.fontSize, _fontMessage.fontColor);			
			_timerCountText.pivotX = _timerCountText.width >> 1;
			_timerCountText.pivotY = _timerCountText.height >> 1;
			_timerCountText.hAlign = HAlign.CENTER;
			_timerCountText.vAlign = VAlign.CENTER;					
			addChild(_timerCountText);
			
			_timerCountTimer = new Timer(timeRate);
			_timerCountTimer.addEventListener(TimerEvent.TIMER, timerCountEventListener);
		}
		
		private function timerCountEventListener(e:Event):void 
		{
			_microsecondCount--;
			if (_microsecondCount < 0)
			{
				_microsecondCount = 60;
				
				_secondCount--;
				
				if (_secondCount < 0)
				{
					_timerCountTimer.stop();
					onComplete.dispatch();
					
					_secondCount = 0;
					_microsecondCount = 0;
				}
			}
			
			setTimerText(_secondCount, _microsecondCount);
			
		}
		
		public function setTimerCount(maxTimer:Number):void
		{
			
			_timerCountTimer.stop();
			
			_maxSecondCount = int(maxTimer / 1000);
			_maxMicrosecondCount = int(maxTimer % 1000 / 60);
			
			_secondCount = _maxSecondCount;
			_microsecondCount = _maxMicrosecondCount;
			
			setTimerText(_maxSecondCount, _maxMicrosecondCount);
		}
		
		public function timerStart():void
		{
			_timerCountTimer.start();			
		}
		
		private function setTimerText(secondCount:Number, microsecondCount:Number):void
		{
			_secondCountString = String(secondCount);
			_microsecondCountString = String(microsecondCount);
			if (microsecondCount < 10)
			{
				_microsecondCountString = "0" + String(microsecondCount);
			}
			
			_timerCountText.text = _secondCountString + ":" + _microsecondCountString;
		}
		
		
	}

}