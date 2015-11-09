package state 
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import logics.gameLogic.ScreenController;
	import logics.gameLogic.TrainScreenController;
	import ui.screen.LogoScreen;
	import ui.screen.Screen;
	import ui.screen.StartScreen;
	import ui.screen.TrainLogoScreen;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrainMenuState extends StarlingState 
	{	
		private var _trainScreenController:TrainScreenController;
		
		public function TrainMenuState() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_trainScreenController = TrainScreenController.getInstance();		
			
			if (TrainScreenController.firstOpenGame == true)
			{
				addChild(new TrainLogoScreen());
				TrainScreenController.firstOpenGame = false;
			}
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
		}
		
	}

}