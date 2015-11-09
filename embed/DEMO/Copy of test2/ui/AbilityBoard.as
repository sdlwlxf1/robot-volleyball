package test2.ui 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.customObjects.Font;
	import test2.data.Ability;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class AbilityBoard extends Sprite 
	{
		
		private var _ability:Ability;
		
		private var _textWidth:Number = 54;
		
		private var _textHeight:Number = 30;
		
		private var _textField1:TextField;
		private var _textField2:TextField;
		private var _textField3:TextField;
		private var _textField4:TextField;
		
		
		private var _accumulator1:Accumulator;
		private var _accumulator2:Accumulator;
		private var _accumulator3:Accumulator;
		private var _accumulator4:Accumulator;
		public var background:Image;
		
		public function AbilityBoard() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var fontMessage:Font = Fonts.getFont("smooth");
			
			background = new Image(Assets.getTexture("abilityBackground"));
			addChild(background);
			
			_textField1 = new TextField(_textWidth, _textHeight, "速度");
			_textField1.x = -_textField1.width;
			_textField1.y = 0;
			_textField1.vAlign = VAlign.CENTER;
			_textField1.hAlign = HAlign.CENTER;
			_textField1.touchable = false;
			_textField1.autoScale = true;
			_textField1.color = fontMessage.fontColor;
			_textField1.fontName = fontMessage.fontName;
			_textField1.fontSize = fontMessage.fontSize - 10;
			addChild(_textField1);
			
			_textField2 = new TextField(_textWidth, _textHeight, "力量");
			_textField2.x = -_textField2.width;
			_textField2.y = _textField1.y + _textField1.height;
			_textField2.vAlign = VAlign.CENTER;
			_textField2.hAlign = HAlign.CENTER;
			_textField2.touchable = false;
			_textField2.autoScale = true;
			_textField2.color = fontMessage.fontColor;
			_textField2.fontName = fontMessage.fontName;
			_textField2.fontSize = fontMessage.fontSize - 10;
			addChild(_textField2);
			
			_textField3 = new TextField(_textWidth, _textHeight, "弹跳");
			_textField3.x = -_textField3.width;
			_textField3.y = _textField2.y + _textField2.height;;
			_textField3.vAlign = VAlign.CENTER;
			_textField3.hAlign = HAlign.CENTER;
			_textField3.touchable = false;
			_textField3.autoScale = true;
			_textField3.color = fontMessage.fontColor;
			_textField3.fontName = fontMessage.fontName;
			_textField3.fontSize = fontMessage.fontSize - 10;
			addChild(_textField3);
			
			_textField4 = new TextField(_textWidth, _textHeight, "敏捷");
			_textField4.x = -_textField4.width;
			_textField4.y = _textField3.y + _textField3.height;;
			_textField4.vAlign = VAlign.CENTER;
			_textField4.hAlign = HAlign.CENTER;
			_textField4.touchable = false;
			_textField4.autoScale = true;
			_textField4.color = fontMessage.fontColor;
			_textField4.fontName = fontMessage.fontName;
			_textField4.fontSize = fontMessage.fontSize - 10;
			addChild(_textField4);
			
			_accumulator1 = new Accumulator(10, 100);
			_accumulator1.x = 0;
			_accumulator1.y = _textField1.y + (_textField1.height >> 1);
			_accumulator1.rotation = Math.PI / 2;
			addChild(_accumulator1);
			
			_accumulator2 = new Accumulator(10, 100);
			_accumulator2.x = 0;
			_accumulator2.y = _textField2.y + (_textField2.height >> 1);
			_accumulator2.rotation = Math.PI / 2;
			addChild(_accumulator2);
			
			_accumulator3 = new Accumulator(10, 100);
			_accumulator3.x = 0;
			_accumulator3.y = _textField3.y + (_textField3.height >> 1);
			_accumulator3.rotation = Math.PI / 2;
			addChild(_accumulator3);
			
			_accumulator4 = new Accumulator(10, 100);
			_accumulator4.x = 0;
			_accumulator4.y = _textField4.y + (_textField4.height >> 1);
			_accumulator4.rotation = Math.PI / 2;
			addChild(_accumulator4);
			
			background.x = -_textField1.width - 30;
			background.y = _textField1.y - 30;
			
			
		}
		
		public function setAbility(ability:Ability):void
		{
			_accumulator1.update(ability.move, 10);
			_accumulator2.update(ability.power, 10);
			_accumulator3.update(ability.jump, 10);
			_accumulator4.update(ability.quick, 10);
		}
		
		
		
	}

}