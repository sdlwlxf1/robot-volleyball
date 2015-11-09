package test2.ui 
{
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.customObjects.Font;
	import test2.data.Data;
	import test2.data.EquipmentData;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class MoveSelectBoard extends Sprite 
	{
		private var _leftButton:SimpleButton;
		private var _rightButton:SimpleButton;
		
		private var _elements:Vector.<EquipmentData>;
		
		private var _elementSprite:Vector.<Sprite>;
		
		private var _elementTweens:Vector.<Tween>;
		
		private var _queue:Vector.<EquipmentData>;
		
		private var _imageWidth:int = 100;
		
		private var _imageHeight:int = 80;
		
		private var _leftPosition:Point;
		
		private var _middlePosition:Point;
		
		private var _rightPosition:Point;
		
		
		private var _leftData:EquipmentData;
		
		private var _middleData:EquipmentData;
		
		private var _rightData:EquipmentData;
		
		private var _middleID:Number;
		
		private var _leftID:Number;
		
		private var _rightID:Number;
		private var blur:BlurFilter;
		private var dropShadow:BlurFilter;
		private var glow:BlurFilter;
		private var elementSprite:Sprite;
		public var scaleNum:Number = 1;
		
		public var middleDataChange:Signal;
		
		public function MoveSelectBoard() 
		{
			super();
			_leftPosition = new Point(-_imageWidth - 30, 0);
			_middlePosition = new Point(0, 0);
			_rightPosition = new Point(_imageWidth + 30, 0);
			middleDataChange = new Signal();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			// the blur filter handles also drop shadow and glow
			blur = new BlurFilter();
			dropShadow = BlurFilter.createDropShadow();
			glow = BlurFilter.createGlow();
			
			elementSprite = new Sprite();
			addChild(elementSprite);
			
			var fontMessage:Font = Fonts.getFont("smooth");
			
			_leftButton = new SimpleButton(Assets.getTexture("button3"), "", null, Assets.getTexture("button4"));
			_leftButton.fontColor = fontMessage.fontColor;
			_leftButton.fontName = fontMessage.fontName;
			_leftButton.fontSize = fontMessage.fontSize;
			_leftButton.x = _leftPosition.x - 100;
			_leftButton.y = -20;
			
			addChild(_leftButton);
			_leftButton.addEventListener(Event.TRIGGERED, leftButtonClick);
			
			_rightButton = new SimpleButton(Assets.getTexture("button2"), "", null, Assets.getTexture("button5"));
			_rightButton.fontColor = fontMessage.fontColor;
			_rightButton.fontName = fontMessage.fontName;
			_rightButton.fontSize = fontMessage.fontSize;
			_rightButton.x = _rightPosition.x + 60;
			_rightButton.y = -20;
			
			addChild(_rightButton);
			_rightButton.addEventListener(Event.TRIGGERED, rightButtonClick);
		}
		
		private function rightButtonClick(e:Event):void 
		{
			if (_elements.length > 1)
			{
				_middleID--;
				if (_middleID < 0)
				{
					_middleID = _elements.length - 1;
				}
				setQueueID();
				setAlpha();
				setPosition();
				
			}
			middleDataChange.dispatch(_elements[_middleID]);
		}
		
		
		
		private function leftButtonClick(e:Event):void 
		{
			if (_elements.length > 1)
			{
				_middleID++;
				if (_middleID > _elements.length - 1)
				{
					_middleID = 0;
				}
				setQueueID();
				setAlpha();
				setPosition();
				
			}
			middleDataChange.dispatch(_elements[_middleID]);
		}
		
		private function setPosition():void
		{
			_elementSprite[_leftID].x = _leftPosition.x;
			_elementSprite[_leftID].y = _leftPosition.y;
			
			_elementSprite[_middleID].x = _middlePosition.x;
			_elementSprite[_middleID].y = _middlePosition.y;
			
			_elementSprite[_rightID].x = _rightPosition.x;
			_elementSprite[_rightID].y = _rightPosition.y;
		}
		
		private function setAlpha():void 
		{
			for (var i:int = 0; i < _elementSprite.length; i++ )
			{
				_elementSprite[i].alpha = 0;
			}
			
			_elementSprite[_leftID].alpha = 0.3;		
			_elementSprite[_leftID].filter = blur;		
			_elementSprite[_leftID].scaleX = 0.7;
			_elementSprite[_leftID].scaleY = 0.7;
			
			_elementSprite[_middleID].alpha = 1;			
			_elementSprite[_middleID].filter = null;		
			_elementSprite[_middleID].scaleX = 1;
			_elementSprite[_middleID].scaleY = 1;
			
			_elementSprite[_rightID].alpha = 0.3;		
			_elementSprite[_rightID].filter = blur;		
			_elementSprite[_rightID].scaleX = 0.7;
			_elementSprite[_rightID].scaleY = 0.7;
		}
		
		public function setElements(elements:Vector.<EquipmentData>):void
		{
			reset();
			_elements = elements;
			initElementImages();
			_middleID = 0;
			if (_elements.length > 1)
			{
				setQueueID();
				setAlpha();
				setPosition();
			}
			else if (_elements.length == 1)
			{
				
				_elementSprite[_middleID].alpha = 1;
				_elementSprite[_middleID].x = _middlePosition.x;
				_elementSprite[_middleID].y = _middlePosition.y;
			}
		}
		
		private function reset():void
		{
			_queue = new Vector.<EquipmentData>;
			_elementTweens = new Vector.<Tween>;
			if (_elementSprite)
			{
				for (var i:int = 0; i < _elementSprite.length; i++ )
				{
					_elementSprite[i].removeFromParent();
				}
			}
			_elementSprite = new Vector.<Sprite>;
		}
		
		private function setQueueID():void
		{
			if (_middleID == 0)
			{
				_leftID = _elements.length - 1;
				_rightID = _middleID + 1;
			}
			else if (_middleID == _elements.length - 1)
			{
				_leftID = _middleID - 1;
				_rightID = 0;
			}
			else 
			{
				_leftID = _middleID - 1;
				_rightID = _middleID + 1;			
			}
		}
		
		
		
		private function initElementImages():void
		{
			for (var i:int = 0; i < _elements.length; i++ )
			{
				var image:Image = new Image(Assets.getTexture(_elements[i].path));
				
				image.pivotX = image.width >> 1;
				image.pivotY = image.height >> 1;
				image.scaleX = scaleNum;
				image.scaleY = scaleNum;
				_elementSprite[i] = new Sprite();
				_elementTweens[i] = new Tween(_elementSprite[i], 0.5);
				_elementSprite[i].addChild(image);
				elementSprite.addChildAt(_elementSprite[i], 0);
			}
			
		}	
		
		public function getSelectElement():EquipmentData
		{
			return _elements[_middleID];
		}
		
	}

}