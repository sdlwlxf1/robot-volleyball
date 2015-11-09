package test2.ui 
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
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.customObjects.Font;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class SimpleWindows extends Sprite 
	{
		
		private var _OKButton:SimpleButton;
		
		private var _cancelButton:SimpleButton;
		
		public var OKSignal:Signal;
		
		public var cancelSignal:Signal;
		
		private var _background:DisplayObject;
		private var _textField:TextField;
		private var _textBounds:Rectangle;
		
		public function SimpleWindows() 
		{
			super();
			OKSignal = new Signal();
			cancelSignal = new Signal();
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
			
			_textBounds = new Rectangle(_background.x + 5, _background.y + 5, _background.width - 10, _background.height - 10);
			
			_OKButton = new SimpleButton(Texture.fromColor(130, 40, 0x00000000), "确定");
			_OKButton.fontColor = fontMessage.fontColor;
			_OKButton.fontName = fontMessage.fontName;
			_OKButton.fontSize = fontMessage.fontSize;
			//_OKButton.pivotX = _OKButton.width >> 1;
			//_OKButton.pivotX = _OKButton.height >> 1;
			_OKButton.x = (stage.stageWidth >> 1) - (_OKButton.width) - 20;
			_OKButton.y = _background.y + (_background.height >> 1) - (_OKButton.height) - 30;
			
			addChild(_OKButton);
			_OKButton.addEventListener(Event.TRIGGERED, OKButtonClick);
			
			
			_cancelButton = new SimpleButton(Texture.fromColor(130, 40, 0x00000000), "取消");
			_cancelButton.fontColor = fontMessage.fontColor;
			_cancelButton.fontName = fontMessage.fontName;
			_cancelButton.fontSize = fontMessage.fontSize;
			//_cancelButton.pivotX = _cancelButton.width >> 1;
			//_cancelButton.pivotY = _cancelButton.height >> 1;
			_cancelButton.x = (stage.stageWidth >> 1) + 20;
			_cancelButton.y = _OKButton.y;
			
			addChild(_cancelButton);
			_cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			
			_textField = new TextField(_textBounds.width, _textBounds.height, "");
			_textField.x = _textBounds.x;
			_textField.y = _textBounds.y - 10;
			_textField.pivotX = _textField.width >> 1;
			_textField.pivotY = _textField.height >> 1;
			_textField.vAlign = VAlign.CENTER;
			_textField.hAlign = HAlign.CENTER;
			_textField.touchable = false;
			_textField.autoScale = true;
			_textField.color = fontMessage.fontColor;
			_textField.fontName = fontMessage.fontName;
			_textField.fontSize = fontMessage.fontSize;
			addChild(_textField);
			
		}
		
		public function setText(text:String):void
		{
			_textField.text = text;
		}
		
		private function cancelButtonClick(e:Event):void 
		{			
			cancelSignal.dispatch();
			destroy();
		}
		
		private function OKButtonClick(e:Event):void 
		{
			OKSignal.dispatch();
			destroy();
		}
		
		public function destroy():void
		{
			this.removeFromParent(true);
		}
		
			
		
	}

}