package constants 
{
	import flash.display.InteractiveObject;
	import starling.display.Stage;
	import starling.core.Starling;
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class StageConst 
	{
		
		public static var stage:Object;
		
		public static var stageFlash:Object;
		
		public static var stageStarling:Object;
		
		public static var stageStarlingWidth:int;
		
		public static var stageStarlingHeight:int;
		
		public static var stageFlashWidth:int;
		
		public static var stageFlashHeight:int;
		
		public static var stageWidth:int;
		
		public static var stageHeight:int;
		
		public function StageConst() 
		{
			
		}
		
		public static function setFlashStage(stage:Object):void
		{
			stageFlash = stage;
			stageFlashWidth = stageFlash.stageWidth;
			stageFlashHeight = stageFlash.stageHeight;
		}
		
		public static function setStarlingStage(stage:Object):void
		{
			stageStarling = stage;
			stageStarlingWidth = stageStarling.stageWidth;
			stageStarlingHeight = stageStarling.stageHeight;
		}
		
		public static function setCoreStage(coreStage:Object):void
		{
			stage = coreStage;
			stageHeight = stage.stageHeight;
			stageWidth = stage.stageWidth;
		}
		
	}

}