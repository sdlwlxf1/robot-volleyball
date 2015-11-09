package test2.ui 
{
	import citrus.core.CitrusEngine;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import test2.ui.customTween.InBound;
	import test2.ui.customTween.InFade;
	import test2.ui.customTween.InOutTweens;
	import test2.ui.customTween.InScale;
	import test2.ui.customTween.OutFade;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class MessageBoard extends Sprite 
	{		
		private var mUpState:Texture;
        private var mDownState:Texture;
        
        private var _mContents:Sprite;
        private var mBackground:Image;
        private var mTextField:TextField;
        private var mTextBounds:Rectangle;
		
		private var mText:String;
		private var mBackgroundTexture:Texture;
		private var mDisposeAutoTime:Number;
		private var unDestroyed:Boolean = true;
		private var inOutTween:InOutTweens;
		
		public var onOver:Signal;
		
		public function MessageBoard(mBackgroundTexture:Texture, text:String="", mDisposeAutoTime:Number = 0, mouseDispose:Boolean = true) 
		{
			super();
            this.mBackgroundTexture = mBackgroundTexture;
			this.mText = text;
			this.mDisposeAutoTime = mDisposeAutoTime;
			onOver = new Signal();
			
			mBackground = new Image(mBackgroundTexture);
			mTextBounds = new Rectangle(10, 10, mBackgroundTexture.width - 20, mBackgroundTexture.height - 20);    
			
			mContents = new Sprite();			
            addChild(mContents);
			mContents.addChild(mBackground);       	
            if (mText.length != 0) this.text = mText;
			resetPosition(mContents);
			
			if (mDisposeAutoTime != 0)
			{
				setTimeout(destroy, mDisposeAutoTime);
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (mouseDispose)
			{
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			}
		}
		
		public function addToParent(parent:DisplayObjectContainer):void
		{
			parent.addChild(this);
		}
		
		private function onTouch(event:TouchEvent):void
        {      
            var touch:Touch = event.getTouch(this);
            if (touch == null) return;
            
            if (touch.phase == TouchPhase.BEGAN)
            {

            }
            else if (touch.phase == TouchPhase.MOVED)
            {

            }
            else if (touch.phase == TouchPhase.ENDED)
            {
				destroy();
                dispatchEventWith(Event.TRIGGERED, true);
            }
        }
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
			if (parent.numChildren > 2 && parent.getChildAt(parent.numChildren - 2) is MessageBoard)
			{
				(parent.getChildAt(parent.numChildren - 2) as MessageBoard).destroy();
			}
			inOutTween = new InOutTweens(mContents, InFade, OutFade);
			
			inOutTween.outOnComplete = fadeOnComplete;
			inOutTween.startIn();
		}
		
		private function resetPosition(object:DisplayObject):void
		{
			object.pivotX = object.width >> 1;
			object.pivotY = object.height >> 1;
			if (stage)
			{
				object.x = /*CitrusEngine.getInstance().*/stage.stageWidth >> 1;
				object.y = /*CitrusEngine.getInstance().*/stage.stageHeight >> 1;
			}
			else if (Starling.current.stage)
			{
				object.x = Starling.current.stage.stageWidth >> 1;
				object.y = Starling.current.stage.stageHeight >> 1;
			}
		}
		
		public function destroy():void 
		{
			if (unDestroyed)
			{
				onOver.dispatch();
				inOutTween.startOut();	
				unDestroyed = false;
			}
		}
		
		
		
		private function fadeOnComplete():void 
		{
			
			removeFromParent(true);
			dispose();
		}
        
        private function createTextField():void
        {
            if (mTextField == null)
            {
                mTextField = new TextField(mTextBounds.width, mTextBounds.height, "");
                mTextField.vAlign = VAlign.CENTER;
                mTextField.hAlign = HAlign.CENTER;
                mTextField.touchable = false;
                mTextField.autoScale = true;
                mContents.addChild(mTextField);
            }
            
            mTextField.width  = mTextBounds.width;
            mTextField.height = mTextBounds.height;
            mTextField.x = mTextBounds.x;
            mTextField.y = mTextBounds.y;
        }
		
		
		/** The text that is displayed on the button. */
        public function get text():String { return mTextField ? mTextField.text : ""; }
        public function set text(value:String):void
        {
            createTextField();
            mTextField.text = value;
        }
       
        /** The name of the font displayed on the button. May be a system font or a registered 
          * bitmap font. */
        public function get fontName():String { return mTextField ? mTextField.fontName : "Verdana"; }
        public function set fontName(value:String):void
        {
            createTextField();
            mTextField.fontName = value;
        }
        
        /** The size of the font. */
        public function get fontSize():Number { return mTextField ? mTextField.fontSize : 12; }
        public function set fontSize(value:Number):void
        {
            createTextField();
            mTextField.fontSize = value;
        }
        
        /** The color of the font. */
        public function get fontColor():uint { return mTextField ? mTextField.color : 0x0; }
        public function set fontColor(value:uint):void
        {
            createTextField();
            mTextField.color = value;
        }
        
        /** Indicates if the font should be bold. */
        public function get fontBold():Boolean { return mTextField ? mTextField.bold : false; }
        public function set fontBold(value:Boolean):void
        {
            createTextField();
            mTextField.bold = value;
        }
        
        /** The vertical alignment of the text on the button. */
        public function get textVAlign():String { return mTextField.vAlign; }
        public function set textVAlign(value:String):void
        {
            createTextField();
            mTextField.vAlign = value;
        }
        
        /** The horizontal alignment of the text on the button. */
        public function get textHAlign():String { return mTextField.hAlign; }
        public function set textHAlign(value:String):void
        {
            createTextField();
            mTextField.hAlign = value;
        }
        
        /** The bounds of the textfield on the button. Allows moving the text to a custom position. */
        public function get textBounds():Rectangle { return mTextBounds.clone(); }
        public function set textBounds(value:Rectangle):void
        {
            mTextBounds = value.clone();
            createTextField();
        }
		
		public function get mContents():Sprite 
		{
			return _mContents;
		}
		
		public function set mContents(value:Sprite):void 
		{
			_mContents = value;
		}
		
	}

}