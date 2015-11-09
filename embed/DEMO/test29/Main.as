package test29
{
	
	import citrus.core.starling.StarlingCitrusEngine;
	import starling.events.Event;
	
	[SWF(frameRate="60",backgroundColor="#cccccc")]
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine
	{
		
		public function Main()
		{
			
			setUpStarling(true);
			
			sound.addSound("Hurt", "sounds/hurt.mp3");
			sound.addSound("Kill", "sounds/kill.mp3");
			
			state = new StarlingDemoGameState();
		}
/*		
		override protected function _context3DCreated(evt:Event):void
		{
			super._context3DCreated(evt);
			_starling.stage.addChild(new Screen());
		}*/
	}
}