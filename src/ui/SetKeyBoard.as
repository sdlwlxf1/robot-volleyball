package ui 
{
	import flash.events.SoftKeyboardTrigger;
	import starling.display.Sprite;
	import starling.events.Event;
	import assets.Assets;
	import constants.KeyConst;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class SetKeyBoard extends Sprite 
	{
		private var _keyValues:Object;
		
		public static const JUMP_KEY:uint = 0;
		
		public static const LEFT_KEY:uint = 1;
		
		public static const RIGHT_KEY:uint = 2;
		
		public static const GENERAL_HIT_KEY:uint = 3;
		
		public static const SPECIAL_HIT_KEY:int = 4;
		
		private var _setKeyButtons:Vector.<SetKeyButton> = new Vector.<SetKeyButton>;
		
		private var jumpKey:SetKeyButton;
		private var leftKey:SetKeyButton;
		private var rightKey:SetKeyButton;
		private var specialHitBallKey:SetKeyButton;
		private var generalHitBallKey:SetKeyButton;
		private var skill1Key:SetKeyButton;
		private var downKey:SetKeyButton;
		
		public function SetKeyBoard() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			jumpKey = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			jumpKey.y = -jumpKey.height;
			addChild(jumpKey);
			_setKeyButtons.push(jumpKey);
			
			leftKey = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			leftKey.x = -leftKey.width;
			addChild(leftKey);
			_setKeyButtons.push(leftKey);
			
			rightKey = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			rightKey.x = leftKey.width;
			addChild(rightKey);
			_setKeyButtons.push(rightKey);
			
			downKey = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			downKey.x = 0;
			addChild(downKey);
			_setKeyButtons.push(downKey);
			
			generalHitBallKey = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			generalHitBallKey.x = -generalHitBallKey.width;
			generalHitBallKey.y = 1.38 * generalHitBallKey.height;
			addChild(generalHitBallKey);
			_setKeyButtons.push(generalHitBallKey);
			
			specialHitBallKey = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			specialHitBallKey.x = specialHitBallKey.width;
			specialHitBallKey.y = 1.38 * specialHitBallKey.height;
			addChild(specialHitBallKey);
			_setKeyButtons.push(specialHitBallKey);
			
			skill1Key = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			skill1Key.x = 0;
			skill1Key.y = 1.38 * skill1Key.height;
			addChild(skill1Key);
			_setKeyButtons.push(skill1Key);
			
			
			
			pivotX = jumpKey.width / 2;
			//pivotY = height >> 1;
		}
		
		public function get keyValues():Object 
		{
			 _keyValues["jumpKey"] = jumpKey.keyValue;
			 _keyValues["leftKey"] = leftKey.keyValue;
			 _keyValues["rightKey"] = rightKey.keyValue;
			 _keyValues["downKey"] = downKey.keyValue;
			 _keyValues["specialHitBallKey"] = specialHitBallKey.keyValue;
			 _keyValues["generalHitBallKey"] = generalHitBallKey.keyValue;
			 _keyValues["skill1Key"] = skill1Key.keyValue;
			
			return _keyValues;
		}
		
		public function set keyValues(value:Object):void 
		{
			_keyValues = value;
			
			jumpKey.keyValue = value["jumpKey"];
			leftKey.keyValue = value["leftKey"];
			rightKey.keyValue = value["rightKey"];
			downKey.keyValue = value["downKey"];
			specialHitBallKey.keyValue = value["specialHitBallKey"];
			generalHitBallKey.keyValue = value["generalHitBallKey"];
			skill1Key.keyValue = _keyValues["skill1Key"];
		}
		
	}

}