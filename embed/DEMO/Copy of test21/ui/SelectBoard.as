package test2.ui 
{
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.customObjects.Font;
	import test2.data.ArmatureData;
	import test2.data.Data;
	import test2.data.EquipmentData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SelectBoard extends Sprite 
	{
		private var _elements:Vector.<EquipmentData>;
		
		private var _elementsImage:Vector.<Image>;
		
		private var _tweens:Vector.<Tween>;
		
		private var _selectSprite:Sprite;
		
		private var _selectID:int = 0;
		
		private var _selectElement:EquipmentData;
		
		private var _leftButton:SimpleButton;
		
		private var _rightButton:SimpleButton;
		
		private var _elementsLength:int;
		private var _initElements:Vector.<EquipmentData>;
		
		public var onSelectChange:Signal;
		public var scaleNum:Number = 0.7;
		
		public var rangeX:Number = 50;
		
		public function SelectBoard(elements:Vector.<EquipmentData>) 
		{
			super();
			_initElements = elements;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			elements = _initElements;
		}
		
		private function rightButtonClick(e:Event):void 
		{			
			if (_elementsLength > 0)
			{
				/*_tweens[_selectID].fadeTo(0);
				Starling.juggler.add(_tweens[_selectID]);*/
				var i:int = selectID;
				i++;
				if (i >= _elementsLength)
				{
					i = 0;
				}
				selectID = i;
				/*_tweens[_selectID].fadeTo(1);
				Starling.juggler.add(_tweens[_selectID]);*/
				
				onSelectChange.dispatch(_selectElement);
			}
		}
		
		private function leftButtonClick(e:Event):void 
		{
			if (_elementsLength > 0)
			{
				/*_tweens[_selectID].fadeTo(0);
				Starling.juggler.add(_tweens[_selectID]);*/
				var i:int = selectID;
				i--;
				if (i < 0)
				{
					i = _elementsLength - 1;
				}
				selectID = i;
				/*_tweens[_selectID].fadeTo(1);
				Starling.juggler.add(_tweens[_selectID]);*/
				
				onSelectChange.dispatch(_selectElement);
			}
		}
		
		public function get selectElement():Data 
		{
			return _selectElement;
		}
		
		public function get selectID():int 
		{
			return _selectID;
		}
		
		public function set selectID(value:int):void 
		{
			if (_selectID > _elementsImage.length - 1)
			{
				_selectID = 0;
			}
			_elementsImage[_selectID].alpha = 0;
			_selectID = value;
			_elementsImage[value].alpha = 1;
			_selectElement = _elements[value];
		}
		
		public function get elements():Vector.<EquipmentData> 
		{
			return _elements;
		}
		
		public function set elements(value:Vector.<EquipmentData>):void 
		{
			_elements = value;
			
			_elementsLength = _elements.length;
			_elementsImage = new Vector.<Image>;
			_tweens = new Vector.<Tween>;
			if (!onSelectChange)
			{
				onSelectChange = new Signal();
			}
				
			if (_selectSprite)
			{
				_selectSprite.removeFromParent(true);
			}
			_selectSprite = new Sprite();
			addChild(_selectSprite);
			
			var image:Image;
			var tween:Tween;
			for (var i:int = 0; i < _elementsLength; i++ )
			{
				image = new Image(Assets.getTexture(_elements[i].path));
				image.pivotX = image.width >> 1;
				image.pivotY = image.height >> 1;
				image.scaleX = scaleNum;
				image.scaleY = scaleNum;
				/*if ((image.width >> 1) > rangeX)
				{				
					image.height = image.height / (image.width / (rangeX * 2));
					image.width = rangeX * 2;
				}*/
				image.alpha = 0;				
				_elementsImage.push(image);
				_selectSprite.addChild(image);
				tween = new Tween(image, 1);
				_tweens.push(tween);
			}
			var fontMessage:Font = Fonts.getFont("Arial");
			
			if (_leftButton)
			{
				_leftButton.removeFromParent(true);
			}
			
			_leftButton = new SimpleButton(Assets.getTexture("button3"), "", null, Assets.getTexture("button4"));
			_leftButton.fontColor = fontMessage.fontColor;
			_leftButton.fontName = fontMessage.fontName;
			_leftButton.fontSize = fontMessage.fontSize;
			_leftButton.x = _selectSprite.x - rangeX/* - (_selectSprite.width >> 1)*/ - _leftButton.width - 16;
			_leftButton.y = _selectSprite.y - (_leftButton.height >> 1);
			
			addChild(_leftButton);
			_leftButton.addEventListener(Event.TRIGGERED, leftButtonClick);
			
			if (_rightButton)
			{
				_rightButton.removeFromParent(true);
			}
			
			
			_rightButton = new SimpleButton(Assets.getTexture("button2"), "", null, Assets.getTexture("button5"));
			_rightButton.fontColor = fontMessage.fontColor;
			_rightButton.fontName = fontMessage.fontName;
			_rightButton.fontSize = fontMessage.fontSize;
			_rightButton.x = _selectSprite.x + rangeX/* + (_selectSprite.width >> 1)*/ + 16;
			_rightButton.y = _selectSprite.y - (_rightButton.height >> 1);
			
			addChild(_rightButton);
			_rightButton.addEventListener(Event.TRIGGERED, rightButtonClick);
		}
		
		
		
		
		
	}

}