package test2.ui.customTween 
{
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class OutFade extends CustomTween 
	{
		
		private var _fadeTime:Number = 0.3;
		
		public function OutFade(displayObject:DisplayObject) 
		{
			super(displayObject);
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_displayObject.alpha = 1;
			var tween:Tween = new Tween(_displayObject, _fadeTime);
			tween.fadeTo(0);
			Starling.juggler.add(tween);
			tween.onComplete = tweenOnComplete;	
		}
		
		private function tweenOnComplete():void 
		{
			onComplete();
		}
		
	}

}