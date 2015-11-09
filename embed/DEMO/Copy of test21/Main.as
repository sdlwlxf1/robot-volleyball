package test2
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="1000", height="600", frameRate="60", backgroundColor="#030303")]
	
	/**
	 * @author Aymeric
	 */
	public class Main extends MovieClip
	{	
		public function Main()
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			//stage.align = StageAlign.TOP;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var gameEngine:GameEngine = new GameEngine();
			addChild(gameEngine);
		}
		
	}
}