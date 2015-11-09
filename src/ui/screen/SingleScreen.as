package ui.screen 
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.Assets;
	import assets.Fonts;
	import constants.ScreenConst;
	import customObjects.Font;
	import data.Ability;
	import data.ArmatureData;
	import data.ArmData;
	import data.Data;
	import data.LevelData;
	import data.MapData;
	import data.PlayerData;
	import data.ShoulderMotorData;
	import data.UserData;
	import data.WaistMotorData;
	import logics.gameLogic.LevelController;
	import ui.AbilityBoard;
	import ui.SelectBoard;
	import ui.SimpleButton;
	import ui.SimpleWindows;
	/**
	 * ...
	 * @author ...
	 */
	public class SingleScreen extends Screen 
	{
		private var _playButton:SimpleButton;
		
		private var _backButton:SimpleButton;
		private var _abilityBoard:AbilityBoard;
		private var _levelData:LevelData;

		private var _mapData:MapData;
		
		private var _playerData1:PlayerData;
		private var _opponentData:PlayerData;
		private var _shopButton:SimpleButton;
		private var armSelectBoard:SelectBoard;
		private var shoulderMotorSelectBoard:SelectBoard;
		private var waistMotorSelectBoard:SelectBoard;
		private var _levelText:TextField;
		
		
		public function SingleScreen() 
		{
			super();
			
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
			
		
			
			var fontMessage:Font = Fonts.getFont("smooth");
			
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
			
	
			armSelectBoard = new SelectBoard(UserData.getInstance().ownArms);
			armSelectBoard.x = stage.stageWidth / 2 - armSelectBoard.width / 2 - 100;
			armSelectBoard.y = stage.stageHeight / 2 - armSelectBoard.height / 2 - 170;
			armSelectBoard.scaleNum = 0.5;
			addChild(armSelectBoard);
			armSelectBoard.selectID = UserData.getInstance().equipedArm;
			armSelectBoard.onSelectChange.add(onArmChange);
			
			shoulderMotorSelectBoard = new SelectBoard(UserData.getInstance().ownShoulderMotors);
			shoulderMotorSelectBoard.x = stage.stageWidth / 2 - shoulderMotorSelectBoard.width / 2;
			shoulderMotorSelectBoard.y = stage.stageHeight / 2 - shoulderMotorSelectBoard.height / 2;
			shoulderMotorSelectBoard.rangeX = 120;
			addChild(shoulderMotorSelectBoard);
			shoulderMotorSelectBoard.selectID = UserData.getInstance().equipedShoulderMotor;
			shoulderMotorSelectBoard.onSelectChange.add(onShoulderMotorChange);
			
			waistMotorSelectBoard = new SelectBoard(UserData.getInstance().ownWaistMotors);
			waistMotorSelectBoard.x = stage.stageWidth / 2 - waistMotorSelectBoard.width / 2 + 100;
			waistMotorSelectBoard.y = stage.stageHeight / 2 - waistMotorSelectBoard.height / 2 + 170;
			addChild(waistMotorSelectBoard);
			waistMotorSelectBoard.selectID = UserData.getInstance().equipedWaistMotor;
			waistMotorSelectBoard.onSelectChange.add(onWaistMotorChange);
		
			
			
			//玩家角色信息创建
			_playerData1 = new PlayerData();
			_playerData1.control = "keyboard";
			_playerData1.invertedViewAndBody = true;	
			_playerData1.inputName = { "down":"p1down", "right":"p1right", "left":"p1left", "jump":"p1jump", "specialHitBall":"p1specialHitBall", "generalHitBall":"p1generalHitBall"};
			_playerData1.armatureData = new ArmatureData(0);
			
			_playerData1.setArm(armSelectBoard.selectElement as ArmData);
			_playerData1.setShoulderMotor(shoulderMotorSelectBoard.selectElement as ShoulderMotorData);
			_playerData1.setWaistMotor(waistMotorSelectBoard.selectElement as WaistMotorData);
			//_playerData1.setArm(new ArmData(0, 0));
			screenController.playerData1 = _playerData1;
			
			
			_levelData = LevelController.getInstance().getCurLevelData();
			_opponentData = _levelData.opponentData;
			_mapData = _levelData.mapData;
			screenController.playerData2 = _opponentData;
			screenController.mapData = _mapData;
			
			
			_abilityBoard = new AbilityBoard();	
			_abilityBoard.x = 30;
			_abilityBoard.y = 320;
			addChild(_abilityBoard);
			_abilityBoard.setAbility(_playerData1.equipAbility);
			
			_levelText = new TextField(200, 50, "第 " + LevelController.getInstance().curLevelID + " 关", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_levelText.vAlign = VAlign.CENTER;
            _levelText.hAlign = HAlign.CENTER;
			_levelText.pivotX = _levelText.width >> 1;
			_levelText.pivotY = _levelText.height >> 1;
			_levelText.x = stage.stageWidth - 100;
			_levelText.y = 200;
			addChild(_levelText);
			
		}
		
		public function renderSelectBoard():void
		{
			armSelectBoard.elements = UserData.getInstance().ownArms;
			armSelectBoard.selectID = UserData.getInstance().equipedArm;
			shoulderMotorSelectBoard.elements = UserData.getInstance().ownShoulderMotors;
			shoulderMotorSelectBoard.selectID = UserData.getInstance().equipedShoulderMotor;
			waistMotorSelectBoard.elements = UserData.getInstance().ownWaistMotors;
			waistMotorSelectBoard.selectID = UserData.getInstance().equipedWaistMotor;
			_playerData1.setArm(armSelectBoard.selectElement as ArmData);
			_playerData1.setShoulderMotor(shoulderMotorSelectBoard.selectElement as ShoulderMotorData);
			_playerData1.setWaistMotor(waistMotorSelectBoard.selectElement as WaistMotorData);
			//_playerData1.setArm(new ArmData(0, 0));
			screenController.playerData1 = _playerData1;
			_abilityBoard.setAbility(_playerData1.equipAbility);
		}
		
		private function shopButtonClick(e:Event):void 
		{
			screenController.dispatchSignal(ScreenConst.SINGLE_SCREEN, ScreenConst.SHOP_BUTTON_CLICK, this);	
		}
		
		private function onWaistMotorChange(value:Data):void 
		{
			_ce.sound.playSound("menu_buywepon");
			
			_playerData1.setWaistMotor(value as WaistMotorData);
			_abilityBoard.setAbility(_playerData1.equipAbility);
			UserData.getInstance().equipedWaistMotor = waistMotorSelectBoard.selectID;
		}
		
		private function onArmChange(value:Data):void 
		{
			_ce.sound.playSound("menu_buywepon");
			
			_playerData1.setArm(value as ArmData);
			_abilityBoard.setAbility(_playerData1.equipAbility);
			UserData.getInstance().equipedArm = armSelectBoard.selectID;
		}
		
		private function onShoulderMotorChange(value:Data):void 
		{
			_ce.sound.playSound("menu_buywepon");
			
			_playerData1.setShoulderMotor(value as ShoulderMotorData);
			_abilityBoard.setAbility(_playerData1.equipAbility);
			UserData.getInstance().equipedShoulderMotor = shoulderMotorSelectBoard.selectID;
		}
		
		private function backButtonClick(e:Event):void 
		{
			var simpleWindows:SimpleWindows = new SimpleWindows();
			addChild(simpleWindows);
			simpleWindows.setText("确定要返回吗？\n游戏进度丢失\n将从第一关开始。");
			simpleWindows.OKSignal.add(backOK);
			//simpleWindows.cancelSignal.add(buyCancel);			
		}
		
		private function backOK():void 
		{
			LevelController.getInstance().goToLevel(0);
			screenController.dispatchSignal(ScreenConst.SINGLE_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
		private function playButtonClick(e:Event):void 
		{
			_playerData1.dataByAbility();
			_opponentData.dataByAbility();
			screenController.dispatchSignal(ScreenConst.SINGLE_SCREEN, ScreenConst.PLAY_BUTTON_CLICK, this);	
		}
		
		
		
		
		
	}

}