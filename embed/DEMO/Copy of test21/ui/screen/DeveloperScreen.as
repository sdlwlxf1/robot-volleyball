package test2.ui.screen 
{
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
	import test2.ui.SimpleButton;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class DeveloperScreen extends Screen 
	{
		private var fontMessage:Font;
		private var _backButton:SimpleButton;
		private var _contentText:TextField;
		
		public function DeveloperScreen() 
		{
			super();			
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
			
			fontMessage = Fonts.getFont("smooth");
			
			/*_contentText = new TextField(300, 300, "0", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_contentText.x = ((stage.stageWidth - _contentText.width) >> 1);
			_contentText.y = ((stage.stageHeight - _contentText.height) >> 1) - 50;
			addChild(_contentText);
			_contentText.text = "失败是成功之母，\n下次再努力吧";
			_contentText.vAlign = VAlign.CENTER;
			_contentText.hAlign = HAlign.CENTER;*/
			
			var text:Image = new Image(Assets.getTexture("developerText"));
			addChild(text);
			
			_backButton = new SimpleButton(Texture.fromColor(150, 60, 0x00000000), "返回标题");
			_backButton.fontColor = fontMessage.fontColor;
			_backButton.fontName = fontMessage.fontName;
			_backButton.fontSize = fontMessage.fontSize;
			_backButton.x = 0/*((stage.stageWidth - _backButton.width) >> 1)*/;
			_backButton.y = 0/*((stage.stageHeight - _backButton.height) >> 1)*/;
			addChild(_backButton);
			
			_backButton.addEventListener(Event.TRIGGERED, backButtonClick);
		}
		
		private function backButtonClick(e:Event):void 
		{
			screenController.dispatchSignal(ScreenConst.DEVELOPER_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
		override protected function inOnComplete():void 
		{
			super.inOnComplete();
			//screenController.dispatchSignal(ScreenConst.LOGO_SCREEN, ScreenConst.SCREEN_IN, this);
		}
		
	}

}