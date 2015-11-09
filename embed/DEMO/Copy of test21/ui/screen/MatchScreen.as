package test2.ui.screen 
{
	import citrus.core.CitrusEngine;
	import org.osflash.signals.Signal;
	import starling.display.Button;
	import starling.events.Event;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.constants.ScreenConst;
	import test2.customObjects.Font;
	import test2.data.UserData;
	import test2.logic.gameLogic.LevelController;
	import test2.logic.gameLogic.ScreenController;
	import test2.ui.customTween.InOutTweens;
	import test2.ui.HUD;
	import test2.ui.PauseButton;
	import test2.ui.SimpleButton;
	import test2.ui.SimpleWindows;
	/**
	 * ...
	 * @author ...
	 */
	public class MatchScreen extends Screen 
	{
		
		private var _hud:HUD;
		private var _pauseButton:SimpleButton;
		private var _startButton:SimpleButton;
		private var _backButton:SimpleButton;
		private var _setButton:SimpleButton;
		private var _pauseButton1:SimpleButton;
		private var _pauseButton2:SimpleButton;
		
		public var onBegin:Signal;
		
		public function MatchScreen() 
		{
			super();
			onBegin = new Signal();			
		}
		
		override protected function initInOutTweens():void 
		{
			//super.initInOutTweens();
			_inOutTweens = new InOutTweens(this, null, null);
			_inOutTweens.inOnComplete = inOnComplete;
			_inOutTweens.outOnComplete = outOnComplete;
		}
		
		override protected function inOnComplete():void 
		{
			super.inOnComplete();
			UserData.getInstance().saveData();

		}
		
		override protected function initScreens():void 
		{
			//super.initScreens();
			_hud = new HUD();
			addChild(_hud);
			
			
			
			var fontMessage:Font = Fonts.getFont("smooth");
			
			
			// Start button.
			_startButton = new SimpleButton(Assets.getTexture("matchBegin"));
			_startButton.fontColor = fontMessage.fontColor;
			_startButton.fontName = fontMessage.fontName;
			_startButton.fontSize = fontMessage.fontSize;
			_startButton.x = stage.stageWidth / 2 - _startButton.width / 2;
			_startButton.y = stage.stageHeight / 2 - _startButton.height / 2;
			_startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
			//addChild(_startButton);
			
			
			_backButton = new SimpleButton(Assets.getTexture("iconClose"), "", Assets.getTexture("iconCloseOver"), Assets.getTexture("iconCloseOver"));
			_backButton.x = stage.stageWidth - _backButton.width - 5;
			_backButton.y = 5;
			addChild(_backButton);
			_backButton.addEventListener(Event.TRIGGERED, backButtonClick);
			
			_setButton = new SimpleButton(Assets.getTexture("iconWrench"), "", Assets.getTexture("iconWrenchOver"), Assets.getTexture("iconWrenchOver"));
			_setButton.x = _backButton.x - _setButton.width - 10;
			_setButton.y = 5;
			addChild(_setButton);
			
			_setButton.addEventListener(Event.TRIGGERED, setButtonClick);
			
			// Pause button.
			
			_pauseButton1 = new SimpleButton(Assets.getTexture("iconPause"), "", Assets.getTexture("iconPauseOver"), Assets.getTexture("iconPauseOver"));
			_pauseButton1.x = _setButton.x - _pauseButton1.width - 10;
			_pauseButton1.y = 5;
			_pauseButton1.addEventListener(Event.TRIGGERED, onPauseButtonClick);
			
			_pauseButton2 = new SimpleButton(Assets.getTexture("iconPlay"), "", Assets.getTexture("iconPlayOver"), Assets.getTexture("iconPlayOver"));
			_pauseButton2.x = _setButton.x - _pauseButton2.width - 10;
			_pauseButton2.y = 5;
			_pauseButton2.addEventListener(Event.TRIGGERED, onPauseButtonClick);
			
			addChild(_pauseButton1);
			addChild(_pauseButton2);
			
			
			if (CitrusEngine.getInstance().playing)
			{
				_pauseButton2.visible = false;
				_pauseButton1.visible = true;
			}
			else
			{
				_pauseButton2.visible = true;
				_pauseButton1.visible = false;
			}
		}
		
		private function setButtonClick(e:Event):void 
		{
			screenController.dispatchSignal(ScreenConst.MATCH_SCREEN, ScreenConst.SET_BUTTON_CLICK, this);
		}
		
		private function onStartButtonClick(e:Event):void 
		{
			onBegin.dispatch();
			_startButton.removeEventListener(Event.TRIGGERED, onStartButtonClick);
			screenController.dispatchSignal(ScreenConst.MATCH_SCREEN, ScreenConst.PLAY_BUTTON_CLICK, this)
			removeChild(_startButton, true);
		}
		
		private function backButtonClick(e:Event):void 
		{
			var simpleWindows:SimpleWindows = new SimpleWindows();
			addChild(simpleWindows);
			if (ScreenController.gameMode == 1)
			{
				simpleWindows.setText("确定要退出游戏吗？\n游戏进度丢失\n将从第一关开始。");
			}
			else if (ScreenController.gameMode == 2)
			{
				simpleWindows.setText("确定要退出游戏吗？");
			}
			simpleWindows.OKSignal.add(backOK);
			//simpleWindows.cancelSignal.add(buyCancel);		
		}
		
		private function backOK():void 
		{
			if (ScreenController.gameMode == 1)
			{
				LevelController.getInstance().goToLevel(0);
			}
			screenController.dispatchSignal(ScreenConst.MATCH_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
		private function onPauseButtonClick(e:Event):void
		{
			CitrusEngine.getInstance().playing = CitrusEngine.getInstance().playing ? false : true;
			
			if (CitrusEngine.getInstance().playing)
			{
				_pauseButton2.visible = false;
				_pauseButton1.visible = true;
			}
			else
			{
				_pauseButton2.visible = true;
				_pauseButton1.visible = false;
			}
		}
		
		public function get hud():HUD 
		{
			return _hud;
		}
		
	}

}