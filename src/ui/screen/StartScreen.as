package ui.screen 
{
	import citrus.core.CitrusEngine;
	import mx.core.ButtonAsset;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import assets.ArmatureFactory;
	import assets.Assets;
	import assets.Fonts;
	import constants.ScreenConst;
	import customObjects.Font;
	import data.UserData;
	import logics.gameLogic.LevelController;
	import logics.gameLogic.ScreenController;
	import state.MatchState;
	import ui.MoveSelectBoard;
	import ui.RewardBoard;
	import ui.SimpleButton;
	/**
	 * ...
	 * @author ...
	 */
	public class StartScreen extends Screen 
	{
		private var _singleButton:SimpleButton;
		
		private var _doubleButton:SimpleButton;
		
		private var _developerButton:SimpleButton;
		
		private var _setButton:SimpleButton;
		
		private var _shopButton:SimpleButton;
		private var fontMessage:Font;
		
		public function StartScreen() 
		{
			super();
			
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
			
			
			
			fontMessage = Fonts.getFont("smooth");
			
			var quadTex:Texture = Texture.fromColor(130, 40, 0x00000000);
			
			_singleButton = new SimpleButton(quadTex, "单人游戏"/*, null, Assets.getTexture("singlePlayerDown")*/);
			_singleButton.fontColor = fontMessage.fontColor;
			_singleButton.fontName = fontMessage.fontName;
			_singleButton.fontSize = fontMessage.fontSize * 1.1;
			_singleButton.x = stage.stageWidth / 2 - _singleButton.width / 2/* - 200*/;
			_singleButton.y = stage.stageHeight / 2 - _singleButton.height / 2 - _singleButton.height - 10;
			addChild(_singleButton);
			_singleButton.onHover.add(onOver);
			_singleButton.onOut.add(onOut);
			
			_singleButton.addEventListener(Event.TRIGGERED, singleButtonClick);
			
			_doubleButton = new SimpleButton(quadTex, "双人游戏");
			_doubleButton.fontColor = fontMessage.fontColor;
			_doubleButton.fontName = fontMessage.fontName;
			_doubleButton.fontSize = fontMessage.fontSize * 1.1;
			_doubleButton.x = stage.stageWidth / 2 - _doubleButton.width / 2/* + 200*/;
			_doubleButton.y = stage.stageHeight / 2 - _doubleButton.height / 2;
			addChild(_doubleButton);
			_doubleButton.onHover.add(onOver);
			_doubleButton.onOut.add(onOut);
			
			_doubleButton.addEventListener(Event.TRIGGERED, doubleButtonClick);
			
			_developerButton = new SimpleButton(quadTex, "制作人员");
			_developerButton.fontColor = fontMessage.fontColor;
			_developerButton.fontName = fontMessage.fontName;
			_developerButton.fontSize = fontMessage.fontSize * 1.1;
			_developerButton.x = stage.stageWidth - _developerButton.width - 5;
			_developerButton.y = stage.stageHeight - _developerButton.height - 5;
			addChild(_developerButton);
			
			_developerButton.addEventListener(Event.TRIGGERED, developerButtonClick);
			
			_setButton = new SimpleButton(quadTex, "设置按键");
			_setButton.fontColor = fontMessage.fontColor;
			_setButton.fontName = fontMessage.fontName;
			_setButton.fontSize = fontMessage.fontSize * 1.1;
			_setButton.x = stage.stageWidth / 2 - _setButton.width / 2;
			_setButton.y = stage.stageHeight / 2 - _setButton.height / 2 + _singleButton.height + 10;
			addChild(_setButton);
			_setButton.onHover.add(onOver);
			_setButton.onOut.add(onOut);
			
			_setButton.addEventListener(Event.TRIGGERED, setButtonClick);
			
			_shopButton = new SimpleButton(quadTex, "商店");
			_shopButton.fontColor = fontMessage.fontColor;
			_shopButton.fontName = fontMessage.fontName;
			_shopButton.fontSize = fontMessage.fontSize;
			_shopButton.x = stage.stageWidth - _shopButton.width;
			_shopButton.y = 0;
			addChild(_shopButton);
			
			_shopButton.addEventListener(Event.TRIGGERED, shopButtonClick);
			
			
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		private function onOut(button:SimpleButton):void 
		{
			button.fontColor = fontMessage.fontColor;
		}
		
		private function onOver(button:SimpleButton):void 
		{
			//button.fontColor = 0X020220;
		}
		
		private function shopButtonClick(e:Event):void 
		{
			_ce.sound.playSound("menu_click1");
			screenController.dispatchSignal(ScreenConst.START_SCREEN, ScreenConst.SHOP_BUTTON_CLICK, this);	
		}
		
		private function setButtonClick(e:Event):void 
		{
			_ce.sound.playSound("menu_click1");
			screenController.dispatchSignal(ScreenConst.START_SCREEN, ScreenConst.SET_BUTTON_CLICK, this);	
		}
		
		private function developerButtonClick(e:Event):void 
		{
			_ce.sound.playSound("menu_click1");
			//screenController.getSignal[ScreenConst.START_SCREEN][ScreenConst.LOGO_BUTTON_CLICK].dispatch();
			screenController.dispatchSignal(ScreenConst.START_SCREEN, ScreenConst.DEVELOPER_BUTTON_CLICK, this);	
		}
		
		private function doubleButtonClick(e:Event):void 
		{
			_ce.sound.playSound("menu_click1");
			screenController.dispatchSignal(ScreenConst.START_SCREEN, ScreenConst.DOUBLE_BUTTON_CLICK, this);
		}
		
				
				
		private function singleButtonClick(e:Event):void 
		{
			_ce.sound.playSound("menu_click1");
			screenController.dispatchSignal(ScreenConst.START_SCREEN, ScreenConst.SINGLE_BUTTON_CLICK, this);	
		}
		
	}

}