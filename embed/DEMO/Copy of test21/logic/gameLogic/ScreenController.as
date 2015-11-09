package test2.logic.gameLogic 
{
	import citrus.core.CitrusEngine;
	import org.osflash.signals.Signal;
	import starling.display.Stage;
	import test2.constants.ScreenConst;
	import test2.data.MapData;
	import test2.data.PlayerData;
	import test2.state.MatchState;
	import test2.state.MenuState;
	import test2.ui.screen.CurtainScreen;
	import test2.ui.screen.DeveloperScreen;
	import test2.ui.screen.DoubleScreen;
	import test2.ui.screen.GameOverScreen;
	import test2.ui.screen.GameWinScreen;
	import test2.ui.screen.LogoScreen;
	import test2.ui.screen.MatchScreen;
	import test2.ui.screen.Screen;
	import test2.ui.screen.SetKeyScreen;
	import test2.ui.screen.ShopScreen;
	import test2.ui.screen.SingleScreen;
	import test2.ui.screen.StartScreen;
	/**
	 * ...
	 * @author ...
	 */
	public class ScreenController
	{
		public var playerData1:PlayerData;
		public var playerData2:PlayerData;
		public var mapData:MapData;
		
		private static var _instance:ScreenController;
		
		public static var firstOpenGame:Boolean = true;
		
		public static var firstOpenMatch:Boolean = true;
		
		public static var gameMode:int = 1;
		
		private var _ce:CitrusEngine;
		
		private var _signals:Vector.<Vector.<Signal>>;
		
		private var _screenMax:int = -1;
		private var _signalMax:Vector.<int> = new <int>[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
		private var screen:Screen;
		private var _singleScreen:SingleScreen;
		private var _doubleScreen:DoubleScreen;
		private var _curtainScreen:CurtainScreen;
		private var _startScreen:StartScreen;
		private var _setKeyScreen:SetKeyScreen;
		
		public var onLogoScreenOver:Signal;
		
		public function ScreenController() 
		{
			_signals = new Vector.<Vector.<Signal>>;
			_ce = CitrusEngine.getInstance();
		}
		
		public static function getInstance():ScreenController {
			
			if (!_instance)
				_instance = new ScreenController();
				
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
				case ScreenConst.LOGO_SCREEN:
					switch(signalID)
					{
						case ScreenConst.SCREEN_OUT:
							_startScreen = new StartScreen();
							(_ce.state as MenuState).addChild(_startScreen);
							_startScreen.inOnCompleteEffect = (value as LogoScreen).destroy;
							break;
					}
					break;
				case ScreenConst.START_SCREEN:
					switch(signalID)
					{
						case ScreenConst.SINGLE_BUTTON_CLICK:
							_singleScreen = new SingleScreen();
							(_ce.state as MenuState).addChild(_singleScreen);
							_singleScreen.inOnCompleteEffect = (value as StartScreen).destroy;
							//(value as StartScreen).destroy();
							//_ce.state = new MatchState();
							break;
						case ScreenConst.DOUBLE_BUTTON_CLICK:
							_doubleScreen = new DoubleScreen();
							(_ce.state as MenuState).addChild(_doubleScreen);
							_doubleScreen.inOnCompleteEffect = (value as StartScreen).destroy;
							break;
						case ScreenConst.SET_BUTTON_CLICK:
							(_ce.state as MenuState).addChild(new SetKeyScreen());
							break;
						case ScreenConst.SHOP_BUTTON_CLICK:
							(_ce.state as MenuState).addChild(new ShopScreen());
							break;
						case ScreenConst.DEVELOPER_BUTTON_CLICK:
							(_ce.state as MenuState).addChild(new DeveloperScreen());
							break;
					}
					break;
				case ScreenConst.SINGLE_SCREEN:
					switch(signalID)
					{
						case ScreenConst.PLAY_BUTTON_CLICK:
							gameMode = 1;
							_curtainScreen = new CurtainScreen();
							(value as SingleScreen).stage.addChild(_curtainScreen);								
							break;
						case ScreenConst.BACK_BUTTON_CLICK:
							_startScreen = new StartScreen();
							(_ce.state as MenuState).addChild(_startScreen);
							_startScreen.inOnCompleteEffect = (value as SingleScreen).destroy;
							break;
						case ScreenConst.SHOP_BUTTON_CLICK:
							(_ce.state as MenuState).addChild(new ShopScreen());
							break;
					}
					break;
				case ScreenConst.DOUBLE_SCREEN:
					switch(signalID)
					{
						case ScreenConst.PLAY_BUTTON_CLICK:
							gameMode = 2;
							_curtainScreen = new CurtainScreen();
							(value as DoubleScreen).stage.addChild(_curtainScreen);						
							break;
						case ScreenConst.BACK_BUTTON_CLICK:
							_startScreen = new StartScreen();
							(_ce.state as MenuState).addChild(_startScreen);
							_startScreen.inOnCompleteEffect = (value as DoubleScreen).destroy;
							break;
						case ScreenConst.SHOP_BUTTON_CLICK:
							(_ce.state as MenuState).addChild(new ShopScreen());
							break;
					}
					break;
					
				case ScreenConst.MATCH_SCREEN:
					switch(signalID)
					{
						case ScreenConst.PLAY_BUTTON_CLICK:
							
							break;
						case ScreenConst.BACK_BUTTON_CLICK:
							_ce.state = new MenuState();
							if (gameMode == 1)
							{
								_startScreen = new StartScreen();
								(_ce.state as MenuState).addChild(_startScreen);
							}
							else if (gameMode == 2)
							{
								_doubleScreen = new DoubleScreen();
								(_ce.state as MenuState).addChild(_doubleScreen);
							}
							break;
						case ScreenConst.SET_BUTTON_CLICK:
							_setKeyScreen = new SetKeyScreen();
							(_ce.state as MatchState).stage.addChild(_setKeyScreen);
							break;
						case ScreenConst.REWARD_OVER:
							_curtainScreen = new CurtainScreen();
							(value as Stage).addChild(_curtainScreen);
							break;
						case ScreenConst.ANOTHERGAME:
							
					}
					break;
				case ScreenConst.SHOP_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							(value as ShopScreen).destroy();
							if (_singleScreen)
							{
								_singleScreen.renderSelectBoard();
							}
							if (_doubleScreen)
							{
								_doubleScreen.renderSelectBoard();
							}
							break;
							
					}
					break;
					
				case ScreenConst.SETKEY_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							(value as SetKeyScreen).destroy();
							break;
					}
					break;
					
				case ScreenConst.DEVELOPER_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							(value as DeveloperScreen).destroy();
							break;
					}
					break;
					
				case ScreenConst.GAMEOVER_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							_ce.state = new MenuState();
							(value as GameOverScreen).destroy();
							_singleScreen = new SingleScreen();
							(_ce.state as MenuState).addChild(_singleScreen);
							break;
						case ScreenConst.SCREEN_IN:
							
							break;
					}
					break;
					
				case ScreenConst.GAMEWIN_SCREEN:
					switch(signalID)
					{
						case ScreenConst.BACK_BUTTON_CLICK:
							_ce.state = new MenuState();
							(value as GameWinScreen).destroy();
							_startScreen = new StartScreen();
							(_ce.state as MenuState).addChild(_startScreen);
							break;
						case ScreenConst.SCREEN_IN:
							
							break;
					}
					break;
					
				case ScreenConst.CURTAIN_SCREEN:
					switch(signalID)
					{
						case ScreenConst.SCREEN_CLOSED:
							if (_ce.state is MenuState)
							{
								_ce.state = new MatchState();						
							}
							else if (_ce.state is MatchState)
							{
								_ce.state = new MenuState();
								if (gameMode == 1)
								{
									_singleScreen = new SingleScreen();
									(_ce.state as MenuState).addChild(_singleScreen);
								}
								else if (gameMode == 2)
								{
									_doubleScreen = new DoubleScreen();
									(_ce.state as MenuState).addChild(_doubleScreen);
								}
								break;
							}
							break;
							
					}
					break;
					
			}
		}
		
	}

}