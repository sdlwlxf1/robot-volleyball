package ui 
{
	import aze.motion.easing.Back;
	import aze.motion.easing.Elastic;
	import aze.motion.easing.Expo;
	import aze.motion.eaze;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import assets.Assets;
	import assets.Fonts;
	import customObjects.Font;
	import data.Data;
	import data.EquipmentData;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class MoveSelectBoard extends Sprite 
	{
		private var _leftButton:SimpleButton;
		private var _rightButton:SimpleButton;
		
		private var _contentSprite:Sprite;
		
		private var _elements:Vector.<EquipmentData>;
		
		private var _elementSprite:Vector.<Sprite>;
		
		private var _queue:Vector.<EquipmentData>;
		
		private var _imageWidth:int = 80;
		
		private var _imageHeight:int = 60;
		
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
		private var _lockImage:Image;
		private var colorMatrixFilter:ColorMatrixFilter;
		private var _groupIndexSeted:Boolean;
		
		public var gapElement:Number = -10;
		
		public var gapButton:Number = -20;
		
		public var scaleNum:Number = 1;
		
		public var middleDataChange:Signal;
		
		public function MoveSelectBoard() 
		{
			super();
			middleDataChange = new Signal();
			
			
			// the blur filter handles also drop shadow and glow
			blur = new BlurFilter();
			dropShadow = BlurFilter.createDropShadow();
			glow = BlurFilter.createGlow();
			colorMatrixFilter = new ColorMatrixFilter();
			colorMatrixFilter.adjustBrightness(-1);
			
			_contentSprite = new Sprite();
			addChild(_contentSprite);
			
			/*_lockImage = new Image(Assets.getTexture("lock"));
			_lockImage.pivotX = _lockImage.width >> 1;
			_lockImage.pivotY = _lockImage.height >> 1;
			_lockImage.alpha = 0;
			addChild(_lockImage);*/
			
			_leftButton = new SimpleButton(Assets.getTexture("button4"), "", Assets.getTexture("button3"), Assets.getTexture("button3"));
			_leftButton.pivotX = _leftButton.width >> 1;
			_leftButton.pivotY = _leftButton.height >> 1;		
			addChild(_leftButton);
			_leftButton.addEventListener(Event.TRIGGERED, leftButtonClick);
			
			_rightButton = new SimpleButton(Assets.getTexture("button5"), "", Assets.getTexture("button2"), Assets.getTexture("button2"));
			_rightButton.pivotX = _rightButton.width >> 1;
			_rightButton.pivotY = _rightButton.height >> 1;			
			addChild(_rightButton);
			_rightButton.addEventListener(Event.TRIGGERED, rightButtonClick);
			
			
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			
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
				setPosition();
				
			}
			middleDataChange.dispatch(_elements[_middleID]);
		}
		
		private function setPosition(duration:Number = 0.3):void
		{			
			for (var i:int = 0; i < _elementSprite.length; i++ )
			{
				if (i != _leftID && i != _middleID && i != _rightID)
				{
					eaze(_elementSprite[i]).to(duration, {x:_middlePosition.x, y:_middlePosition.y, alpha:0} ).easing(Expo.easeOut);
				}
			}
			
			
			eaze(_elementSprite[_leftID]).to(duration, { x:_leftPosition.x, y:_leftPosition.y, alpha:1, scaleX:0.7, scaleY:0.7 } ).easing(Expo.easeOut);
			
			eaze(_elementSprite[_middleID]).to(duration, { x:_middlePosition.x, y:_middlePosition.y, alpha:1, scaleX:1, scaleY:1  } ).onUpdate(setGroupIndex).easing(Expo.easeOut);
			
			eaze(_elementSprite[_rightID]).to(duration, { x:_rightPosition.x, y:_rightPosition.y, alpha:1, scaleX:0.7, scaleY:0.7  } ).easing(Expo.easeOut);
			
			if (duration == 0)
			{
				_elementSprite[_middleID].filter = dropShadow;	
				_contentSprite.setChildIndex(_elementSprite[_middleID], _contentSprite.numChildren - 1);
			}
			
			_groupIndexSeted = false;
		}
		
		private function setGroupIndex():void 
		{
			/*for (var i:int = 0; i < _elementSprite.length; i++ )
			{
				_elementSprite[i].alpha = 0;
			}
			
			_elementSprite[_leftID].alpha = 0.3;		
			//_elementSprite[_leftID].filter = colorMatrixFilter;		
			_elementSprite[_leftID].scaleX = 0.7;
			_elementSprite[_leftID].scaleY = 0.7;
			
			_elementSprite[_middleID].alpha = 1;			
				
			_elementSprite[_middleID].scaleX = 1;
			_elementSprite[_middleID].scaleY = 1;
			
			_elementSprite[_rightID].alpha = 0.3;		
			//_elementSprite[_rightID].filter = colorMatrixFilter;		
			_elementSprite[_rightID].scaleX = 0.7;
			_elementSprite[_rightID].scaleY = 0.7;*/
			
			if (!_groupIndexSeted && _elementSprite[_middleID].scaleX > _elementSprite[_rightID].scaleX)
			{
				_elementSprite[_middleID].filter = dropShadow;				
				_contentSprite.setChildIndex(_elementSprite[_middleID], _contentSprite.numChildren - 1);
				_groupIndexSeted = true;
			}
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
				setPosition(0);
			}
			else if (_elements.length == 1)
			{
				
				_elementSprite[_middleID].alpha = 1;
				_elementSprite[_middleID].x = _middlePosition.x;
				_elementSprite[_middleID].y = _middlePosition.y;
			}
			
			middleDataChange.dispatch(_elements[_middleID]);
		}
		
		private function reset():void
		{
			_queue = new Vector.<EquipmentData>;
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
				_elementSprite[i].addChild(image);
				_contentSprite.addChild(_elementSprite[i]);
			}
			
			_imageWidth = _elementSprite[0].width;
			_imageHeight = _elementSprite[0].height;
			
			_leftPosition = new Point(-_imageWidth - gapElement, 0);
			_middlePosition = new Point(0, 0);
			_rightPosition = new Point(_imageWidth + gapElement, 0);
			
			
			_leftButton.x = _leftPosition.x - _imageWidth / 2 - _leftButton.width / 2 - gapButton;
			_leftButton.y = 0;
			
			_rightButton.x = _rightPosition.x + _imageWidth / 2 + _rightButton.width / 2 + gapButton;
			_rightButton.y = 0;
			
		}	
		
		public function getSelectElement():EquipmentData
		{
			return _elements[_middleID];
		}
		
		/*public function setLock(boo:Boolean):void
		{
			if (boo)
			{
				_lockImage.alpha = 1;
				_elementSprite[_middleID].filter = colorMatrixFilter;
			}
			else
			{
				_lockImage.alpha = 0;
				//_elementSprite[_middleID].filter = null;
			}
		}*/
		
	}

}