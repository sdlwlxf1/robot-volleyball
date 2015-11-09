package logics.gameLogic 
{
	import citrus.core.CitrusEngine;
	import factory.BallFactory;
	import starling.core.Starling;
	import data.ArmatureData;
	import data.ArmData;
	import data.LevelData;
	import data.MapData;
	import data.CannonData;
	import data.RewardData;
	import data.ShoulderMotorData;
	import data.UserData;
	import data.WaistMotorData;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class TrainLevelController 
	{
		
		private static var _instance:TrainLevelController;
		private var _ce:CitrusEngine;
		
		private var _userData:UserData;
		
		public var curLevelID:int = 0;
		
		public var endLevelID:int = 8;
		
		public var levelDatas:Vector.<LevelData>;
		
		public function TrainLevelController() 
		{
			_ce = CitrusEngine.getInstance();
			_userData = UserData.getInstance();
			levelDatas = new Vector.<LevelData>(100);
		}
		
		public function getCurLevelData():LevelData
		{
			return getLevel(curLevelID);
		}
		
		public function getLevel(levelID:int):LevelData
		{
			if (levelDatas[levelID] == null)
			{
				initLevel(levelID);
			}
			return levelDatas[levelID];
		}
		
		public function goToNextLevel():void
		{
			curLevelID++;
		}
		
		public function goToLevel(index:int):void
		{
			curLevelID = index;
		}
		
		private function initLevel(levelID:int):void 
		{
			
			var levelData:LevelData;
			var cannonData:CannonData;
			var mapData:MapData;
			var rewardData:RewardData;
			var ballType:uint;
			
			levelData = new LevelData();
			levelData.levelID = levelID;
			
			//cannonData
			cannonData = new CannonData();
			
			cannonData.control = "auto";
			cannonData.invertedViewAndBody = false;	
			cannonData.inputName = { "down":"p1down", "right":"p1right", "left":"p1left", "jump":"p1jump", "specialHitBall":"p1specialHitBall", "generalHitBall":"p1generalHitBall"};
			cannonData.armatureData = new ArmatureData(1);
			cannonData.startX = Starling.current.stage.stageWidth - cannonData.startX;
			cannonData.fireRate = 2000;

			levelData.cannonData = cannonData;
			
			//mapData
			mapData = _userData.unLockMaps[0] as MapData;
			levelData.mapData = mapData;
			
			//rewardData
			rewardData = new RewardData();	
			levelData.rewardData = rewardData;
			
			switch(levelID)
			{
				//level--1
				
				case 0:					
					//cannonData
					cannonData.name = "ruozhe";
					cannonData.fireRate = 2000;
					
					//mapData
					mapData = _userData.maps[0] as MapData;
					levelData.mapData = mapData;
					
					mapData.ballType = BallFactory.BALL_COLOR;
					
					//rewardData
					//rewardData.unlockArmatrueData = _userData.arms[1] as ArmatureData;
					rewardData.money = 20;
					rewardData.experience = 100;
					//rewardData.unlockMapData = _userData.maps[1] as MapData;
					break;
				
				case 1:					
					//cannonData
					cannonData.name = "ruozhe";
					cannonData.fireRate = 1500;
					
					//mapData
					mapData = _userData.maps[1] as MapData;
					levelData.mapData = mapData;
					
					mapData.ballType = BallFactory.BALL_WHITE;
					
					//rewardData
					//rewardData.unlockArmatrueData = _userData.arms[0] as ArmatureData;
					rewardData.money = 30;
					rewardData.experience = 100;
					//rewardData.unlockMapData = _userData.maps[1] as MapData;
					break;
					
				case 2:					
					//cannonData
					cannonData.name = "ruozhe";
					cannonData.fireRate = 1000;
					
					//mapData
					mapData = _userData.maps[2] as MapData;
					levelData.mapData = mapData;
					
					
					mapData.ballType = BallFactory.BALL_COLOR;
					//rewardData
					//rewardData.unlockArmatrueData = _userData.shoulderMotors[1] as ArmatureData;
					rewardData.money = 40;
					rewardData.experience = 100;
					rewardData.unlockMapData = _userData.maps[1] as MapData;
					break;
					
				case 3:					
					//cannonData
					cannonData.name = "ruozhe";
					cannonData.fireRate = 1000;
					
					//mapData
					mapData = _userData.maps[3] as MapData;
					levelData.mapData = mapData;
					
					
					mapData.ballType = BallFactory.BALL_WHITE;
					//rewardData
					//rewardData.unlockArmatrueData = _userData.waistMotors[1] as ArmatureData;
					rewardData.money = 50;
					rewardData.experience = 100;
					//rewardData.unlockMapData = _userData.maps[1] as MapData;
					break;
					
				/*case 4:
					
					//cannonData
					cannonData.name = "ruozhe";
					
					//mapData
					mapData = _userData.maps[2] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					//rewardData.unlockArmatrueData = _userData.shoulderMotors[1] as ArmatureData;
					rewardData.money = 60;
					rewardData.experience = 100;
					//rewardData.unlockMapData
					rewardData.unlockMapData = _userData.maps[2] as MapData;
					
					break;
					
				case 5:
					
					//cannonData
					cannonData.name = "ruozhe";
					
					//mapData
					mapData = _userData.maps[2] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					//rewardData.unlockArmatrueData = _userData.waistMotors[1] as ArmatureData;
					rewardData.money = 70;
					rewardData.experience = 100;
					//rewardData.unlockMapData
					//rewardData.unlockMapData = _userData.maps[1] as MapData;
					
					break;
					
				case 6:
					
					//cannonData
					cannonData.name = "ruozhe";
					
					//mapData
					mapData = _userData.maps[3] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					//rewardData.unlockArmatrueData = _userData.waistMotors[2] as ArmatureData;
					rewardData.money = 80;
					rewardData.experience = 100;
					//rewardData.unlockMapData
					rewardData.unlockMapData = _userData.maps[3] as MapData;
					
					break;
					
				case 7:
					
					//cannonData
					cannonData.name = "ruozhe";
					
					//mapData
					mapData = _userData.maps[3] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					rewardData.unlockArmatrueData = _userData.shoulderMotors[2] as ArmatureData;
					rewardData.money = 90;
					rewardData.experience = 100;
					//rewardData.unlockMapData
					//rewardData.unlockMapData = _userData.maps[3] as MapData;
					
					break;
					
				case 8:
					
					//cannonData
					cannonData.name = "ruozhe";
					
					//mapData
					mapData = _userData.maps[3] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					//rewardData.unlockArmatrueData = _userData.waistMotors[3] as ArmatureData;
					rewardData.money = 100;
					rewardData.experience = 100;
					//rewardData.unlockMapData
					//rewardData.unlockMapData = _userData.maps[3] as MapData;
					
					break;*/
			}
			
			levelDatas[levelID] = levelData;
		
			
		}
		
		public static function getInstance():TrainLevelController {
			
			if (!_instance)
				_instance = new TrainLevelController();
				
			return _instance;
		}
		
		
		
	}

}