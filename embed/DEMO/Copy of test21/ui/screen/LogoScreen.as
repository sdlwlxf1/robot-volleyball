package test2.ui.screen 
{
	import flash.utils.setTimeout;
	import starling.display.Quad;
	import test2.assets.ArmatureFactory;
	import test2.constants.ScreenConst;
	import test2.data.UserData;
	/**
	 * ...
	 * @author ...
	 */
	public class LogoScreen extends Screen 
	{
		
		public function LogoScreen() 
		{
			super();
			ArmatureFactory.getStarlingFactory("Robot");
			UserData.getInstance().loadData();
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
			var quad:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			addChild(quad);
			

			
			setTimeout(logoOver, 0);
		}
		
		private function logoOver():void 
		{
			screenController.dispatchSignal(ScreenConst.LOGO_SCREEN, ScreenConst.SCREEN_OUT, this);
		}
		
	}

}