package ui 
{
	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import flash.events.KeyboardEvent;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import assets.Assets;
	import assets.Fonts;
	import constants.KeyConst;
	import customObjects.Font;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class SetKeyButton extends Button 
	{
		private var _keyValue:uint;
		
		private var _messageBoard:MessageBoard;
		private var fontMessage:Font;
		
		public function SetKeyButton(upState:Texture, text:String="", downState:Texture=null)
		{
			super(upState, text, downState);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			fontMessage = Fonts.getFont("smooth");
			var fontMessage1:Font = Fonts.getFont("founder");
			fontColor = 0XF2E39D//fontMessage.fontColor;
			fontName = fontMessage1.fontName;
			fontSize = fontMessage1.fontSize;
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.TRIGGERED, buttonClick);		
		}
		
		
		
		private function buttonClick(e:Event):void 
		{		

			_messageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "按任意键", 3000);
			_messageBoard.fontColor = fontMessage.fontColor;
			_messageBoard.fontName = fontMessage.fontName;
			_messageBoard.fontSize = fontMessage.fontSize;
			_messageBoard.addToParent(this.parent.parent);
			_messageBoard.onOver.add(removeKeyEventListener);
			CitrusEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		}
		
		private function keyDownListener(e:KeyboardEvent):void 
		{	
			removeMessage();

			if (KeyConst.keyString[String(e.keyCode)])
			{			
				keyValue = e.keyCode;
				_messageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "按键更改", 1000);
				_messageBoard.fontColor = fontMessage.fontColor;
				_messageBoard.fontName = fontMessage.fontName;
				_messageBoard.fontSize = fontMessage.fontSize;
				_messageBoard.addToParent(this.parent.parent);
				_messageBoard.onOver.add(removeKeyEventListener);
			}
			else
			{
				_messageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "不能设置按键", 1000);
				_messageBoard.fontColor = fontMessage.fontColor;
				_messageBoard.fontName = fontMessage.fontName;
				_messageBoard.fontSize = fontMessage.fontSize;
				_messageBoard.addToParent(this.parent.parent);
				_messageBoard.onOver.add(removeKeyEventListener);
			}
			removeKeyEventListener();		
		}
		
		private function removeKeyEventListener():void 
		{
			if (CitrusEngine.getInstance().stage.hasEventListener(KeyboardEvent.KEY_DOWN))
			{
				CitrusEngine.getInstance().stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			}
		}
		
		public function get keyValue():uint 
		{
			return _keyValue;
		}
		
		public function set keyValue(value:uint):void 
		{
			_keyValue = value;
			text = KeyConst.keyString[String(value)];
		}
		
		public function removeMessage():void
		{
			if (_messageBoard && _messageBoard.stage)
			{
				_messageBoard.destroy();
			}
		}
		
	}

}