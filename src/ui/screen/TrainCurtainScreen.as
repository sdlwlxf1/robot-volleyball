package ui.screen 
{
	import flash.utils.setTimeout;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import assets.Assets;
	import constants.ScreenConst;
	import data.UserData;
	import ui.customTween.InOutTweens;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class TrainCurtainScreen extends TrainScreen 
	{
		private var _curtainUp:DisplayObject;
		private var _curtainDown:DisplayObject;
		private var _tweenUp:Tween;
		private var _tweenDown:Tween;
		
		public function TrainCurtainScreen() 
		{
			super();
			
		}
		
		override protected function initInOutTweens():void 
		{
			//super.initInOutTweens();
			_inOutTweens = new InOutTweens(this, null, null);
			_inOutTweens.inOnComplete = inOnComplete;
			_inOutTweens.outOnComplete = outOnComplete;
		}
		
		override protected function initScreens():void 
		{
			//super.initScreens();
			
			//_curtainUp = new Quad(stage.stageWidth / 2, stage.stageHeight, 0X0E243A);
			
			_curtainUp = new Image(Assets.getTexture("close1"));			
			
			_curtainUp.pivotY = _curtainUp.height;
			
			_curtainUp.width = stage.stageWidth;
			
			_curtainUp.height = stage.stageHeight / 2;
			
			
			
			//_curtainDown = new Quad(stage.stageWidth / 2, stage.stageHeight, 0X0E243A);
			
			_curtainDown = new Image(Assets.getTexture("close2"));
			
			_curtainDown.pivotY = 0;
			
			_curtainDown.width = stage.stageWidth;
			
			_curtainDown.height = stage.stageHeight / 2;		
			
			_curtainDown.y = stage.stageHeight;
			
			addChild(_curtainUp);
			addChild(_curtainDown);
			
			_tweenUp = new Tween(_curtainUp, 1);
			_tweenDown = new Tween(_curtainDown, 1);
			
			_tweenUp.moveTo(0, stage.stageHeight / 2)
			_tweenDown.moveTo(0, stage.stageHeight / 2);
			
			_tweenUp.transition = Transitions.EASE_IN_OUT;
			_tweenDown.transition = Transitions.EASE_IN_OUT;
			
			_tweenUp.onComplete = closeComplete;
			
			Starling.juggler.add(_tweenUp);
			
			Starling.juggler.add(_tweenDown);
			
			_ce.sound.playSound("menu_entercompeteclose");
			
		}
		
		private function closeComplete():void 
		{
			screenController.dispatchSignal(ScreenConst.TRAIN_CURTAIN_SCREEN, ScreenConst.SCREEN_CLOSED, this);
			setTimeout(startOpen, 1000);
		}
		
		private function startOpen():void 
		{
			_tweenUp = new Tween(_curtainUp, 1);
			_tweenDown = new Tween(_curtainDown, 1);
			
			_tweenUp.transition = Transitions.EASE_IN;
			_tweenDown.transition = Transitions.EASE_IN;
			
			_tweenUp.moveTo(0, 0);
			_tweenDown.moveTo(0, stage.stageHeight);
			
			_tweenUp.onComplete = openComplete;
			
			Starling.juggler.add(_tweenUp);
			
			Starling.juggler.add(_tweenDown);
			
			_ce.sound.playSound("menu_entercompeteopen");
		}
		
		private function openComplete():void 
		{
			destroy();
						
			if (UserData.getInstance().firstOpenMatch)
			{
				screenController.dispatchSignal(ScreenConst.TRAIN_SMASH_BALL_SCREEN, ScreenConst.SET_BUTTON_CLICK, this);
				UserData.getInstance().firstOpenMatch = false;
			}
		}
		
	}

}