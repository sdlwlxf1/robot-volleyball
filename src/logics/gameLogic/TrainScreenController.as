package logics.gameLogic 
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import org.osflash.signals.Signal;
	import starling.display.Stage;
	import constants.ScreenConst;
	import data.MapData;
	import data.PlayerData;
	import state.MatchState;
	import state.TrainMenuState;
	import state.TrainSmashBallState;
	import ui.screen.TrainCurtainScreen;
	import ui.screen.TrainDeveloperScreen;
	import ui.screen.DoubleScreen;
	import ui.screen.GameOverScreen;
	import ui.screen.GameWinScreen;
	import ui.screen.TrainLogoScreen;
	import ui.screen.MatchScreen;
	import ui.screen.Screen;
	import ui.screen.TrainSetKeyScreen;
	import ui.screen.TrainShopScreen;
	import ui.screen.TrainLevelScreen;
	import ui.screen.TrainStartScreen;
	import ui.screen.TrainStartScreen;
	/**
	 * ...
	 * @author ...
	 */
	public class TrainScreenController
	{
		public var playerData1:PlayerData;

		public var mapData:MapData;
		
		private static var _instance:TrainScreenController;
		
		public static var firstOpenGame:Boolean = true;
		
		public static var firstOpenMatch:Boolean = false;
		
		public static var gameMode:int = 1;
		
		private var _ce:CitrusEngine;
		
		private var _signals:Vector.<Vector.<Signal>>;
		
		private var _screenMax:int = -1;
		private var _signalMax:Vector.<int> = new <int>[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
		
		
		private var screen:Screen;
		
		
		private var _trainLevelScreen:TrainLevelScreen;
		private var _trainCurtainScreen:TrainCurtainScreen;
		private var _trainStartScreen:TrainStartScreen;
		private var _trainSetKeyScreen:TrainSetKeyScreen;
		
		public var onTrainLogoScreenOver:Signal;
		
		public function TrainScreenController() 
		{
			_signals = new Vector.<Vector.<Signal>>;
			_ce = CitrusEngine.getInstance();
		}
		
		public static function getInstance():TrainScreenController {
			
			if (!_instance)
				_instance = new TrainScreenController();
				
			return _instance;
		}
		
		public function getSignal(screenID:int, signalID:int):Signal
		{
			var i:int;	
			
			if (screenID > _screenMax)
			{
				for (i = _screenMax + 1; i < screenID; i++ )
				{
					_signals[i] = null;
				}
				_signals[screenID] = new Vector.<Signal>;				
				_screenMax = screenID;
			}
			
			if (_signals[screenID] == null)
			{
				_signals[screenID] = new Vector.<Signal>;
			}
			
			if (signalID > _signalMax[screenID])
			{
				for (i = _signalMax[screenID] + 1; i < signalID; i++ )
				{
					_signals[screenID][i] = null;
				}
				_signals[screenID][signalID] = new Signal();
				_signals[screenID][signalID].add(signalFunction);
				
				_signalMax[screenID] = signalID;
			}
			
			if (_signals[screenID][signalID] == null)
			{
				_signals[screenID][signalID] = new Signal();
				_signals[screenID][signalID].add(signalFunction);
			}
			
			return _signals[screenID][signalID];
		}
		
		public function dispatchSignal(screenID:int, signalID:int, value:* = null):void
		{
			getSignal(screenID, signalID).dispatch(screenID, signalID, value);
		}
		
		private function signalFunction(screenID:int, signalID:int, value:* = null):void 
		{
			switch(screenID)
			{
				case ScreenConst.TRAIN_LOGO_SCREEN:
					switch(signalID)
					{
						case ScreenConst.SCREEN_OUT:
							_trainStartScreen = new TrainStartScreen();
							(_ce.state as TrainMenuState).addChild(_trainStartScreen);
							_trainStartScreen.inOnCompleteEffect = (value as TrainLogoScreen).destroy;
							
							
							/*_trainLevelScreen = new TrainLevelScreen();
							(_ce.state as TrainMenuState).addChild(_trainLevelScreen);							
							_trainLevelScreen.inOnCompleteEffect = (value as TrainLogoScreen).destroy;*/
							break;
					}
					break;
				case ScreenConst.TRAIN_START_SCREEN:
					switch(signalID)
					{
						case ScreenConst.SINGLE_BUTTON_CLICK:
							_trainLevelScreen = new TrainLevelScreen();
							(_ce.state as TrainMenuState).addChild(_trainLevelScreen);
							_trainLevelScreen.inOnCompleteEffect = (value as TrainStartScreen).destroy;
							//(value as TrainStartScreen).destroy();
							//_ce.state = new MatchState();
							break;
						case ScreenConst.CHARTS_BUTTON_CLICK:
							/*_doubleScreen = new DoubleScreen();
							(_ce.state as TrainMenuState).addChild(_doubleScreen);
							_doubleScreen.inOnCompleteEffect = (value as TrainStartScreen).destroy;*/
							break;
						case ScreenConst.SET_BUTTON_CLICK:
							(_ce.state as TrainMenuState).addChild(new TrainSetKeyScreen());
							break;
						case ScreenConst.SHOP_BUTTON_CLICK:
							(_ce.state as TrainMenuState).addChild(new TrainShopScreen());
							break;
						case ScreenConst.DEVELOPER_BUTTON_CLICK:
							(_ce.state as TrainMenuState).addChild(new TrainDeveloperScreen());
							break;
					}
					break;
				case ScreenConst.TRAIN_LEVEL_SCREEN:
					switch(signalID)
					{
						case ScreenConst.PLAY_BUTTON_CLICK:
							//gameMode = 1;
							_trainCurtainScreen = new TrainCurtainScreen();
							(value as TrainLevelScreen).stage.addChild(_trainCurtainScreen);								
							break;
						case ScreenConst.BACK_BUTTON_CLICK:
							_trainStartScreen = new TrainStartScreen();
							(_ce.state as TrainMenuState).addChild(_trainStartScreen);
							_trainStartScreen.inOnCompleteEffect = (value as TrainLevelScreen).destroy;
							break;
						case ScreenConst.SHOP_BUTTON_CLICK:
							(_ce.state as TrainMenuState).addChild(new TrainShopScreen());
							break;
					}
					break;
					
				case ScreenConst.TRAIN_SMASH_BALL_SCREEN:
					switch(signalID)
					{
						case ScreenConst.PLAY_BUTTON_CLICK:
							
							break;
						case ScreenConst.BACK_BUTTON_CLICK:						
							_ce.state = new TrainMenuState();

							_trainLevelScreen = new TrainLevelScreen();
							(_ce.state as TrainMenuState).addChild(_trainLevelScreen);

							break;
						case ScreenConst.SET_BUTTON_CLICK:
							_trainSetKeyScreen = new TrainSetKeyScreen();
							(_ce.state as StarlingState).stage.addChild(_trainSetKeyScreen);
							break;
						case ScreenConst.REWARD_OVER:
							_trainCurtainScreen = new TrainCurtainScreen();
							(value as Stage).addChild(_trainCurtainScreen);
							break;
						case ScreenConst.ANOTHERGAME:
							
							break;
					}
					break;
				case ScreenConst.TRAIN_SHOP_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							(value as TrainShopScreen).destroy();
							/*if (_trainLevelScreen)
							{
								_trainLevelScreen.renderSelectBoard();
							}*/
							break;
							
					}
					break;
					
				case ScreenConst.TRAIN_SETKEY_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							(value as TrainSetKeyScreen).destroy();
							break;
					}
					break;
					
				case ScreenConst.TRAIN_DEVELOPER_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							(value as TrainDeveloperScreen).destroy();
							break;
					}
					break;
					
				case ScreenConst.GAMEOVER_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							_ce.state = new TrainMenuState();
							(value as GameOverScreen).destroy();
							_trainLevelScreen = new TrainLevelScreen();
							(_ce.state as TrainMenuState).addChild(_trainLevelScreen);
							break;
						case ScreenConst.SCREEN_IN:
							
							break;
					}
					break;
					
				case ScreenConst.GAMEWIN_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							_ce.state = new TrainMenuState();
							(value as GameWinScreen).destroy();
							_trainStartScreen = new TrainStartScreen();
							(_ce.state as TrainMenuState).addChild(_trainStartScreen);
							break;
						case ScreenConst.SCREEN_IN:
							
							break;
					}
					break;
					
				case ScreenConst.TRAIN_CURTAIN_SCREEN:
					switch(signalID)
					{
						case ScreenConst.SCREEN_CLOSED:
							if (_ce.state is TrainMenuState)
							{
								_ce.state = new TrainSmashBallState();						
							}
							else if (_ce.state is TrainSmashBallState)
							{
								_ce.state = new TrainMenuState();

								_trainLevelScreen = new TrainLevelScreen();
								(_ce.state as TrainMenuState).addChild(_trainLevelScreen);

								break;
							}
							break;
							
					}
					break;
					
			}
		}
		
	}

}