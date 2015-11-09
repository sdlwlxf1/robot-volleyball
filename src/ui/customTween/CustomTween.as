package ui.customTween
{
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author ...
	 */
	public class CustomTween 
	{
		
		protected var _displayObject:DisplayObject;
		
		public var onComplete:Function;
		
		protected var _tweenTime:Number;
		
		public function CustomTween(displayObject:DisplayObject) 
		{
			_displayObject = displayObject;
			onComplete = new Function();
			initialize();
		}
		
		protected function initialize():void 
		{
			
		}
		
	}

}