package test2.ui 
{
	import flash.events.SoftKeyboardTrigger;
	import starling.display.Sprite;
	import starling.events.Event;
	import test2.assets.Assets;
	import test2.constants.KeyConst;
	
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
		
		public static const HIT_RIGHT_KEY:uint = 3;
		
		public static const HIT_LEFT_KEY:int = 4;
		
		private var _setKeyButtons:Vector.<SetKeyButton> = new Vector.<SetKeyButton>;
		
		private var jumpKey:SetKeyButton;
		private var leftKey:SetKeyButton;
		private var rightKey:SetKeyButton;
		private var hitLeftKey:SetKeyButton;
		private var hitRightKey:SetKeyButton;
		
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
			
			hitLeftKey = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			hitLeftKey.x = -hitLeftKey.width;
			hitLeftKey.y = 1.8 * hitLeftKey.height;
			addChild(hitLeftKey);
			_setKeyButtons.push(hitLeftKey);
			
			hitRightKey = new SetKeyButton(Assets.getTexture("key"), "", Assets.getTexture("keyDown"));
			hitRightKey.x = hitRightKey.width;
			hitRightKey.y = 1.8 * hitRightKey.height;
			addChild(hitRightKey);
			_setKeyButtons.push(hitRightKey);
			
			pivotX = jumpKey.width / 2;
			//pivotY = height >> 1;
		}
		
		public function get keyValues():Object 
		{
			 _keyValues["jumpKey"] = jumpKey.keyValue;
			 _keyValues["leftKey"] = leftKey.keyValue;
			 _keyValues["rightKey"] = rightKey.keyValue;
			 _keyValues["hitLeftKey"] = hitLeftKey.keyValue;
			 _keyValues["hitRightKey"] = hitRightKey.keyValue;
			
			return _keyValues;
		}
		
		public function set keyValues(value:Object):void 
		{
			_keyValues = value;
			
			jumpKey.keyValue = value["jumpKey"];
			leftKey.keyValue = value["leftKey"];
			rightKey.keyValue = value["rightKey"];
			hitLeftKey.keyValue = value["hitLeftKey"];
			hitRightKey.keyValue = value["hitRightKey"];
		}
		
	}

}