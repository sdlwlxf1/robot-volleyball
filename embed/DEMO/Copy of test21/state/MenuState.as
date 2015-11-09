package test2.state 
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import test2.logic.gameLogic.ScreenController;
	import test2.ui.screen.LogoScreen;
	import test2.ui.screen.Screen;
	import test2.ui.screen.StartScreen;
	
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