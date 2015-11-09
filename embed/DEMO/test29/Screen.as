package test2 
{
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Screen extends Sprite 
	{
		
		private var _startButton:Button;
		
		public function Screen() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On Game class added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// Initialize screens.
			initScreens();
		}
		
		protected function initScreens():void 
		{
			_startButton = new Button(new Texture(), "sgaowigj"/*Assets.getAtlas("Game").getTexture("startButton")*/);
			_startButton.fontColor = 0xffffff;
			_startButton.x = stage.stageWidth / 2 - _startButton.width / 2;
			_startButton.y = stage.stageHeight / 2 - _startButton.height / 2;
			addChild(_startButton);
			_startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
		}
		
				
		private function onStartButtonClick(e:Event):void 
		{
			//state = 
			addChild(new StarlingDemoGameState());
		}
		
	}

}