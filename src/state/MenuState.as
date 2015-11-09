package state 
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import logics.gameLogic.ScreenController;
	import ui.screen.LogoScreen;
	import ui.screen.Screen;
	import ui.screen.StartScreen;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MenuState extends StarlingState 
	{	
		private var _screenController:ScreenController;
		
		public function MenuState() 
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_screenController = ScreenController.getInstance();		
			
			if (ScreenController.firstOpenGame == true)
			{
				addChild(new LogoScreen());
				ScreenController.firstOpenGame = false;
			}
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
		}
		
	}

}