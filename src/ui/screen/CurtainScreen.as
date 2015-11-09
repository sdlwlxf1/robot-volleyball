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
	public class CurtainScreen extends Screen 
	{
		private var _curtainLeft:DisplayObject;
		private var _curtainRight:DisplayObject;
		private var _tweenLeft:Tween;
		private var _tweenRight:Tween;
		
		public function CurtainScreen() 
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
			
			//_curtainLeft = new Quad(stage.stageWidth / 2, stage.stageHeight, 0X0E243A);
			
			_curtainLeft = new Image(Assets.getTexture("close1"));			
			
			_curtainLeft.pivotX = _curtainLeft.width;
			
			_curtainLeft.width = stage.stageWidth / 2;
			
			_curtainLeft.height = stage.stageHeight;
			
			
			
			//_curtainRight = new Quad(stage.stageWidth / 2, stage.stageHeight, 0X0E243A);
			
			_curtainRight = new Image(Assets.getTexture("close2"));
			
			_curtainRight.pivotX = 0;
			
			_curtainRight.width = stage.stageWidth / 2;
			
			_curtainRight.height = stage.stageHeight;		
			
			_curtainRight.x = stage.stageWidth;
			
			addChild(_curtainLeft);
			addChild(_curtainRight);
			
			_tweenLeft = new Tween(_curtainLeft, 1);
			_tweenRight = new Tween(_curtainRight, 1);
			
			_tweenLeft.moveTo(stage.stageWidth / 2, 0);
			_tweenRight.moveTo(stage.stageWidth / 2, 0);
			
			_tweenLeft.transition = Transitions.EASE_IN_OUT;
			_tweenRight.transition = Transitions.EASE_IN_OUT;
			
			_tweenLeft.onComplete = closeComplete;
			
			Starling.juggler.add(_tweenLeft);
			
			Starling.juggler.add(_tweenRight);
			
			_ce.sound.playSound("menu_entercompeteclose");
			
		}
		
		private function closeComplete():void 
		{
			screenController.dispatchSignal(ScreenConst.CURTAIN_SCREEN, ScreenConst.SCREEN_CLOSED, this);
			setTimeout(startOpen, 1000);
		}
		
		private function startOpen():void 
		{
			_tweenLeft = new Tween(_curtainLeft, 1);
			_tweenRight = new Tween(_curtainRight, 1);
			
			_tweenLeft.transition = Transitions.EASE_IN;
			_tweenRight.transition = Transitions.EASE_IN;
			
			_tweenLeft.moveTo(0, 0);
			_tweenRight.moveTo(stage.stageWidth, 0);
			
			_tweenLeft.onComplete = openComplete;
			
			Starling.juggler.add(_tweenLeft);
			
			Starling.juggler.add(_tweenRight);
			
			_ce.sound.playSound("menu_entercompeteopen");
		}
		
		private function openComplete():void 
		{
			destroy();
						
			if (UserData.getInstance().firstOpenMatch)
			{
				screenController.dispatchSignal(ScreenConst.MATCH_SCREEN, ScreenConst.SET_BUTTON_CLICK, this);
				UserData.getInstance().firstOpenMatch = false;
			}
		}
		
	}

}