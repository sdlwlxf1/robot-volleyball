package ui.customTween 
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InScale extends CustomTween 
	{
		
		public function InScale(displayObject:DisplayObject) 
		{
			super(displayObject);
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_tweenTime = 0.5;
			_displayObject.scaleX = 0.1;
			_displayObject.scaleY = 0.1;
			var tween:Tween = new Tween(_displayObject, _tweenTime);
			//tween.moveTo(_displayObject.parent.x, _displayObject.parent.y);
			tween.scaleTo(1);
			tween.transition = Transitions.EASE_OUT_BACK;
			Starling.juggler.add(tween);
			tween.onComplete = tweenOnComplete;	
		}
		
		private function tweenOnComplete():void 
		{
			onComplete();
		}
		
	}

}