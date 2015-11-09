package ui.screen 
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.BlurFilter;
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
	public class TrainDeveloperScreen extends TrainScreen 
	{
		private var fontMessage:Font;
		private var _backButton:SimpleButton;
		private var _contentText:TextField;
		private var dropShadow:BlurFilter;
		
		public function TrainDeveloperScreen() 
		{
			super();			
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
			
			dropShadow = BlurFilter.createDropShadow(0, 0.9, 0x0, 1, 0.1);
			
			var fontStyle1:Font = new Font("黑体", 28, 0XF6F6F6);
			
			/*_contentText = new TextField(300, 300, "0", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_contentText.x = ((stage.stageWidth - _contentText.width) >> 1);
			_contentText.y = ((stage.stageHeight - _contentText.height) >> 1) - 50;
			addChild(_contentText);
			_contentText.text = "失败是成功之母，\n下次再努力吧";
			_contentText.vAlign = VAlign.CENTER;
			_contentText.hAlign = HAlign.CENTER;*/
			
			var text:Image = new Image(Assets.getTexture("developerText"));
			text.width = stage.stageWidth;
			text.height = stage.stageHeight;
			addChild(text);
			
			_backButton = new SimpleButton(Texture.fromColor(150, 60, 0x00000000), "返回标题");
			_backButton.fontColor = fontStyle1.fontColor;
			_backButton.fontName = fontStyle1.fontName;
			_backButton.fontSize = fontStyle1.fontSize;
			_backButton.filter = dropShadow;
			_backButton.x = 0/*((stage.stageWidth - _backButton.width) >> 1)*/;
			_backButton.y = 0/*((stage.stageHeight - _backButton.height) >> 1)*/;
			addChild(_backButton);
			
			_backButton.addEventListener(Event.TRIGGERED, backButtonClick);
		}
		
		private function backButtonClick(e:Event):void 
		{
			screenController.dispatchSignal(ScreenConst.TRAIN_DEVELOPER_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
		override protected function inOnComplete():void 
		{
			super.inOnComplete();
			//screenController.dispatchSignal(ScreenConst.TRAIN_LOGO_SCREEN, ScreenConst.SCREEN_IN, this);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			//_ce.sound.stopSound("developerBGM");
		}
		
	}

}