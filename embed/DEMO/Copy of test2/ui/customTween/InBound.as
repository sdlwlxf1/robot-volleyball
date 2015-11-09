package test2.ui.customTween 
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InBound extends CustomTween 
	{
		
		protected var originalX:int;
		
		protected var originalY:int;
		
		public function InBound(displayObject:DisplayObject) 
		{
			super(displayObject);
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_tweenTime = 0.8;
			
			originalX = _displayObject.x;			
			originalY = _displayObject.y;
			
			_displayObject.y = -_displayObject.parent.height;
			var tween:Tween = new Tween(_displayObject, _tweenTime);
			tween.moveTo(originalX, originalY);
			tween.transition = Transitions.EASE_IN_OUT_BACK;
			Starling.juggler.add(tween);
			tween.onComplete = tweenOnComplete;	
		}
		
		private function tweenOnComplete():void 
		{
			onComplete();
		}
		
	}

}