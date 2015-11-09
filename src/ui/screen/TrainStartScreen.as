package ui.screen 
{
	import citrus.core.CitrusEngine;
	import mx.core.ButtonAsset;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import assets.ArmatureFactory;
	import assets.Assets;
	import assets.Fonts;
	import constants.ScreenConst;
	import customObjects.Font;
	import data.UserData;
	import logics.gameLogic.LevelController;
	import logics.gameLogic.ScreenController;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import state.MatchState;
	import ui.MoveSelectBoard;
	import ui.RewardBoard;
	import ui.SimpleButton;
	/**
	 * ...
	 * @author ...
	 */
	public class TrainStartScreen extends TrainScreen 
	{
		private var _singleButton:SimpleButton;
		
		private var _chartsButton:SimpleButton;
		
		private var _developerButton:SimpleButton;
		
		private var _setButton:SimpleButton;
		
		private var _shopButton:SimpleButton;
		private var fontMessage:Font;
		private var dropShadow:BlurFilter;
		private var _titleText:TextField;
		private var _title1Text:TextField;
		private var _titleImage:Image;
		
		public function TrainStartScreen() 
		{
			super();
			
		}
		
		override protected function initScreens():void 
		{
			//super.initScreens();
			
			
			//_background = new Quad(stage.stageWidth, stage.stageHeight, 0X9D9EA2);
			_background = new Image(Assets.getTexture("UIbackground1"));
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			addChild(_background);
			
			
			var fontStyle1:Font = new Font("黑体", 28, 0XF6F6F6);
			
			dropShadow = BlurFilter.createDropShadow(0, 0.9, 0x0, 1, 0.1);
			
			var quadTex:Texture = Texture.fromColor(130, 40, 0x00000000);
			
			
			_title1Text = new TextField(300, 100, "", "楷体", 30, 0XFFFFFF);
			_title1Text.vAlign = VAlign.CENTER;
            _title1Text.hAlign = HAlign.CENTER;
			_title1Text.bold = true;
			_title1Text.text = "《机甲暴扣王》之"
			_title1Text.filter = dropShadow;
			_title1Text.pivotX = _title1Text.width >> 1;
			_title1Text.pivotY = _title1Text.height >> 1;
			_title1Text.x = stage.stageWidth / 2;
			_title1Text.y = stage.stageHeight / 2 - 120;
			//addChild(_title1Text);
			
			/*_titleText = new TextField(200, 70, "", "黑体", 35, 0XFFFFFF);
			_titleText.vAlign = VAlign.CENTER;
            _titleText.hAlign = HAlign.CENTER;
			_titleText.bold = true;
			_titleText.text = "魔鬼训练";
			_titleText.filter = dropShadow;
			_titleText.pivotX = _titleText.width >> 1;
			_titleText.pivotY = _titleText.height >> 1;
			_titleText.x = stage.stageWidth / 2;
			_titleText.y = stage.stageHeight / 2 - 70;
			addChild(_titleText);*/
			//_selectLevelSprite.addChild(_levelText);
			
			_titleImage = new Image(Assets.getTexture("startLogo"));
			_titleImage.pivotX = _titleImage.width >> 1;
			_titleImage.pivotY = _titleImage.height >> 1;
			_titleImage.x = stage.stageWidth >> 1;
			_titleImage.y = (stage.stageHeight >> 1) - 80;
			addChild(_titleImage);
			
			
			_singleButton = new SimpleButton(quadTex, "进入游戏"/*, null, Assets.getTexture("singlePlayerDown")*/);
			_singleButton.fontColor = fontStyle1.fontColor;
			_singleButton.fontName = fontStyle1.fontName;
			_singleButton.fontSize = fontStyle1.fontSize * 1.1;
			_singleButton.filter = dropShadow;
			_singleButton.x = stage.stageWidth / 2 - _singleButton.width / 2/* - 200*/;
			_singleButton.y = stage.stageHeight / 2 - _singleButton.height / 2 + 50;
			addChild(_singleButton);
			_singleButton.onHover.add(onOver);
			_singleButton.onOut.add(onOut);
			
			_singleButton.addEventListener(Event.TRIGGERED, singleButtonClick);
			
			_developerButton = new SimpleButton(quadTex, "制作人：李雪峰");
			_developerButton.fontColor = fontStyle1.fontColor;
			_developerButton.fontName = fontStyle1.fontName;
			_developerButton.fontSize = fontStyle1.fontSize * 0.5;
			_developerButton.filter = dropShadow;
			_developerButton.x = stage.stageWidth - _developerButton.width - 5;
			_developerButton.y = stage.stageHeight - _developerButton.height - 5;
			addChild(_developerButton);
			
			_developerButton.addEventListener(Event.TRIGGERED, developerButtonClick);
			
			
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		private function onOut(button:SimpleButton):void 
		{
			
		}
		
		private function onOver(button:SimpleButton):void 
		{
			//button.fontColor = 0X020220;
		}
		
		private function developerButtonClick(e:Event):void 
		{
			_ce.sound.playSound("menu_click1");
			//screenController.getSignal[ScreenConst.START_SCREEN][ScreenConst.LOGO_BUTTON_CLICK].dispatch();
			//screenController.dispatchSignal(ScreenConst.TRAIN_START_SCREEN, ScreenConst.DEVELOPER_BUTTON_CLICK, this);	
		}
		
				
		private function singleButtonClick(e:Event):void 
		{
			_ce.sound.playSound("menu_click1");
			screenController.dispatchSignal(ScreenConst.TRAIN_START_SCREEN, ScreenConst.SINGLE_BUTTON_CLICK, this);	
		}
		
	}

}