package ui 
{
	import citrus.core.CitrusEngine;
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import assets.Assets;
	import assets.Fonts;
	import customObjects.Font;
	import data.ArmatureData;
	import data.Data;
	import data.EquipmentData;
	
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
		private var blur:BlurFilter;
		private var dropShadow:BlurFilter;
		private var glow:BlurFilter;
		private var colorMatrixFilter:ColorMatrixFilter;
		
		public var onSelectChange:Signal;
		
		private var _selectBackground:Image;
		private var _selectBackgroundAdded:Boolean = false;
		
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
			
			_selectBackground = new Image(Assets.getTexture("selectBackground"));			
			
			blur = new BlurFilter();
			dropShadow = BlurFilter.createDropShadow();
			glow = BlurFilter.createGlow();
			colorMatrixFilter = new ColorMatrixFilter();
			colorMatrixFilter.adjustBrightness(-1);
			
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
				
				if (selectID != i)
				{
					selectID = i;
					onSelectChange.dispatch(_selectElement);
				}
				
				
				/*_tweens[_selectID].fadeTo(1);
				Starling.juggler.add(_tweens[_selectID]);*/
				
				
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
				
				if (selectID != i)
				{
					selectID = i;
					onSelectChange.dispatch(_selectElement);
				}
				
				
				/*_tweens[_selectID].fadeTo(1);
				Starling.juggler.add(_tweens[_selectID]);*/
				
				
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
		
		public function setFilter(filter:FragmentFilter):void
		{
			_elementsImage[_selectID].filter = filter;
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
			//_selectSprite.filter = ;
			
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
				image.filter = dropShadow;
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
			
			_leftButton = new SimpleButton(Assets.getTexture("button3"), "", Assets.getTexture("button4"), Assets.getTexture("button4"));
			_leftButton.fontColor = fontMessage.fontColor;
			_leftButton.fontName = fontMessage.fontName;
			_leftButton.fontSize = fontMessage.fontSize;
			_leftButton.x = _selectSprite.x - rangeX/* - (_selectSprite.width >> 1)*/ - _leftButton.width - 16;
			_leftButton.y = _selectSprite.y - (_leftButton.height >> 1);
			
			addChild(_leftButton);
			_leftButton.addEventListener(Event.TRIGGERED, leftButtonClick);
			_leftButton.onHover.add(buttonOnHover);
			
			if (_rightButton)
			{
				_rightButton.removeFromParent(true);
			}
			
			
			_rightButton = new SimpleButton(Assets.getTexture("button2"), "", Assets.getTexture("button5"), Assets.getTexture("button5"));
			_rightButton.fontColor = fontMessage.fontColor;
			_rightButton.fontName = fontMessage.fontName;
			_rightButton.fontSize = fontMessage.fontSize;
			_rightButton.x = _selectSprite.x + rangeX/* + (_selectSprite.width >> 1)*/ + 16;
			_rightButton.y = _selectSprite.y - (_rightButton.height >> 1);
			
			addChild(_rightButton);
			_rightButton.addEventListener(Event.TRIGGERED, rightButtonClick);
			_rightButton.onHover.add(buttonOnHover);
			
			if (!_selectBackgroundAdded)
			{
				_selectBackgroundAdded = true;
				_selectBackground.pivotX = _selectBackground.width >> 1;
				_selectBackground.pivotY = _selectBackground.height >> 1;
				_selectBackground.height = _elementsImage[0].height + 20;
				_selectBackground.width = this.width;
				_selectBackground.blendMode = BlendMode.MULTIPLY;
				addChildAt(_selectBackground, 0);
			}
			
		}
		
		private function buttonOnHover(button:SimpleButton):void 
		{
			CitrusEngine.getInstance().sound.playSound("menu_mousepass");
		}
	}

}