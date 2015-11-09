package test2.ui.screen 
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.constants.ScreenConst;
	import test2.customObjects.Font;
	import test2.ui.SimpleButton;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class GameWinScreen extends Screen 
	{
		private var fontMessage:Font;
		private var _backButton:SimpleButton;
		private var _loseText:TextField;
		
		public function GameWinScreen() 
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
			_loseText.text = "恭喜你打败了所有对手，试下双人游戏，跟好朋友一决高下吧。";
			_loseText.vAlign = VAlign.CENTER;
			_loseText.hAlign = HAlign.CENTER;
			
			_backButton = new SimpleButton(Texture.fromColor(150, 60, 0x00000000), "返回标题");
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
			screenController.dispatchSignal(ScreenConst.GAMEWIN_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
		override protected function inOnComplete():void 
		{
			super.inOnComplete();
			screenController.dispatchSignal(ScreenConst.GAMEWIN_SCREEN, ScreenConst.SCREEN_IN, this);
		}
		
	}

}