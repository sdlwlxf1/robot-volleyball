package ui.screen 
{
	import aze.motion.EazeTween;
	import citrus.core.CitrusEngine;
	import flash.media.SoundMixer;
	import logics.gameLogic.TrainSmashBall;
	import org.osflash.signals.Signal;
	import starling.display.Button;
	import starling.events.Event;
	import assets.Assets;
	import assets.Fonts;
	import constants.ScreenConst;
	import customObjects.Font;
	import data.UserData;
	import logics.gameLogic.LevelController;
	import logics.gameLogic.ScreenController;
	import logics.gameLogic.TrainLevelController;
	import state.TrainSmashBallState;
	import ui.customTween.InOutTweens;
	import ui.PauseBoard;
	import ui.PauseButton;
	import ui.SimpleButton;
	import ui.SimpleWindows;
	import ui.TrainOverBoard;
	import ui.TrainPassBoard;
	import ui.TrainSmashBallHUD;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrainSmashBallScreen extends TrainScreen 
	{
		
		private var _pauseButton:SimpleButton;
		private var _startButton:SimpleButton;
		private var _backButton:SimpleButton;
		private var _setButton:SimpleButton;
		private var _pauseButton1:SimpleButton;
		private var _pauseButton2:SimpleButton;
		private var _hud:TrainSmashBallHUD;
		private var _pauseBoard:PauseBoard;
		private var _pauseBoardAdded:Boolean = false;
		private var _simpleWindows:SimpleWindows;
		private var _trainPassBoard:TrainPassBoard;
		private var _trainOverBoard:TrainOverBoard;
		private var _musicButton1:SimpleButton;
		private var _musicButton2:SimpleButton;
		
		public var trainSmashBallState:TrainSmashBallState;
		
		public var onBegin:Signal;
		
		public function TrainSmashBallScreen() 
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
			_hud = new TrainSmashBallHUD();
			addChild(_hud);
			
			
			
			var fontMessage:Font = Fonts.getFont("smooth");
			
			
			/*// Start button.
			_startButton = new SimpleButton(Assets.getTexture("matchBegin"));
			_startButton.fontColor = fontMessage.fontColor;
			_startButton.fontName = fontMessage.fontName;
			_startButton.fontSize = fontMessage.fontSize;
			_startButton.x = stage.stageWidth / 2 - _startButton.width / 2;
			_startButton.y = stage.stageHeight / 2 - _startButton.height / 2;
			_startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
			//addChild(_startButton);*/
			
			// Pause button.
			
			_pauseButton1 = new SimpleButton(Assets.getTexture("iconPause"), "", Assets.getTexture("iconPauseOver"), Assets.getTexture("iconPauseOver"));
			_pauseButton1.scaleX = 1;
			_pauseButton1.scaleY = 1;
			_pauseButton1.x = stage.stageWidth - _pauseButton1.width;
			_pauseButton1.y = 3;
			_pauseButton1.addEventListener(Event.TRIGGERED, onPauseButtonClick);		
			addChild(_pauseButton1);
			
			_pauseButton2 = new SimpleButton(Assets.getTexture("iconPlay"), "", Assets.getTexture("iconPlayOver"), Assets.getTexture("iconPlayOver"));
			_pauseButton2.scaleX = 1;
			_pauseButton2.scaleY = 1;
			_pauseButton2.x = stage.stageWidth - _pauseButton1.width;
			_pauseButton2.y = 3;
			_pauseButton2.addEventListener(Event.TRIGGERED, onPauseButtonClick);
			addChild(_pauseButton2);
			
			_musicButton1 = new SimpleButton(Assets.getTexture("iconMusic"), "", Assets.getTexture("iconMusicOver"), Assets.getTexture("iconMusicOver"));
			_musicButton1.scaleX = 1;
			_musicButton1.scaleY = 1;
			_musicButton1.x = _pauseButton1.x - _musicButton1.width - 5;
			_musicButton1.y = 3;
			_musicButton1.addEventListener(Event.TRIGGERED, onMusicButtonClick);
			addChild(_musicButton1);
			
			/*_musicButton2 = new SimpleButton(Assets.getTexture("iconBGMusic"), "", Assets.getTexture("iconBGMusicOver"), Assets.getTexture("iconBGMusicOver"));
			_musicButton2.scaleX = 1;
			_musicButton2.scaleY = 1;
			_musicButton2.x = _musicButton1.x - _musicButton2.width - 5;
			_musicButton2.y = 3;
			_musicButton2.addEventListener(Event.TRIGGERED, onBGMusicButtonClick);
			addChild(_musicButton2);*/
			
			
			
			
			
			
			
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
		
		/*private function onBGMusicButtonClick(e:Event):void 
		{			
			
		}*/
		
		private function onMusicButtonClick(e:Event):void 
		{
			//SoundMixer.soundTransform.volume ? _ce.sound.muteFlashSound() : _ce.sound.muteFlashSound(false);
			//_ce.sound.getSoundVolume("background1") ? _ce.sound.setVolume("background1", 0):_ce.sound.setVolume("background1", 1);
		}
		
		private function setButtonClick(e:Event):void 
		{
			screenController.dispatchSignal(ScreenConst.TRAIN_SMASH_BALL_SCREEN, ScreenConst.SET_BUTTON_CLICK, this);
		}
/*		
		private function onStartButtonClick(e:Event):void 
		{
			onBegin.dispatch();
			_startButton.removeEventListener(Event.TRIGGERED, onStartButtonClick);
			screenController.dispatchSignal(ScreenConst.TRAIN_SMASH_BALL_SCREEN, ScreenConst.PLAY_BUTTON_CLICK, this)
			removeChild(_startButton, true);
		}*/
		
		
		
		
		
		
		public function update():void 
		{
			if (CitrusEngine.getInstance().input.justDid("pause"))
			{				
				if (_pauseBoardAdded)
				{
					_pauseBoard.destroy();
					_pauseBoardAdded = false;
				}
				else
				{
					pauseBoardAdd();
				}
			}
			
			
		}
		
		private function pause():void
		{			
			CitrusEngine.getInstance().playing = false;
			//EazeTween.pauseAllTweens();
			_pauseButton2.visible = true;
			_pauseButton1.visible = false;
		}
		
		private function unPause():void
		{
			CitrusEngine.getInstance().playing = true;
			//EazeTween.resumeAllTweens();
			_pauseButton2.visible = false;
			_pauseButton1.visible = true;
		}
		
		private function onPauseButtonClick(e:Event):void
		{
			pauseBoardAdd();
			
		}
		
		private function pauseBoardAdd():void
		{
			if (trainSmashBallState.trainSmashBall.trainProcess == TrainSmashBall.TRAIN_ON)
			{
				pause();
				_pauseBoardAdded = true;
				_pauseBoard = new PauseBoard();
				addChild(_pauseBoard);
				_pauseBoard.replaySignal.add(anotherGame);
				_pauseBoard.backSignal.add(backToMenu);
				_pauseBoard.returnSignal.add(returnToGame);
				_pauseBoard.chartsSignal.add(showCharts);
			}
		}
	
		public function trainPassBoardAdd():void
		{
			//pause();
			_trainPassBoard = new TrainPassBoard();
			addChild(_trainPassBoard);
			_trainPassBoard.replaySignal.add(anotherGame);
			_trainPassBoard.backSignal.add(backToMenu);
			_trainPassBoard.chartsSignal.add(addDataToCharts);
			_trainPassBoard.checkScore(hud.newScore);
		}
		
		public function trainOverBoardAdd():void
		{
			//pause();
			_trainOverBoard = new TrainOverBoard();
			addChild(_trainOverBoard);
			_trainOverBoard.replaySignal.add(anotherGame);
			_trainOverBoard.backSignal.add(backToMenu);
			_trainOverBoard.chartsSignal.add(addDataToCharts);
			_trainOverBoard.checkScore(hud.newScore);
		}
		
		private function showCharts():void 
		{
			//addDataToCharts();
			//4.在要显示排行榜的地方加入以下代码，CMain为你的主文档类
			var _stageHold:* = Main.serviceHold;
			if(_stageHold){
				_stageHold.showSort();
			}

		}
		
		private function addDataToCharts():void 
		{		
			var _stageHold:* = Main.serviceHold;
			if(_stageHold){
				_stageHold.showRefer(int(hud.newScore)); //socre为你的分数变量，类型为int    
			}

		}
		
		
		
		private function anotherGame():void 
		{
			_simpleWindows = new SimpleWindows();
			addChild(_simpleWindows);

			_simpleWindows.setText("重新开始游戏吗？");

			_simpleWindows.OKSignal.add(anotherOK);
			//simpleWindows.cancelSignal.add(buyCancel);
		}
		
		private function anotherOK():void 
		{
			trainSmashBallState.anotherGame();
			
			unPause();
			
			if (_pauseBoard)
			{
				_pauseBoard.destroy();
				_pauseBoardAdded = false;
			}
			if (_trainOverBoard)
			{
				_trainOverBoard.destroy();
			}
			if (_trainPassBoard)
			{
				_trainPassBoard.destroy();
			}
		}
		
		private function backToMenu():void 
		{			
			_simpleWindows = new SimpleWindows();
			addChild(_simpleWindows);

			_simpleWindows.setText("确定要退出游戏吗？");

			_simpleWindows.OKSignal.add(backOK);
			//simpleWindows.cancelSignal.add(buyCancel);		
		}
		
		private function backOK():void 
		{
			screenController.dispatchSignal(ScreenConst.TRAIN_SMASH_BALL_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
			unPause();
			
			if (_pauseBoard)
			{
				_pauseBoard.destroy();
				_pauseBoardAdded = false;
			}
			if (_trainOverBoard)
			{
				_trainOverBoard.destroy();
			}
			if (_trainPassBoard)
			{
				_trainPassBoard.destroy();
			}
		}
		
		private function returnToGame():void 
		{
			hud.pauseReadyWait(unPause);
			
			
			if (_pauseBoard)
			{
				_pauseBoard.destroy();
				_pauseBoardAdded = false;
			}
			if (_trainOverBoard)
			{
				_trainOverBoard.destroy();
			}
			if (_trainPassBoard)
			{
				_trainPassBoard.destroy();
			}
		}
		
		public function get hud():TrainSmashBallHUD 
		{
			return _hud;
		}
		
	}

}