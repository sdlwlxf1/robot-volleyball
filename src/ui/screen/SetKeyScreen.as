package ui.screen 
{
	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.Assets;
	import assets.Fonts;
	import constants.ScreenConst;
	import customObjects.Font;
	import data.UserData;
	import ui.SetKeyBoard;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class SetKeyScreen extends Screen 
	{
		
		private var _player1SetKeyBoard:SetKeyBoard;
		
		private var _player2SetKeyBoard:SetKeyBoard;
		
		private var _keyValue:Object;
		
		private var _playButton:Button;
		
		private var fontMessage:Font;
		private var _upText:TextField;
		private var _downText:TextField;
		private var _leftText:TextField;
		private var _rightText:TextField;
		private var _resetButton:Button;
		private var _player1Text:TextField;
		private var _player2Text:TextField;
		private var _setKeyLine:Image;
		private var _hit2Text:TextField;
		private var _hit1Text:TextField;
		
		public function SetKeyScreen() 
		{
			super();
			
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
		
			
			_setKeyLine = new Image(Assets.getTexture("setKeyLine"));
			_setKeyLine.width = stage.stageWidth;
			_setKeyLine.height = stage.stageHeight;
			addChild(_setKeyLine);
			
			_player1SetKeyBoard = new SetKeyBoard();
			_player1SetKeyBoard.x = 200;
			_player1SetKeyBoard.y = 180;
			addChild(_player1SetKeyBoard);
			
			_player2SetKeyBoard = new SetKeyBoard();
			_player2SetKeyBoard.x = stage.stageWidth - 200;
			_player2SetKeyBoard.y = _player1SetKeyBoard.y;
			addChild(_player2SetKeyBoard);
			
			fontMessage = Fonts.getFont("smooth");
			
			
			_resetButton = new Button(Texture.fromColor(100, 40, 0x00000000), "重置");
			_resetButton.fontColor = fontMessage.fontColor;
			_resetButton.fontName = fontMessage.fontName;
			_resetButton.fontSize = fontMessage.fontSize;
			_resetButton.x = stage.stageWidth - _resetButton.width - 20;
			_resetButton.y = stage.stageHeight - _resetButton.height - 20;
			addChild(_resetButton);
			
			_playButton = new Button(Texture.fromColor(100, 40, 0x00000000), "确认");
			_playButton.fontColor = fontMessage.fontColor;
			_playButton.fontName = fontMessage.fontName;
			_playButton.fontSize = fontMessage.fontSize;
			_playButton.x = _resetButton.x - _playButton.width - 50;
			_playButton.y = _resetButton.y;
			addChild(_playButton);
			
			_player1SetKeyBoard.keyValues = UserData.getInstance().p1KeySet;
			_player2SetKeyBoard.keyValues = UserData.getInstance().p2KeySet;
	
			_player1Text = new TextField(100, 50, "玩家1", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_player1Text.vAlign = VAlign.CENTER;
            _player1Text.hAlign = HAlign.CENTER;
			_player1Text.pivotX = _player1Text.width >> 1;
			_player1Text.pivotY = _player1Text.height >> 1;
			_player1Text.x = _player1SetKeyBoard.x;
			_player1Text.y = 50;
			addChild(_player1Text);
			
			
			_player2Text = new TextField(100, 50, "玩家2", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_player2Text.vAlign = VAlign.CENTER;
            _player2Text.hAlign = HAlign.CENTER;
			_player2Text.pivotX = _player2Text.width >> 1;
			_player2Text.pivotY = _player2Text.height >> 1;
			_player2Text.x = _player2SetKeyBoard.x;
			_player2Text.y = 50;
			addChild(_player2Text);
			
			/*_downText = new TextField(100, 50, "下", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_downText.vAlign = VAlign.CENTER;
            _downText.hAlign = HAlign.CENTER;
			_downText.pivotX = _downText.width >> 1;
			_downText.pivotY = _downText.height >> 1;
			_downText.x = stage.stageWidth >> 1;
			_downText.y = (stage.stageHeight >> 1) + 100;
			addChild(_downText);*/
			
			_upText = new TextField(100, 50, "跳跃", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_upText.vAlign = VAlign.CENTER;
            _upText.hAlign = HAlign.CENTER;
			_upText.pivotX = _upText.width >> 1;
			_upText.pivotY = _upText.height >> 1;
			_upText.x = stage.stageWidth >> 1;
			_upText.y = (stage.stageHeight >> 1) - 120;
			addChild(_upText);
			
			_rightText = new TextField(100, 50, "右", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_rightText.vAlign = VAlign.CENTER;
            _rightText.hAlign = HAlign.CENTER;
			_rightText.pivotX = _rightText.width >> 1;
			_rightText.pivotY = _rightText.height >> 1;
			_rightText.x = stage.stageWidth >> 1;
			_rightText.y = (stage.stageHeight >> 1) - 25;
			addChild(_rightText);
			
			_leftText = new TextField(100, 50, "左", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_leftText.vAlign = VAlign.CENTER;
            _leftText.hAlign = HAlign.CENTER;
			_leftText.pivotX = _leftText.width >> 1;
			_leftText.pivotY = _leftText.height >> 1;
			_leftText.x = stage.stageWidth >> 1;
			_leftText.y = (stage.stageHeight >> 1) + 35;
			addChild(_leftText);
		
			
			_hit1Text = new TextField(150, 50, "高击球", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_hit1Text.vAlign = VAlign.CENTER;
            _hit1Text.hAlign = HAlign.CENTER;
			_hit1Text.pivotX = _hit1Text.width >> 1;
			_hit1Text.pivotY = _hit1Text.height >> 1;
			_hit1Text.x = stage.stageWidth >> 1;
			_hit1Text.y = (stage.stageHeight >> 1) + 160;
			addChild(_hit1Text);
			
			_hit2Text = new TextField(150, 50, "低击球", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_hit2Text.vAlign = VAlign.CENTER;
            _hit2Text.hAlign = HAlign.CENTER;
			_hit2Text.pivotX = _hit2Text.width >> 1;
			_hit2Text.pivotY = _hit2Text.height >> 1;
			_hit2Text.x = stage.stageWidth >> 1;
			_hit2Text.y = (stage.stageHeight >> 1) + 190;
			addChild(_hit2Text);
			
			_playButton.addEventListener(Event.TRIGGERED, playButtonClick);
			_resetButton.addEventListener(Event.TRIGGERED, resetButtonClick);
		}
		
		private function resetButtonClick(e:Event):void 
		{
			resetKey();
		}
		
		private function resetKey():void 
		{
			_player1SetKeyBoard.keyValues = getResetKey(UserData.getInstance().p1KeyReset);
			_player2SetKeyBoard.keyValues = getResetKey(UserData.getInstance().p2KeyReset);
		}
		
		private function getResetKey(object:Object):Object
		{
			var object1:Object = {};
			object1["jumpKey"] = object["jumpKey"];
			object1["leftKey"] = object["leftKey"];
			object1["rightKey"] = object["rightKey"];
			object1["downKey"] = object["downKey"];
			object1["generalHitBallKey"] = object["generalHitBallKey"];
			object1["specialHitBallKey"] = object["specialHitBallKey"];
			object1["skill1Key"] = object["skill1Key"];
			return object1;
		}
		
		private function playButtonClick(e:Event):void 
		{						
			setKey();
			UserData.getInstance().saveData();
			screenController.dispatchSignal(ScreenConst.SETKEY_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
		private function setKey():void 
		{		
			_ce.input.keyboard.resetAllKeyActions();
			
			_keyValue = _player1SetKeyBoard.keyValues;			
			UserData.getInstance().p1KeySet = _keyValue;
			
			_ce.input.keyboard.addKeyAction("p1left", _keyValue["leftKey"]);
			_ce.input.keyboard.addKeyAction("p1jump", _keyValue["jumpKey"]);
			_ce.input.keyboard.addKeyAction("p1right", _keyValue["rightKey"]);
			_ce.input.keyboard.addKeyAction("p1down", _keyValue["downKey"]);
			_ce.input.keyboard.addKeyAction("p1specialHitBall", _keyValue["specialHitBallKey"]);
			_ce.input.keyboard.addKeyAction("p1generalHitBall", _keyValue["generalHitBallKey"]);
			_ce.input.keyboard.addKeyAction("p1skill1", _keyValue["skill1Key"]);
			
			_keyValue = _player2SetKeyBoard.keyValues;			
			UserData.getInstance().p2KeySet = _keyValue;
			
			_ce.input.keyboard.addKeyAction("p2left", _keyValue["leftKey"]);
			_ce.input.keyboard.addKeyAction("p2jump", _keyValue["jumpKey"]);
			_ce.input.keyboard.addKeyAction("p2right", _keyValue["rightKey"]);
			_ce.input.keyboard.addKeyAction("p2down", _keyValue["downKey"]);
			_ce.input.keyboard.addKeyAction("p2specialHitBall", _keyValue["specialHitBallKey"]);
			_ce.input.keyboard.addKeyAction("p2generalHitBall", _keyValue["generalHitBallKey"]);
			_ce.input.keyboard.addKeyAction("p2skill1", _keyValue["skill1Key"]);

			
		}
		
		
		
	}

}