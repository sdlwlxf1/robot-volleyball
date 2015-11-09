package ui.screen 
{
	import citrus.core.CitrusEngine;
	import flash.utils.setTimeout;
	import starling.display.Quad;
	import assets.ArmatureFactory;
	import constants.ScreenConst;
	import data.UserData;
	/**
	 * ...
	 * @author ...
	 */
	public class TrainLogoScreen extends TrainScreen 
	{
		
		public function TrainLogoScreen() 
		{
			super();
			CitrusEngine.getInstance().sound.preloadAllSounds();
			ArmatureFactory.getStarlingFactory("Robot");
			UserData.getInstance().loadData();
		}
		
		override protected function initScreens():void 
		{
			//super.initScreens();
			var quad:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			addChild(quad);
			

			
			setTimeout(logoOver, 1500);
		}
		
		private function logoOver():void 
		{
			screenController.dispatchSignal(ScreenConst.TRAIN_LOGO_SCREEN, ScreenConst.SCREEN_OUT, this);
		}
		
	}

}