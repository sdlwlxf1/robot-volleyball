package ui.screen 
{
	import aze.motion.easing.Bounce;
	import aze.motion.easing.Cubic;
	import aze.motion.eaze;
	import dragonBones.animation.WorldClock;
	import dragonBones.Armature;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.ArmatureFactory;
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
	import logics.gameLogic.TrainLevelController;
	import ui.AbilityBoard;
	import ui.customTween.InOutTweens;
	import ui.MoveSelectBoard;
	import ui.PauseBoard;
	import ui.SelectBoard;
	import ui.SimpleButton;
	import ui.SimpleWindows;
	/**
	 * ...
	 * @author ...
	 */
	public class TrainLevelScreen extends TrainScreen 
	{
		static public const MOVE_AHEAD:int = 0;
		static public const MOVE_BACK:int = 1;
		static public const JUMP:int = 2;
		static public const BAT_BALL:int = 3;
		static public const DIG_BALL:int = 4;
		static public const FLAT_SMASH_BALL:int = 5;
		static public const HEAVY_SMASH_BALL:int = 6;
		
		
		private var _playButton:SimpleButton;
		
		private var _helpButton:SimpleButton;
		private var _abilityBoard:AbilityBoard;
		private var _levelData:LevelData;

		private var _mapData:MapData;
		
		private var _playerData1:PlayerData;
		private var _opponentData:PlayerData;
		private var _chartsButton:SimpleButton;
		private var armSelectBoard:SelectBoard;
		private var shoulderMotorSelectBoard:SelectBoard;
		private var waistMotorSelectBoard:SelectBoard;
		private var _levelText:TextField;
		private var _moveSelectBoard:MoveSelectBoard;
		private var blur:BlurFilter;
		private var dropShadow:BlurFilter;
		private var glow:BlurFilter;
		private var _selectLevelSprite:Sprite;
		private var _screenSprite:Sprite;
		private var _helpSprite:Sprite;
		private var _robotArmature:Armature;
		private var factoryName:String;
		private var _boxBoardArmature:Armature;
		private var _buttonLists:Sprite;
		private var _timer:Timer;
		private var _timeRate:Number = 100;
		private var _boxBoardAdded:Boolean = false;
		private var fontMessage:Font;
		private var _helpButtonListsSprite:Sprite;
		private var _helpButtonLists:Vector.<SimpleButton>;
		private var _helpText:TextField;
		private var _selectLevelText:TextField;
		private var oldScreenSprite:Sprite;
		private var _robotLogoButton:SimpleButton;
		
		
		public function TrainLevelScreen() 
		{
			super();
			
		}
		
		
		private function timerEventListener(e:TimerEvent):void 
		{
			if (_boxBoardArmature.animation.isComplete)
			{
				if (_boxBoardArmature.animation.movementID == "begin")
				{
					if (!_boxBoardAdded)
					{
						eaze(_buttonLists).to(0.7, { y:0 } ).easing(Bounce.easeOut);
						playButtonClick();
						_boxBoardAdded = true;
						
						/*var pauseBoard:PauseBoard = new PauseBoard();
						addChild(pauseBoard);*/
					}
				}
			}
		}
		
		
		override protected function initInOutTweens():void
		{
			_inOutTweens = new InOutTweens(this, null, null);
			_inOutTweens.inOnComplete = inOnComplete;
			_inOutTweens.outOnComplete = outOnComplete;
		}
		
		override protected function initScreens():void 
		{
			//_background = new Quad(stage.stageWidth, stage.stageHeight, 0X9D9EA2);
			_background = new Image(Assets.getTexture("UIbackground"));
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			addChild(_background);
			
			setTimeout(playSound , 700);			
			{
				function playSound():void
				{
					_ce.sound.playSound("menu_doorclose1");
				}
			}
			
			
			_timer = new Timer(_timeRate);
			_timer.addEventListener(TimerEvent.TIMER, timerEventListener);
			_timer.start();
		
			factoryName = Assets.getXML("Armature").@factoryName;
			_boxBoardArmature = ArmatureFactory.getArmature(factoryName, "boxBoard");
			(_boxBoardArmature.display as DisplayObject).x = (stage.stageWidth >> 1) + 2;
			(_boxBoardArmature.display as DisplayObject).y = (stage.stageHeight >> 1);
			addChild(_boxBoardArmature.display as DisplayObject);
			_boxBoardArmature.animation.gotoAndPlay("off");
			WorldClock.clock.add(_boxBoardArmature);
			
			
			blur = new BlurFilter();
			dropShadow = BlurFilter.createDropShadow(0, 0.9, 0x0, 1, 0.1);
			glow = BlurFilter.createGlow(0X21F7FC);
			
			
			_buttonLists = new Sprite;
			_buttonLists.y = 100;
			addChild(_buttonLists);
			
			_playButton = new SimpleButton(Assets.getTexture("buttonStart1"), "继续游戏", Assets.getTexture("buttonStart3"), Assets.getTexture("buttonStart2"));
			_playButton.fontColor = 0x000000;
			_playButton.fontName = "楷体";
			_playButton.fontSize = 25;			
			_buttonLists.addChild(_playButton);
			_playButton.pivotX = _playButton.width >> 1;
			_playButton.pivotY = _playButton.height >> 1;
			_playButton.x = stage.stageWidth / 2 /*- _playButton.width / 2*/;
			_playButton.y = stage.stageHeight - _playButton.height / 2 - 2;
			
			_playButton.addEventListener(Event.TRIGGERED, playButtonClick);
			_playButton.onHover.add(mouseOverButton);
			
			
			_helpButton = new SimpleButton(Assets.getTexture("buttonStart1"), "操作说明", Assets.getTexture("buttonStart3"), Assets.getTexture("buttonStart2"));
			_helpButton.fontColor = 0x000000;
			_helpButton.fontName = "楷体";
			_helpButton.fontSize = 23;		
			_buttonLists.addChild(_helpButton);
			_helpButton.x = stage.stageWidth / 2 - 200;
			_helpButton.y = stage.stageHeight - _playButton.height / 2 - 2;
			_helpButton.pivotX = _helpButton.width >> 1;
			_helpButton.pivotY = _helpButton.height >> 1;
			
			_helpButton.addEventListener(Event.TRIGGERED, helpButtonClick);
			_helpButton.onHover.add(mouseOverButton);
			
			_chartsButton = new SimpleButton(Assets.getTexture("buttonStart1"), "积分排行", Assets.getTexture("buttonStart3"), Assets.getTexture("buttonStart2"));
			_chartsButton.fontColor = 0x000000;
			_chartsButton.fontName = "楷体";
			_chartsButton.fontSize = 23;			
			_buttonLists.addChild(_chartsButton);
			_chartsButton.x = stage.stageWidth / 2 + 200;
			_chartsButton.y = stage.stageHeight - _playButton.height / 2 - 2;
			_chartsButton.pivotX = _chartsButton.width >> 1;
			_chartsButton.pivotY = _chartsButton.height >> 1;
			
			_chartsButton.addEventListener(Event.TRIGGERED, chartsButtonClick);
			_chartsButton.onHover.add(mouseOverButton);
		
			
			_robotLogoButton = new SimpleButton(Assets.getTexture("robotLogo"), "", Assets.getTexture("robotLogoOver"), Assets.getTexture("robotLogoOver"));
			/*_robotLogoButton.fontColor = 0x000000;
			_robotLogoButton.fontName = "楷体";
			_robotLogoButton.fontSize = 23;	*/		
			_buttonLists.addChild(_robotLogoButton);
			_robotLogoButton.x = stage.stageWidth - _robotLogoButton.width / 2;
			_robotLogoButton.y = stage.stageHeight - _robotLogoButton.height / 2 - 5;
			_robotLogoButton.pivotX = _robotLogoButton.width >> 1;
			_robotLogoButton.pivotY = _robotLogoButton.height >> 1;
			
			_robotLogoButton.addEventListener(Event.TRIGGERED, robotLogoButtonClick);
			_robotLogoButton.onHover.add(mouseOverButton);
			
			
			//玩家角色信息创建
			_playerData1 = new PlayerData();
			_playerData1.control = "keyboard";
			_playerData1.invertedViewAndBody = true;	
			_playerData1.inputName = { "down":"p1down", "right":"p1right", "left":"p1left", "jump":"p1jump", "specialHitBall":"p1specialHitBall", "generalHitBall":"p1generalHitBall", "skill1":"p1skill1"};
			_playerData1.armatureData = new ArmatureData(0);
			
			/*_playerData1.setArm(armSelectBoard.selectElement as ArmData);
			_playerData1.setShoulderMotor(shoulderMotorSelectBoard.selectElement as ShoulderMotorData);
			_playerData1.setWaistMotor(waistMotorSelectBoard.selectElement as WaistMotorData);*/
			//_playerData1.setArm(new ArmData(0, 0));
			screenController.playerData1 = _playerData1;

			
			
			_selectLevelSprite = new Sprite();
			
			_selectLevelText = new TextField(200, 50, "", "黑体", 30, 0XFFFFFF, true);
			_selectLevelText.vAlign = VAlign.CENTER;
            _selectLevelText.hAlign = HAlign.CENTER;
			_selectLevelText.filter = dropShadow;
			_selectLevelText.bold = true;
			_selectLevelText.pivotX = _selectLevelText.width >> 1;
			_selectLevelText.pivotY = _selectLevelText.height >> 1;
			_selectLevelText.x = stage.stageWidth / 2;
			_selectLevelText.y = 100;
			_selectLevelText.text = "场地切换";
			_selectLevelSprite.addChild(_selectLevelText);
			
			_levelText = new TextField(200, 50, "", "楷体", 25, 0XFFFFFF);
			_levelText.vAlign = VAlign.CENTER;
            _levelText.hAlign = HAlign.CENTER;
			_levelText.bold = true;
			_levelText.filter = dropShadow;
			_levelText.pivotX = _levelText.width >> 1;
			_levelText.pivotY = _levelText.height >> 1;
			_levelText.x = stage.stageWidth / 2;
			_levelText.y = 350;
			//_selectLevelSprite.addChild(_levelText);
			
			
			_moveSelectBoard = new MoveSelectBoard();
			_moveSelectBoard.x = stage.stageWidth >> 1;
			_moveSelectBoard.y = stage.stageHeight >> 1;
			_moveSelectBoard.scaleNum = 0.2;
			_moveSelectBoard.gapButton = -20;
			_moveSelectBoard.gapElement = -20;
			_moveSelectBoard.middleDataChange.add(middleDataChange);
			_selectLevelSprite.addChild(_moveSelectBoard);
			_moveSelectBoard.setElements(UserData.getInstance().maps);
			TrainLevelController.getInstance().curLevelID = (_moveSelectBoard.getSelectElement() as MapData).id;
			
			
			
			
			
			
			
			_helpSprite = new Sprite();
			
		
			_robotArmature = ArmatureFactory.getArmature(factoryName, "robot");
			(_robotArmature.display as DisplayObject).x = stage.stageWidth / 2 + 70;
			(_robotArmature.display as DisplayObject).y = (stage.stageHeight >> 1) - 40;
			(_robotArmature.display as DisplayObject).scaleX = -0.5;
			(_robotArmature.display as DisplayObject).scaleY = 0.5;
			_helpSprite.addChild(_robotArmature.display as DisplayObject);
			_robotArmature.animation.gotoAndPlay("stop");
			WorldClock.clock.add(_robotArmature);
			
			_helpButtonListsSprite = new Sprite();			
			_helpButtonLists = new Vector.<SimpleButton>;
			
			_helpButtonListsSprite.x = 220;
			_helpButtonListsSprite.y = 80;
			_helpSprite.addChild(_helpButtonListsSprite);
			
			var gapY:Number = 50;
			
			setHelpButton(MOVE_AHEAD, "前进", 0, 0);
			setHelpButton(MOVE_BACK, "后退", 0, gapY);
			setHelpButton(JUMP, "跳跃", 0, gapY * 2);
			setHelpButton(BAT_BALL, "击球", 0, gapY * 3);
			setHelpButton(DIG_BALL, "垫球", 0, gapY * 4);
			setHelpButton(FLAT_SMASH_BALL, "轻扣", 0, gapY * 5);
			setHelpButton(HEAVY_SMASH_BALL, "重扣", 0, gapY * 6);
			
			_helpText = new TextField(250, 100, "", "黑体", 25, 0XFFFFFF, true);
			_helpText.vAlign = VAlign.CENTER;
            _helpText.hAlign = HAlign.CENTER;
			_helpText.filter = dropShadow;
			_helpText.pivotX = _helpText.width >> 1;
			_helpText.pivotY = _helpText.height >> 1;
			_helpText.x = 500;
			_helpText.y = 350;
			_helpSprite.addChild(_helpText);
			
			_boxBoardArmature.animation.gotoAndPlay("begin");
			
			//setTimeout(_ce.sound.playSound, 1000, "menu_down", 1, 0);
			
		}
		
		private function robotLogoButtonClick(e:Event):void 
		{
			//在要调用推荐游戏列表功能的地方(比如点击更多游戏按钮时)加入以下代码，CMain为你的主应用程序名
			var _stageHold:* = Main.serviceHold;
			if(_stageHold){
				_stageHold.showGameList();
			}

		}
		
		private function mouseOverButton(simpleButton:SimpleButton):void 
		{
			_ce.sound.playSound("menu_mousepass");
		}
		
		
		private function setHelpButton(id:int, text:String, x:Number, y:Number):SimpleButton
		{			
			var simpleButton:SimpleButton = new SimpleButton(Texture.fromColor(100,40,0XCFF3FEFF), text,null/*Texture.fromColor(100,40,0X012E3AFF)*//*, Texture.fromColor(100,40,0X012E3AFF)*/);
			simpleButton.fontColor = 0X000000;
			simpleButton.fontName = "楷体";
			simpleButton.fontSize = 20;
			//simpleButton.fontItalic = true;
			simpleButton.pivotX = simpleButton.width >> 1;
			simpleButton.pivotY = simpleButton.height >> 1;
			simpleButton.x = x;
			simpleButton.y = y;			
			_helpButtonListsSprite.addChild(simpleButton);
			_helpButtonLists[id] = simpleButton;
			simpleButton.id = id;
			
			simpleButton.addEventListener(Event.TRIGGERED, function(e:Event):void{helpButtonsClick(id)});
			
			return simpleButton;
		}
		
		private function helpButtonsClick(id:int):void 
		{
			var animationName:String;
			var text:String;
			
			switch(id)
			{
				case MOVE_AHEAD:
					animationName = "moveAhead";
					text = "D";
					break;
				case MOVE_BACK:
					animationName = "moveBack";
					text = "A";
					break;
				case JUMP:
					animationName = "jumpBegin";
					text = "W";
					break;
				case BAT_BALL:
					animationName = "batBall";
					text = "J";
					break;
				case DIG_BALL:
					animationName = "digBall";
					text = "K";
					break;
				case FLAT_SMASH_BALL:
					animationName = "flatSmashBall";
					text = "W(空中) + J";
					break;
				case HEAVY_SMASH_BALL:
					animationName = "heavySmashBall";
					text = "W(空中) + K";
					break;
					
			}
			
			_robotArmature.animation.gotoAndPlay(animationName);
			_helpText.text = "按键: " + text; 
		}
		
		
		public function get screenSprite():Sprite 
		{
			return _screenSprite;
		}
		
		public function set screenSprite(value:Sprite):void 
		{
			if (_screenSprite != value)
			{
				if (_screenSprite != null)
				{
					oldScreenSprite = _screenSprite;
					oldScreenSprite.removeFromParent();
					//eaze(oldScreenSprite).to(0.1, { scaleX:1.1, scaleY:1, alpha:1 } ).easing(Cubic.easeOut).to(0.1, { scaleX:1, scaleY:1, alpha:1 } ).easing(Cubic.easeIn).delay(0.5).to(0, {alpha:0}).onComplete(oldScreenSprite.removeFromParent);
					_screenSprite = null;
				}
				
				_screenSprite = value;
				
				addChild(_screenSprite);
				//_screenSprite.alpha = 0;
				//eaze(_screenSprite).to(0.1, { scaleX:1.5, scaleY:1.5, alpha:1 } ).easing(Cubic.easeOut).to(0.1, { scaleX:1, scaleY:1, alpha:1 } ).easing(Cubic.easeIn).delay(0.5).to(0, {alpha:0}).onComplete(_screenSprite.removeFromParent);
			}
			
			
			
		}
		
		private function middleDataChange(data:Data):void 
		{
			//_moveSelectBoard.setLock(true);
			
			var levelID:int = (_moveSelectBoard.getSelectElement() as MapData).id;
			
			TrainLevelController.getInstance().curLevelID = levelID;
			
			switch(levelID)
			{
				case 0:
					_levelText.text = "初级";
					break;
				case 1:
					_levelText.text = "中级";
					break;
				case 2:
					_levelText.text = "高级";
					break;
				case 3:
					_levelText.text = "终极";
					break;
			}
		}
		
		
		private function chartsButtonClick(e:Event):void 
		{
			
			_chartsButton.filter = glow;
			_playButton.filter = null;
			_helpButton.filter = null;
			
			//4.在要显示排行榜的地方加入以下代码，CMain为你的主文档类
			var _stageHold:* = Main.serviceHold;
			if(_stageHold){
				_stageHold.showSort();
			}

			
			//screenController.dispatchSignal(ScreenConst.TRAIN_LEVEL_SCREEN, ScreenConst.SHOP_BUTTON_CLICK, this);	
		}
		
		private function helpButtonClick(e:Event):void 
		{
			screenSprite = _helpSprite;
			_playButton.text = "继续游戏";
			
			_chartsButton.filter = null;
			_playButton.filter = null;
			_helpButton.filter = glow;

			
			//screenController.dispatchSignal(ScreenConst.TRAIN_LEVEL_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
		private function playButtonClick(e:Event = null):void 
		{
			_chartsButton.filter = null;
			_playButton.filter = glow;
			_helpButton.filter = null;

			
			if (screenSprite == _selectLevelSprite)
			{
				_playerData1.dataByAbility();
				//_opponentData.dataByAbility();
				screenController.dispatchSignal(ScreenConst.TRAIN_LEVEL_SCREEN, ScreenConst.PLAY_BUTTON_CLICK, this);	
			}
			else
			{
				screenSprite = _selectLevelSprite;
				_playButton.text = "开始游戏";
			}
		}
		
		
		
		/*public function renderSelectBoard():void
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
		}*/
		
		
		
		/*private function onWaistMotorChange(value:Data):void 
		{
			_ce.sound.playSound("menu_buywepon", 1.5, 0);
			
			_playerData1.setWaistMotor(value as WaistMotorData);
			_abilityBoard.setAbility(_playerData1.equipAbility);
			UserData.getInstance().equipedWaistMotor = waistMotorSelectBoard.selectID;
		}
		
		private function onArmChange(value:Data):void 
		{
			_ce.sound.playSound("menu_buywepon", 1.5, 0);
			
			_playerData1.setArm(value as ArmData);
			_abilityBoard.setAbility(_playerData1.equipAbility);
			UserData.getInstance().equipedArm = armSelectBoard.selectID;
		}
		
		private function onShoulderMotorChange(value:Data):void 
		{
			_ce.sound.playSound("menu_buywepon", 1.5, 0);
			
			_playerData1.setShoulderMotor(value as ShoulderMotorData);
			_abilityBoard.setAbility(_playerData1.equipAbility);
			UserData.getInstance().equipedShoulderMotor = shoulderMotorSelectBoard.selectID;
		}*/
		
		
		
		
		
		
		
	}

}