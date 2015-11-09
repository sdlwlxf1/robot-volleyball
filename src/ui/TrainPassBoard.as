package ui 
{
	import flash.filters.GlowFilter;
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
	public class TrainPassBoard extends Sprite 
	{
		
		private var _replayButton:SimpleButton;
		
		private var _backButton:SimpleButton;
		
		public var replaySignal:Signal;
		
		public var backSignal:Signal;

		public var chartsSignal:Signal;
		
		private var _background:DisplayObject;
		private var _textField:TextField;
		private var _textBounds:Rectangle;
		private var _returnButton:SimpleButton;
		private var _chartsButton:SimpleButton;
		
		
		
		public function TrainPassBoard()
		{
			super();
			replaySignal = new Signal();
			backSignal = new Signal();
			chartsSignal = new Signal();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			
			
			var quad:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0XFFFFFF);	
			quad.alpha = 0;
			addChild(quad);
			
			// the blur filter handles also drop shadow and glow
			var blur:BlurFilter = new BlurFilter();
			var dropShadow:BlurFilter = BlurFilter.createDropShadow(0, 0.9, 0x0, 1, 0.1);
			/*var glow:BlurFilter = BlurFilter.createGlow(0x000000, 2, 1);
			glow.blurX = 2;
			glow.blurY = 2;*/
			//glow.
			
			//new GlowFilter(0x00ff00, 1, 2, 2)
			//new GlowFilter(

			// to use a filter, just set it to the "filter" property
			
			
			//var fontMessage:Font = Fonts.getFont("smooth");
			
			
			_background = new Quad(stage.stageWidth / 2, stage.stageHeight / 2, 0X2DB6F0);
			_background.alpha = 0.5;			
			_background.pivotX = _background.width >> 1;
			_background.pivotY = _background.height >> 1;			
			_background.x = stage.stageWidth >> 1;
			_background.y = stage.stageHeight >> 1;			
			addChild(_background);
			
			var fontStyle1:Font = new Font("黑体", 28, 0XF6F6F6);
			
			//_background.filter = glow;
			
			/*
			_background = new Image(Assets.getTexture("messageBackground"));//new Quad(400, 300, 0X3840C5);
			_background.pivotX = _background.width >> 1;
			_background.pivotY = _background.height >> 1;
			_background.x = stage.stageWidth >> 1;
			_background.y = stage.stageHeight >> 1;
			addChild(_background);*/
			
			_textBounds = new Rectangle(_background.x + 5, _background.y + 5, _background.width - 10, _background.height - 10);
			
			
			_chartsButton = new SimpleButton(Texture.fromColor(130, 40, 0x00000000), "提交积分");
			_chartsButton.fontColor = fontStyle1.fontColor;
			_chartsButton.fontName = fontStyle1.fontName;
			_chartsButton.fontSize = fontStyle1.fontSize;
			_chartsButton.pivotX = _chartsButton.width >> 1;
			_chartsButton.pivotY = _chartsButton.height >> 1;
			_chartsButton.x = (stage.stageWidth >> 1);
			_chartsButton.y = _background.y + 20;
			
			addChild(_chartsButton);
			_chartsButton.addEventListener(Event.TRIGGERED, chartsButtonClick);
			
			_chartsButton.filter = dropShadow;
			
			_replayButton = new SimpleButton(Texture.fromColor(130, 40, 0x00000000), "重新比赛");
			_replayButton.fontColor = fontStyle1.fontColor;
			_replayButton.fontName = fontStyle1.fontName;
			_replayButton.fontSize = fontStyle1.fontSize;
			_replayButton.pivotX = _replayButton.width >> 1;
			_replayButton.pivotY = _replayButton.height >> 1;
			_replayButton.x = (stage.stageWidth >> 1);
			_replayButton.y = _background.y + 60;
			
			addChild(_replayButton);
			_replayButton.addEventListener(Event.TRIGGERED, replayButtonClick);
			
			_replayButton.filter = dropShadow;
			
			
			
			
			_backButton = new SimpleButton(Texture.fromColor(130, 40, 0x00000000), "退出游戏");
			_backButton.fontColor = fontStyle1.fontColor;
			_backButton.fontName = fontStyle1.fontName;
			_backButton.fontSize = fontStyle1.fontSize;
			_backButton.pivotX = _backButton.width >> 1;
			_backButton.pivotY = _backButton.height >> 1;
			_backButton.x = (stage.stageWidth >> 1);
			_backButton.y = _background.y + 100;
			
			addChild(_backButton);
			_backButton.addEventListener(Event.TRIGGERED, backButtonClick);
			
			_backButton.filter = dropShadow;
			
			_textField = new TextField(_textBounds.width, _textBounds.height, "");
			_textField.x = _textBounds.x;
			_textField.y = _textBounds.y - 60;
			_textField.pivotX = _textField.width >> 1;
			_textField.pivotY = _textField.height >> 1;
			_textField.vAlign = VAlign.CENTER;
			_textField.hAlign = HAlign.CENTER;
			_textField.touchable = false;
			_textField.autoScale = true;
			_textField.color = fontStyle1.fontColor;
			_textField.fontName = fontStyle1.fontName;
			_textField.fontSize = 26;
			addChild(_textField);
			
			_textField.filter = dropShadow;
			
		}
		
		
		public function checkScore(score:Number):void 
		{
			var comment:String;
			var lastComment:String;
			/*if (score < 50000)
			{
				comment = "成绩一般！\n";
			}
			else if (score < 100000)
			{
				comment = "成绩不错！\n";
			}*/
			
			
			lastComment = /*comment + */"共获得了" + String(score) + "积分,\n赶快提交积分参加排行吧。";
			_textField.text = lastComment;
			
		}
		
		private function chartsButtonClick(e:Event):void 
		{
			chartsSignal.dispatch();
		}
		
		private function backButtonClick(e:Event):void 
		{			
			backSignal.dispatch();
			//destroy();
		}

		
		private function replayButtonClick(e:Event):void 
		{
			replaySignal.dispatch();
			//destroy();
		}
		
		public function destroy():void
		{
			this.removeFromParent(true);
		}
		
			
		
	}

}