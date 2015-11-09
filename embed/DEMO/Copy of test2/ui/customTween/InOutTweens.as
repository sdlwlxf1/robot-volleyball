package test2.ui.customTween 
{
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author ...
	 */
	public class InOutTweens 
	{
		
		public var inTween:CustomTween;
		public var inOnComplete:Function;
		
		public var outTween:CustomTween;
		public var outOnComplete:Function;

		
		private var _InTweenClass:Class;		
		private var _OutTweenClass:Class;		
		private var _displayObject:DisplayObject;

		
		public function InOutTweens(displayObject:DisplayObject, InTweenClass:Class = null, OutTweenClass:Class = null) 
		{
			_displayObject = displayObject;
			_InTweenClass = InTweenClass;
			_OutTweenClass = OutTweenClass;
		}
		
		public function startOut():void 
		{
			if (_OutTweenClass != null)
			{
				outTween = new _OutTweenClass(_displayObject);
				if (outOnComplete != null)
				{
					outTween.onComplete = outOnComplete;
				}
			}
			else
			{
				outOnComplete();
			}
		}

		public function startIn():void 
		{
			if (_InTweenClass != null)
			{
				inTween = new _InTweenClass(_displayObject);
				if (inOnComplete != null)
				{
					inTween.onComplete = inOnComplete;
				}
			}
			else
			{
				inOnComplete();
			}
		}
		
	}

}