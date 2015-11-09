package test2.ui.customTween 
{
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InFade extends CustomTween 
	{
		private var _fadeTime:Number = 0.1;
		
		public function InFade(displayObject:DisplayObject) 
		{
			super(displayObject);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_displayObject.alpha = 0;
			var tween:Tween = new Tween(_displayObject, _fadeTime);
			tween.fadeTo(1);
			Starling.juggler.add(tween);
			//if(tweenOnComplete != null)
			tween.onComplete = tweenOnComplete;	
		}
		
		
		private function tweenOnComplete():void 
		{
			onComplete();
		}
	}

}