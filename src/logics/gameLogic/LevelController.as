package logics.gameLogic 
{
	import citrus.core.CitrusEngine;
	import starling.core.Starling;
	import data.ArmatureData;
	import data.ArmData;
	import data.LevelData;
	import data.MapData;
	import data.PlayerData;
	import data.RewardData;
	import data.ShoulderMotorData;
	import data.UserData;
	import data.WaistMotorData;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class LevelController 
	{
		
		private static var _instance:LevelController;
		private var _ce:CitrusEngine;
		
		private var _userData:UserData;
		
		public var curLevelID:int = 0;
		
		public var endLevelID:int = 8;
		
		public var levelDatas:Vector.<LevelData>;
		
		public function LevelController() 
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
			var opponentData:PlayerData;
			var mapData:MapData;
			var rewardData:RewardData;
			
			levelData = new LevelData();
			levelData.levelID = levelID;
			
			//opponentData
			opponentData = new PlayerData();
			opponentData.control = "auto";
			opponentData.inputName = { "down":"p1down", "right":"p1right", "left":"p1left", "jump":"p1jump", "hit":"p1hit" };
			opponentData.invertedViewAndBody = false;
			opponentData.startX = Starling.current.stage.stageWidth - opponentData.startX;
			opponentData.armatureData = new ArmatureData(0);
			levelData.opponentData = opponentData;
			
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
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[0] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[0] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[0] as WaistMotorData);
					opponentData.canAutoJump = true;
					opponentData.canAutoAccelate = true;
					
					//mapData
					mapData = _userData.maps[0] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					//rewardData.unlockArmatrueData = _userData.arms[1] as ArmatureData;
					rewardData.money = 20;
					rewardData.experience = 100;
					//rewardData.unlockMapData = _userData.maps[1] as MapData;
					break;
				
				case 1:					
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[0] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[0] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[0] as WaistMotorData);
					opponentData.canAutoJump = false;
					opponentData.canAutoAccelate = true;
					
					//mapData
					mapData = _userData.maps[0] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					rewardData.unlockArmatrueData = _userData.arms[0] as ArmatureData;
					rewardData.money = 30;
					rewardData.experience = 100;
					//rewardData.unlockMapData = _userData.maps[1] as MapData;
					break;
					
				case 2:					
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[0] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[1] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[0] as WaistMotorData);
					opponentData.canAutoJump = true;
					opponentData.canAutoAccelate = false;
					
					//mapData
					mapData = _userData.maps[1] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					rewardData.unlockArmatrueData = _userData.shoulderMotors[1] as ArmatureData;
					rewardData.money = 40;
					rewardData.experience = 100;
					rewardData.unlockMapData = _userData.maps[1] as MapData;
					break;
					
				case 3:					
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[0] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[0] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[1] as WaistMotorData);
					opponentData.canAutoJump = true;
					opponentData.canAutoAccelate = false;
					
					//mapData
					mapData = _userData.maps[1] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					rewardData.unlockArmatrueData = _userData.waistMotors[1] as ArmatureData;
					rewardData.money = 50;
					rewardData.experience = 100;
					//rewardData.unlockMapData = _userData.maps[1] as MapData;
					break;
					
				case 4:
					
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[1] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[1] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[0] as WaistMotorData);
					opponentData.canAutoJump = true;
					
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
					
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[1] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[1] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[1] as WaistMotorData);
					opponentData.canAutoJump = true;
					
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
					
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[0] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[1] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[2] as WaistMotorData);
					opponentData.canAutoJump = true;
					
					//mapData
					mapData = _userData.maps[3] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					rewardData.unlockArmatrueData = _userData.waistMotors[2] as ArmatureData;
					rewardData.money = 80;
					rewardData.experience = 100;
					//rewardData.unlockMapData
					rewardData.unlockMapData = _userData.maps[3] as MapData;
					
					break;
					
				case 7:
					
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[1] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[2] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[1] as WaistMotorData);
					opponentData.canAutoJump = true;
					
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
					
					//opponentData
					opponentData.name = "ruozhe";
					opponentData.setArm(_userData.arms[1] as ArmData);
					opponentData.setShoulderMotor(_userData.shoulderMotors[2] as ShoulderMotorData);
					opponentData.setWaistMotor(_userData.waistMotors[2] as WaistMotorData);
					opponentData.canAutoJump = true;
					
					//mapData
					mapData = _userData.maps[3] as MapData;
					levelData.mapData = mapData;
					
					//rewardData
					//rewardData.unlockArmatrueData = _userData.waistMotors[3] as ArmatureData;
					rewardData.money = 100;
					rewardData.experience = 100;
					//rewardData.unlockMapData
					//rewardData.unlockMapData = _userData.maps[3] as MapData;
					
					break;
			}
			
			levelDatas[levelID] = levelData;
		
			
		}
		
		public static function getInstance():LevelController {
			
			if (!_instance)
				_instance = new LevelController();
				
			return _instance;
		}
		
		
		
	}

}