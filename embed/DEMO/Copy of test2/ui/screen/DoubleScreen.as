package test2.ui.screen 
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.constants.ScreenConst;
	import test2.customObjects.Font;
	import test2.data.ArmatureData;
	import test2.data.ArmData;
	import test2.data.Data;
	import test2.data.MapData;
	import test2.data.PlayerData;
	import test2.data.ShoulderMotorData;
	import test2.data.UserData;
	import test2.data.WaistMotorData;
	import test2.logic.gameLogic.ScreenController;
	import test2.ui.AbilityBoard;
	import test2.ui.SelectBoard;
	import test2.ui.SimpleButton;
	/**
	 * ...
	 * @author ...
	 */
	public class DoubleScreen extends Screen 
	{
		private var _playButton:SimpleButton;
		private var _backButton:SimpleButton;
		private var _abilityBoard1:AbilityBoard;
		private var _abilityBoard2:AbilityBoard;
		private var _playerData1:PlayerData;
		private var _playerData2:PlayerData;
		private var _shopButton:SimpleButton;
		private var armSelectBoard1:SelectBoard;
		private var shoulderMotorSelectBoard1:SelectBoard;
		private var waistMotorSelectBoard1:SelectBoard;
		private var armSelectBoard2:SelectBoard;
		private var shoulderMotorSelectBoard2:SelectBoard;
		private var waistMotorSelectBoard2:SelectBoard;
		private var mapSelectBoard:SelectBoard;
		private var _player1Text:TextField;
		private var _player2Text:TextField;
		
		public function DoubleScreen() 
		{
			super();
			
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
			
			var fontMessage:Font = Fonts.getFont("smooth");
			
			
			
			_player1Text = new TextField(150, 50, "", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_player1Text.x = 180;
			_player1Text.y = 15;
			addChild(_player1Text);
			_player1Text.text = "玩家 1 ";
			_player1Text.vAlign = VAlign.CENTER;
			_player1Text.hAlign = HAlign.CENTER;
			
			
			_player2Text = new TextField(150, 50, "", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_player2Text.x = stage.stageWidth - _player1Text.x - _player2Text.width;
			_player2Text.y = _player1Text.y;
			addChild(_player2Text);
			_player2Text.text = "玩家 2 ";
			_player2Text.vAlign = VAlign.CENTER;
			_player2Text.hAlign = HAlign.CENTER;
			
			_playButton = new SimpleButton(Texture.fromColor(150, 40, 0x00000000), "开始比赛");
			_playButton.fontColor = fontMessage.fontColor;
			_playButton.fontName = fontMessage.fontName;
			_playButton.fontSize = fontMessage.fontSize;
			_playButton.x = stage.stageWidth - _playButton.width - 20;
			_playButton.y = stage.stageHeight - _playButton.height - 20;
			addChild(_playButton);
			
			_playButton.addEventListener(Event.TRIGGERED, playButtonClick);
			
			_backButton = new SimpleButton(Texture.fromColor(110, 40, 0x00000000), "返回");
			_backButton.fontColor = fontMessage.fontColor;
			_backButton.fontName = fontMessage.fontName;
			_backButton.fontSize = fontMessage.fontSize;
			_backButton.x = 0;
			_backButton.y = 0;
			addChild(_backButton);
			
			_backButton.addEventListener(Event.TRIGGERED, backButtonClick);
			
			_shopButton = new SimpleButton(Texture.fromColor(110, 40, 0x00000000), "商店");
			_shopButton.fontColor = fontMessage.fontColor;
			_shopButton.fontName = fontMessage.fontName;
			_shopButton.fontSize = fontMessage.fontSize;
			_shopButton.x = stage.stageWidth - _shopButton.width;
			_shopButton.y = 0;
			addChild(_shopButton);
			
			_shopButton.addEventListener(Event.TRIGGERED, shopButtonClick);
			
			
			armSelectBoard1 = new SelectBoard(UserData.getInstance().ownArms);
			armSelectBoard1.x = stage.stageWidth / 2 - armSelectBoard1.width / 2 - 200 - 50;
			armSelectBoard1.y = stage.stageHeight / 2 - armSelectBoard1.height / 2 - 130;
			addChild(armSelectBoard1);
			armSelectBoard1.selectID = UserData.getInstance().equipedArm;
			armSelectBoard1.onSelectChange.add(onArmChange1);
			
			shoulderMotorSelectBoard1 = new SelectBoard(UserData.getInstance().ownShoulderMotors);
			shoulderMotorSelectBoard1.x = stage.stageWidth / 2 - shoulderMotorSelectBoard1.width / 2 - 200 + 40;
			shoulderMotorSelectBoard1.y = stage.stageHeight / 2 - shoulderMotorSelectBoard1.height / 2;
			addChild(shoulderMotorSelectBoard1);
			shoulderMotorSelectBoard1.selectID = UserData.getInstance().equipedShoulderMotor;
			shoulderMotorSelectBoard1.onSelectChange.add(onShoulderMotorChange1);
			
			waistMotorSelectBoard1 = new SelectBoard(UserData.getInstance().ownWaistMotors);
			waistMotorSelectBoard1.x = stage.stageWidth / 2 - waistMotorSelectBoard1.width / 2 - 200 - 50;
			waistMotorSelectBoard1.y = stage.stageHeight / 2 - waistMotorSelectBoard1.height / 2 + 150;
			addChild(waistMotorSelectBoard1);
			waistMotorSelectBoard1.selectID = UserData.getInstance().equipedWaistMotor;
			waistMotorSelectBoard1.onSelectChange.add(onWaistMotorChange1);
			
			
			armSelectBoard2 = new SelectBoard(UserData.getInstance().ownArms);
			armSelectBoard2.x = stage.stageWidth / 2 - armSelectBoard2.width / 2 + 200 + 50;
			armSelectBoard2.y = stage.stageHeight / 2 - armSelectBoard2.height / 2 - 130;
			addChild(armSelectBoard2);
			armSelectBoard2.selectID = UserData.getInstance().equipedArm;
			armSelectBoard2.onSelectChange.add(onArmChange2);
			
			shoulderMotorSelectBoard2 = new SelectBoard(UserData.getInstance().ownShoulderMotors);
			shoulderMotorSelectBoard2.x = stage.stageWidth / 2 - shoulderMotorSelectBoard2.width / 2 + 200 - 40;
			shoulderMotorSelectBoard2.y = stage.stageHeight / 2 - shoulderMotorSelectBoard2.height / 2;
			addChild(shoulderMotorSelectBoard2);
			shoulderMotorSelectBoard2.selectID = UserData.getInstance().equipedShoulderMotor;
			shoulderMotorSelectBoard2.onSelectChange.add(onShoulderMotorChange2);
			
			waistMotorSelectBoard2 = new SelectBoard(UserData.getInstance().ownWaistMotors);
			waistMotorSelectBoard2.x = stage.stageWidth / 2 - waistMotorSelectBoard2.width / 2 + 200 + 50;
			waistMotorSelectBoard2.y = stage.stageHeight / 2 - waistMotorSelectBoard2.height / 2 + 150;
			addChild(waistMotorSelectBoard2);
			waistMotorSelectBoard2.selectID = UserData.getInstance().equipedWaistMotor;
			waistMotorSelectBoard2.onSelectChange.add(onWaistMotorChange2);
			
			mapSelectBoard = new SelectBoard(UserData.getInstance().unLockMaps);
			mapSelectBoard.x = stage.stageWidth / 2 - mapSelectBoard.width / 2;
			mapSelectBoard.y = stage.stageHeight / 2 - mapSelectBoard.height / 2 + 190;
			mapSelectBoard.scaleNum = 0.1;
			addChild(mapSelectBoard);
			mapSelectBoard.selectID = UserData.getInstance().equipedMap;
			screenController.mapData = mapSelectBoard.selectElement as MapData;
			mapSelectBoard.onSelectChange.add(onMapChange);
			
			
			//玩家角色信息创建
			_playerData1 = new PlayerData();
			_playerData1.name = "playerLeft";
			_playerData1.control = "keyboard";
			_playerData1.invertedViewAndBody = true;	
			_playerData1.inputName = { "down":"p1down", "right":"p1right", "left":"p1left", "jump":"p1jump", "hit":"p1hit" };
			_playerData1.armatureData = new ArmatureData(0);
			
			
			_playerData1.setArm(armSelectBoard1.selectElement as ArmData);
			_playerData1.setShoulderMotor(shoulderMotorSelectBoard1.selectElement as ShoulderMotorData);
			_playerData1.setWaistMotor(waistMotorSelectBoard1.selectElement as WaistMotorData);
			//_playerData1.setArm(new ArmData(0, 0));
			screenController.playerData1 = _playerData1;
			
			_playerData2 = new PlayerData();
			_playerData2.name = "playerRight";
			_playerData2.control = "keyboard";
			_playerData2.inputName = { "down": "p2down", "right": "p2right", "left": "p2left", "jump": "p2jump", "hit": "p2hit" };
			_playerData2.invertedViewAndBody = false;
			_playerData2.startX = stage.stageWidth - _playerData2.startX;
			_playerData2.armatureData = new ArmatureData(0);
			
			_playerData2.setArm(armSelectBoard2.selectElement as ArmData);
			_playerData2.setShoulderMotor(shoulderMotorSelectBoard2.selectElement as ShoulderMotorData);
			_playerData2.setWaistMotor(waistMotorSelectBoard2.selectElement as WaistMotorData);
			
			screenController.playerData2 = _playerData2;
			
			_abilityBoard1 = new AbilityBoard();	
			_abilityBoard1.x = 90;
			_abilityBoard1.y = 250;
			addChild(_abilityBoard1);
			_abilityBoard1.setAbility(_playerData1.equipAbility);
			
			_abilityBoard2 = new AbilityBoard();	
			_abilityBoard2.x = stage.stageWidth - 150;
			_abilityBoard2.y = 250;
			addChild(_abilityBoard2);
			_abilityBoard2.setAbility(_playerData2.equipAbility);
			
		}

		
		public function renderSelectBoard():void
		{
			armSelectBoard1.elements = UserData.getInstance().ownArms;
			armSelectBoard1.selectID = UserData.getInstance().equipedArm;
			shoulderMotorSelectBoard1.elements = UserData.getInstance().ownShoulderMotors;
			shoulderMotorSelectBoard1.selectID = UserData.getInstance().equipedShoulderMotor;
			waistMotorSelectBoard1.elements = UserData.getInstance().ownWaistMotors;
			waistMotorSelectBoard1.selectID = UserData.getInstance().equipedWaistMotor;
			
			_playerData1.setArm(armSelectBoard1.selectElement as ArmData);
			_playerData1.setShoulderMotor(shoulderMotorSelectBoard1.selectElement as ShoulderMotorData);
			_playerData1.setWaistMotor(waistMotorSelectBoard1.selectElement as WaistMotorData);
			//_playerData1.setArm(new ArmData(0, 0));
			screenController.playerData1 = _playerData1;
			_abilityBoard1.setAbility(_playerData1.equipAbility);
			
			armSelectBoard2.elements = UserData.getInstance().ownArms;
			armSelectBoard2.selectID = UserData.getInstance().equipedArm;
			shoulderMotorSelectBoard2.elements = UserData.getInstance().ownShoulderMotors;
			shoulderMotorSelectBoard2.selectID = UserData.getInstance().equipedShoulderMotor;
			waistMotorSelectBoard2.elements = UserData.getInstance().ownWaistMotors;
			waistMotorSelectBoard2.selectID = UserData.getInstance().equipedWaistMotor;
			_playerData2.setArm(armSelectBoard2.selectElement as ArmData);
			_playerData2.setShoulderMotor(shoulderMotorSelectBoard2.selectElement as ShoulderMotorData);
			_playerData2.setWaistMotor(waistMotorSelectBoard2.selectElement as WaistMotorData);
			
			screenController.playerData2 = _playerData2;
			_abilityBoard2.setAbility(_playerData2.equipAbility);
		}
		
		private function shopButtonClick(e:Event):void 
		{
			screenController.dispatchSignal(ScreenConst.SINGLE_SCREEN, ScreenConst.SHOP_BUTTON_CLICK, this);	
		}
		
		private function onWaistMotorChange1(value:Data):void 
		{
			_playerData1.setWaistMotor(value as WaistMotorData);
			_abilityBoard1.setAbility(_playerData1.equipAbility);
		}
		
		private function onArmChange1(value:Data):void 
		{
			_playerData1.setArm(value as ArmData);
			_abilityBoard1.setAbility(_playerData1.equipAbility);
		}
		
		private function onShoulderMotorChange1(value:Data):void 
		{
			_playerData1.setShoulderMotor(value as ShoulderMotorData);
			_abilityBoard1.setAbility(_playerData1.equipAbility);
		}
		
		private function onWaistMotorChange2(value:Data):void 
		{
			_playerData2.setWaistMotor(value as WaistMotorData);
			_abilityBoard2.setAbility(_playerData2.equipAbility);
		}
		
		private function onArmChange2(value:Data):void 
		{
			_playerData2.setArm(value as ArmData);
			_abilityBoard2.setAbility(_playerData2.equipAbility);
		}
		
		private function onShoulderMotorChange2(value:Data):void 
		{
			_playerData2.setShoulderMotor(value as ShoulderMotorData);
			_abilityBoard2.setAbility(_playerData2.equipAbility);
		}
		
				
		private function onMapChange(value:Data):void 
		{
			screenController.mapData = value as MapData;
		}
		
		private function backButtonClick(e:Event):void 
		{
			screenController.dispatchSignal(ScreenConst.DOUBLE_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);	
		}
		
		private function playButtonClick(e:Event):void 
		{
			_playerData1.dataByAbility();
			_playerData2.dataByAbility();
			screenController.dispatchSignal(ScreenConst.DOUBLE_SCREEN, ScreenConst.PLAY_BUTTON_CLICK, this);	
		}
		
	}

}