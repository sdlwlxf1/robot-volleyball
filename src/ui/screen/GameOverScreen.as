package ui.screen 
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.Assets;
	import assets.Fonts;
	import constants.ScreenConst;
	import customObjects.Font;
	import ui.SimpleButton;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class GameOverScreen extends Screen 
	{
		private var fontMessage:Font;
		private var _backButton:SimpleButton;
		private var _loseText:TextField;
		
		public function GameOverScreen() 
		{
			super();			
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
			
			fontMessage = Fonts.getFont("smooth");
			
			_loseText = new TextField(300, 300, "0", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_loseText.x = ((stage.stageWidth - _loseText.width) >> 1);
			_loseText.y = ((stage.stageHeight - _loseText.height) >> 1) - 50;
			addChild(_loseText);
			_loseText.text = "失败是成功之母，\n下次再努力吧";
			_loseText.vAlign = VAlign.CENTER;
			_loseText.hAlign = HAlign.CENTER;
			
			_backButton = new SimpleButton(Texture.fromColor(150, 60, 0x00000000), "重新开始");
			_backButton.fontColor = fontMessage.fontColor;
			_backButton.fontName = fontMessage.fontName;
			_backButton.fontSize = fontMessage.fontSize;
			_backButton.x = ((stage.stageWidth - _backButton.width) >> 1);
			_backButton.y = ((stage.stageHeight - _backButton.height) >> 1) + 50;
			addChild(_backButton);
			
			_backButton.addEventListener(Event.TRIGGERED, backButtonClick);
		}
		
		private function backButtonClick(e:Event):void 
		{
			screenController.dispatchSignal(ScreenConst.GAMEOVER_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
		override protected function inOnComplete():void 
		{
			super.inOnComplete();
			screenController.dispatchSignal(ScreenConst.GAMEOVER_SCREEN, ScreenConst.SCREEN_IN, this);
		}
		
	}

}