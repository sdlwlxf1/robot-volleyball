package test2.ui.screen 
{
	import citrus.core.CitrusEngine;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.constants.ScreenConst;
	import test2.customObjects.Font;
	import test2.data.UserData;
	import test2.ui.SetKeyBoard;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class SetKeyScreen extends Screen 
	{
		
		private var _player1SetKeyBoard:SetKeyBoard;
		
		private var _player2SetKeyBoard:SetKeyBoard;
		
		private var _keyValue:Object;
		
		private var _ce:CitrusEngine;
		
		private var _playButton:Button;
		
		private var fontMessage:Font;
		private var _upText:TextField;
		private var _downText:TextField;
		private var _leftText:TextField;
		private var _rightText:TextField;
		private var _hitText:TextField;
		private var _resetButton:Button;
		private var _player1Text:TextField;
		private var _player2Text:TextField;
		private var _setKeyLine:Image;
		
		public function SetKeyScreen() 
		{
			super();
			_ce = CitrusEngine.getInstance();
			
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
			_player1SetKeyBoard.y = 200;
			addChild(_player1SetKeyBoard);
			
			_player2SetKeyBoard = new SetKeyBoard();
			_player2SetKeyBoard.x = stage.stageWidth - 200;
			_player2SetKeyBoard.y = 200;
			addChild(_player2SetKeyBoard);
			
			fontMessage = Fonts.getFont("smooth");
			
			
			_resetButton = new Button(Texture.fromColor(100, 40, 0x00000000), "重置");
			_resetButton.fontColor = fontMessage.fontColor;
			_resetButton.fontName = fontMessage.fontName;
			_resetButton.fontSize = fontMessage.fontSize;
			_resetButton.x = stage.stageWidth - _resetButton.width - 50;
			_resetButton.y = (stage.stageHeight >> 1) - (_resetButton.height >> 1) + 230;
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
			
			
			_upText = new TextField(100, 50, "跳跃", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_upText.vAlign = VAlign.CENTER;
            _upText.hAlign = HAlign.CENTER;
			_upText.pivotX = _upText.width >> 1;
			_upText.pivotY = _upText.height >> 1;
			_upText.x = stage.stageWidth >> 1;
			_upText.y = (stage.stageHeight >> 1) - 150;
			addChild(_upText);
			
			
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
			
			_leftText = new TextField(100, 50, "左", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_leftText.vAlign = VAlign.CENTER;
            _leftText.hAlign = HAlign.CENTER;
			_leftText.pivotX = _leftText.width >> 1;
			_leftText.pivotY = _leftText.height >> 1;
			_leftText.x = stage.stageWidth >> 1;
			_leftText.y = (stage.stageHeight >> 1) + 20;
			addChild(_leftText);
			
			_rightText = new TextField(100, 50, "右", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_rightText.vAlign = VAlign.CENTER;
            _rightText.hAlign = HAlign.CENTER;
			_rightText.pivotX = _rightText.width >> 1;
			_rightText.pivotY = _rightText.height >> 1;
			_rightText.x = stage.stageWidth >> 1;
			_rightText.y = (stage.stageHeight >> 1) - 55;
			addChild(_rightText);
			
			_hitText = new TextField(100, 50, "击球", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor, true);
			_hitText.vAlign = VAlign.CENTER;
            _hitText.hAlign = HAlign.CENTER;
			_hitText.pivotX = _hitText.width >> 1;
			_hitText.pivotY = _hitText.height >> 1;
			_hitText.x = stage.stageWidth >> 1;
			_hitText.y = (stage.stageHeight >> 1) + 120;
			addChild(_hitText);
			
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
			object1["hitKey"] = object["hitKey"];
			return object1;
		}
		
		private function playButtonClick(e:Event):void 
		{						
			setKey();
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
			_ce.input.keyboard.addKeyAction("p1hit", _keyValue["hitKey"]);
			
			_keyValue = _player2SetKeyBoard.keyValues;			
			UserData.getInstance().p2KeySet = _keyValue;
			
			_ce.input.keyboard.addKeyAction("p2left", _keyValue["leftKey"]);
			_ce.input.keyboard.addKeyAction("p2jump", _keyValue["jumpKey"]);
			_ce.input.keyboard.addKeyAction("p2right", _keyValue["rightKey"]);
			_ce.input.keyboard.addKeyAction("p2hit", _keyValue["hitKey"]);
		}
		
		
		
	}

}