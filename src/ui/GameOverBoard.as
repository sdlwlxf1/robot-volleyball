package ui 
{
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.Assets;
	import assets.Fonts;
	import customObjects.Font;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class GameOverBoard extends Sprite 
	{
		
		private var _replayButton:SimpleButton;
		
		private var _nextButton:SimpleButton;
		
		public var replaySignal:Signal;
		
		public var nextSignal:Signal;
		
		private var _background:DisplayObject;
		private var _textField:TextField;
		private var _textBounds:Rectangle;
		
		public function GameOverBoard()
		{
			super();
			replaySignal = new Signal();
			nextSignal = new Signal();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var quad:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0X3C3C3E);
			quad.alpha = 0.5;
			
			addChild(quad);
			
			// the blur filter handles also drop shadow and glow
			var blur:BlurFilter = new BlurFilter();
			var dropShadow:BlurFilter = BlurFilter.createDropShadow();
			var glow:BlurFilter = BlurFilter.createGlow();

			// to use a filter, just set it to the "filter" property
			quad.filter = blur;
			
			
			var fontMessage:Font = Fonts.getFont("smooth");
			
			_background = new Image(Assets.getTexture("messageBackground"));//new Quad(400, 300, 0X3840C5);
			_background.pivotX = _background.width >> 1;
			_background.pivotY = _background.height >> 1;
			_background.x = stage.stageWidth >> 1;
			_background.y = stage.stageHeight >> 1;
			addChild(_background);
		
			_nextButton = new SimpleButton(Texture.fromColor(130, 40, 0x00000000), "继续游戏");
			_nextButton.fontColor = fontMessage.fontColor;
			_nextButton.fontName = fontMessage.fontName;
			_nextButton.fontSize = fontMessage.fontSize;
			_nextButton.pivotX = _nextButton.width >> 1;
			_nextButton.pivotY = _nextButton.height >> 1;
			_nextButton.x = (stage.stageWidth >> 1);
			_nextButton.y = _background.y - 30;
			
			addChild(_nextButton);
			_nextButton.addEventListener(Event.TRIGGERED, nextButtonClick);
			
			
			_replayButton = new SimpleButton(Texture.fromColor(130, 40, 0x00000000), "重新比赛");
			_replayButton.fontColor = fontMessage.fontColor;
			_replayButton.fontName = fontMessage.fontName;
			_replayButton.fontSize = fontMessage.fontSize;
			_replayButton.pivotX = _replayButton.width >> 1;
			_replayButton.pivotY = _replayButton.height >> 1;
			_replayButton.x = _nextButton.x;
			_replayButton.y = _background.y + 30;
			
			addChild(_replayButton);
			_replayButton.addEventListener(Event.TRIGGERED, replayButtonClick);
			
		}
		
		private function nextButtonClick(e:Event):void 
		{			
			nextSignal.dispatch();
			destroy();
		}
		
		private function replayButtonClick(e:Event):void 
		{
			replaySignal.dispatch();
			destroy();
		}
		
		public function destroy():void
		{
			this.removeFromParent(true);
		}
		
			
		
	}

}