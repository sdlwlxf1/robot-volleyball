package test2.data 
{
	import citrus.input.controllers.Keyboard;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class UserData
	{
		
		protected var _sharedObject:SharedObject;		
		private static var _instance:UserData;
		
		
		
		//用户数据
		public var name:String = "lixuefeng";		
		public var ability:Ability = new Ability(2, 2, 2, 2);		
		public var money:Number = 1000;		
		public var experience:Number = 0;		
		public var p1KeySet:Object = { "jumpKey":Keyboard.W, "leftKey":Keyboard.A, "rightKey":Keyboard.D, "hitKey":Keyboard.J };		
		public var p2KeySet:Object = { "jumpKey":Keyboard.UP, "leftKey":Keyboard.LEFT, "rightKey":Keyboard.RIGHT, "hitKey":Keyboard.M };		
		public var p1KeyReset:Object = { "jumpKey":Keyboard.W, "leftKey":Keyboard.A, "rightKey":Keyboard.D, "hitKey":Keyboard.J };		
		public var p2KeyReset:Object = { "jumpKey":Keyboard.UP, "leftKey":Keyboard.LEFT, "rightKey":Keyboard.RIGHT, "hitKey":Keyboard.M };
		
		public var firstOpenMatch:Boolean = true;
		
		
		private var _abilityObject:Object = { jump:2, move:2, quick:2, power:2 };
		
		private var _unLockArmsObject:Array = [0, 1];
		private var _ownArmsObject:Array = [0];	
		private var _equipedArm:int = 0;		
		
		private var _unLockShoulderMotorsObject:Array = [0, 1, 2];
		private var _ownShoulderMotorsObject:Array = [0];
		private var _equipedShoulderMotor:int = 0;
		
		private var _unLockWaistMotorsObject:Array = [0, 1, 2];
		private var _ownWaistMotorsObject:Array = [0];
		private var _equipedWaistMotor:int = 0;		
		
		private var _unLockMapsObject:Array = [0];
		private var _equipedMap:int = 0;
		
		
		
		
		
		//基本数据
		public var arms:Vector.<EquipmentData> = ArmData.getArms(0);		
		public var waistMotors:Vector.<EquipmentData> = WaistMotorData.getWaistMotors(0);	
		public var shoulderMotors:Vector.<EquipmentData> = ShoulderMotorData.getShoulderMotors(0);		
		public var maps:Vector.<EquipmentData> = MapData.getMaps();
		
		public var unLockArms:Vector.<EquipmentData> = new <EquipmentData>[arms[0]];		
		public var ownArms:Vector.<EquipmentData> = new <EquipmentData>[unLockArms[0]];			
		
		public var unLockShoulderMotors:Vector.<EquipmentData> = new <EquipmentData>[shoulderMotors[0]];		
		public var ownShoulderMotors:Vector.<EquipmentData> = new <EquipmentData>[unLockShoulderMotors[0]];				
		
		public var unLockWaistMotors:Vector.<EquipmentData> = new <EquipmentData>[waistMotors[0]];	
		public var ownWaistMotors:Vector.<EquipmentData> = new <EquipmentData>[unLockWaistMotors[0]];		
		
		public var unLockMaps:Vector.<EquipmentData> = new <EquipmentData>[maps[0]];

		
		public function UserData() 
		{
			super();
			_sharedObject = SharedObject.getLocal("data");
		}
		
		private function handleSaveData():void
		{
			_abilityObject.jump = ability.jump;
			_abilityObject.move = ability.move;
			_abilityObject.quick = ability.quick;
			_abilityObject.power = ability.power;
			
			_unLockArmsObject = gameToData(unLockArms);
			_ownArmsObject = gameToData(ownArms);
			_unLockShoulderMotorsObject = gameToData(unLockShoulderMotors);
			_ownShoulderMotorsObject = gameToData(ownShoulderMotors);
			_unLockWaistMotorsObject = gameToData(unLockWaistMotors);
			_ownWaistMotorsObject = gameToData(ownWaistMotors);
			_unLockMapsObject = gameToData(unLockMaps);
		}
				
		
		private function handleLoadData():void
		{
			ability.jump = _abilityObject.jump;
			ability.move = _abilityObject.move;
			ability.quick = _abilityObject.quick;
			ability.power = _abilityObject.power;
			
			unLockArms = dataToGame(_unLockArmsObject, arms);
			ownArms = dataToGame(_ownArmsObject, arms);
			unLockShoulderMotors = dataToGame(_unLockShoulderMotorsObject, shoulderMotors);
			ownShoulderMotors = dataToGame(_ownShoulderMotorsObject, shoulderMotors);
			unLockWaistMotors = dataToGame(_unLockWaistMotorsObject, waistMotors);
			ownWaistMotors = dataToGame(_ownWaistMotorsObject, waistMotors);
			unLockMaps = dataToGame(_unLockMapsObject, maps);
		}
		
		private function gameToData(gameData:Vector.<EquipmentData>):Array
		{
			var i:int = 0;
			
			var saveData:Array = new Array();			
			for (i = 0; i < gameData.length; i++ )
			{			
				saveData[i] = gameData[i].id;
			}
			return saveData;
			
		}
		
		private function dataToGame(loadData:Array, equipmentDatas:Vector.<EquipmentData>):Vector.<EquipmentData>
		{
			var i:int = 0;
			
			/*for (var param:String in loadData)
			{
				gameData[i] = equipmentDatas[param];
				i++;
			}*/
			var gameData:Vector.<EquipmentData> = new Vector.<EquipmentData>;
			
			for (i = 0; i < loadData.length; i++ )
			{			
				gameData[i] = equipmentDatas[loadData[i]];
			}
			return gameData;
		}

		
		public function saveData():void 
		{
			handleSaveData();
			
			_sharedObject.data.name = name;
			_sharedObject.data.money = money;
			_sharedObject.data.ability = ability;
			
			_sharedObject.data._unLockArmsObject = _unLockArmsObject;
			_sharedObject.data._ownArmsObject = _ownArmsObject;
			_sharedObject.data._equipedArm = _equipedArm;			
			
			_sharedObject.data._unLockShoulderMotorsObject = _unLockShoulderMotorsObject;
			_sharedObject.data._ownShoulderMotorsObject = _ownShoulderMotorsObject;
			_sharedObject.data._equipedShoulderMotor = _equipedShoulderMotor;
			
			_sharedObject.data._unLockWaistMotorsObject = _unLockWaistMotorsObject;			
			_sharedObject.data._ownWaistMotorsObject = _ownWaistMotorsObject;
			_sharedObject.data._equipedWaistMotor = _equipedWaistMotor;
			
			_sharedObject.data._unLockMapsObject = _unLockMapsObject;
			_sharedObject.data._equipedMap = _equipedMap;
			
			_sharedObject.data.p1KeySet = p1KeySet;
			_sharedObject.data.p2KeySet = p2KeySet;
			
			_sharedObject.flush();
			trace("保存游戏进度成功");
		}
		
		public function loadData():void 
		{
			if (_sharedObject.data.name)
			{
				name = _sharedObject.data.name;
				money = _sharedObject.data.money
				//ability = _sharedObject.data.ability as Ability;
				
				_unLockArmsObject = _sharedObject.data._unLockArmsObject;
				_ownArmsObject = _sharedObject.data._ownArmsObject;
				_equipedArm = _sharedObject.data._equipedArm;			
				
				_unLockShoulderMotorsObject = _sharedObject.data._unLockShoulderMotorsObject;
				_ownShoulderMotorsObject = _sharedObject.data._ownShoulderMotorsObject;
				_equipedShoulderMotor = _sharedObject.data._equipedShoulderMotor;
				
				_unLockWaistMotorsObject = _sharedObject.data._unLockWaistMotorsObject;			
				_ownWaistMotorsObject = _sharedObject.data._ownWaistMotorsObject;
				_equipedWaistMotor = _sharedObject.data._equipedWaistMotor;
				
				
				 _unLockMapsObject = _sharedObject.data._unLockMapsObject;
				 _equipedMap = _sharedObject.data._equipedMap;
				
				p1KeySet = _sharedObject.data.p1KeySet;
				p2KeySet = _sharedObject.data.p2KeySet;
				
				//trace(_unLockArmsObject);
				
				handleLoadData();
				trace("加载游戏进度成功");
			}
			else 
			{
				trace("加载游戏进度失败");
			}
			
		}
	
		
		public static function getInstance():UserData
		{
			if (!_instance)
			{
				_instance = new UserData()
			}
			return _instance;
		}
		
		public function get equipedArm():int 
		{
			if (_equipedArm > ownArms.length - 1)
			{
				_equipedArm = 0;
			}
			return _equipedArm;
		}
		
		public function set equipedArm(value:int):void 
		{
			_equipedArm = value;
		}
		
		public function get equipedShoulderMotor():int 
		{
			if (_equipedShoulderMotor > ownShoulderMotors.length - 1)
			{
				_equipedShoulderMotor = 0;
			}
			return _equipedShoulderMotor;
		}
		
		public function set equipedShoulderMotor(value:int):void 
		{
			_equipedShoulderMotor = value;
		}
		
		public function get equipedWaistMotor():int 
		{
			if (_equipedWaistMotor > ownWaistMotors.length - 1)
			{
				_equipedWaistMotor = 0;
			}
			return _equipedWaistMotor;
		}
		
		public function set equipedWaistMotor(value:int):void 
		{
			_equipedWaistMotor = value;
		}
		
		public function get equipedMap():int 
		{
			return _equipedMap;
		}
		
		public function set equipedMap(value:int):void 
		{
			_equipedMap = value;
		}
		
		
		
	}

}