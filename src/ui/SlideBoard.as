package ui 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import assets.Assets;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SlideBoard extends Sprite 
	{
		private var _background:Image;
		private var _slideBlock:Image;
		private var _buttons:Sprite;
		
		public var _offSetButtons:Number = 3;
		
		
		public function SlideBoard() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			_background = new Image(Assets.getTexture("slideBackground"));
			_background.pivotY = _background.height >> 1;
			addChild(_background);
			
			_slideBlock = new Image(Assets.getTexture("slideBlock"));
			_slideBlock.pivotX = _slideBlock.width >> 1;
			_slideBlock.pivotY = _slideBlock.height >> 1;
			addChild(_slideBlock);
			
			_buttons = new Sprite();
			_buttons.x = _offSetButtons;
			addChild(_buttons);
		}
		
		public function addLabel(button:SimpleButton):void
		{
			_buttons.addChild(button);
			_buttons.pivotY = _buttons.height >> 1;
			resetPosition();
		}
		
		public function changeLable(button:SimpleButton):void
		{
			_slideBlock.x = (button.width >> 1) + button.x + _offSetButtons;
			_slideBlock.width = button.width;
		}
		
		private function resetPosition():void 
		{
			var i:int = 0;
			for (i = 0; i < _buttons.numChildren; i++ )
			{
				if (i != 0)
				{
					_buttons.getChildAt(i).x = _buttons.getChildAt(i - 1).x + _buttons.getChildAt(i - 1).width + 50;
				}
			}
			_background.width = _buttons.width + _offSetButtons * 2;
		}
		
	}

}