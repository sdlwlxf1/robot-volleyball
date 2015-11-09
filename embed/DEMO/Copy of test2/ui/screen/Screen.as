package test2.ui.screen 
{
	import citrus.core.CitrusEngine;
	import flash.utils.Dictionary;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import test2.assets.Assets;
	import test2.logic.gameLogic.ScreenController;
	import test2.state.MatchState;
	import test2.ui.customTween.InBound;
	import test2.ui.customTween.InFade;
	import test2.ui.customTween.InOutTweens;
	import test2.ui.customTween.OutFade;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Screen extends Sprite 
	{
		private var _shadeLayer:Image;
		
		public var inOnCompleteEffect:Function;
		public var outOnCompleteEffect:Function;
		
		protected var _background:DisplayObject;
		
		protected var _addedToStage:Boolean;
		
		protected var _screenController:ScreenController;
		
		protected var _inOutTweens:InOutTweens;
		
		public function Screen() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On Game class added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_addedToStage = true;
			
			_screenController = ScreenController.getInstance();
			
			_shadeLayer = new Image(Texture.fromColor(stage.stageWidth, stage.stageHeight, 0x00000000));
			
			parent.addChildAt(_shadeLayer, parent.getChildIndex(this))
			
			initInOutTweens();
			
			// Initialize screens.
			initScreens();
			_inOutTweens.startIn();		
		}	
		
		protected function initInOutTweens():void
		{
			_inOutTweens = new InOutTweens(this, InBound, null);
			_inOutTweens.inOnComplete = inOnComplete;
			_inOutTweens.outOnComplete = outOnComplete;
		}
		
		protected function initScreens():void 
		{

			//_background = new Quad(stage.stageWidth, stage.stageHeight, 0X9D9EA2);
			_background = new Image(Assets.getTexture("UIbackground"));
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			addChild(_background);
		}
		
		protected function inOnComplete():void 
		{
			if (inOnCompleteEffect != null)
			{
				inOnCompleteEffect.apply();
			}
		}
		
		public function destroy():void
		{			
			if (_addedToStage = true)
			{
				_inOutTweens.startOut();
				_addedToStage = false;
			}
		}
		
		protected function outOnComplete():void 
		{
			parent.removeChild(_shadeLayer, true);
			removeFromParent(true);
			
			if (outOnCompleteEffect != null)
			{
				outOnCompleteEffect.apply();
			}
		}
		
		public function get screenController():ScreenController 
		{
			return _screenController;
		}

		
	}

}