package ui.screen 
{
	import dragonBones.animation.WorldClock;
	import dragonBones.Armature;
	import dragonBones.Bone;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.ArmatureFactory;
	import assets.Assets;
	import assets.Fonts;
	import constants.ScreenConst;
	import customObjects.Font;
	import data.ArmatureData;
	import data.ArmData;
	import data.Data;
	import data.EquipmentData;
	import data.PlayerData;
	import data.ShoulderMotorData;
	import data.UserData;
	import data.WaistMotorData;
	import ui.AbilityBoard;
	import ui.MessageBoard;
	import ui.MoveSelectBoard;
	import ui.SimpleButton;
	import ui.SimpleWindows;
	import ui.SlideBoard;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class TrainShopScreen extends TrainScreen 
	{
		public static const LESSMONEY:uint = 0;
		public static const OWNEQUIP:uint = 1;
		public static const NOTOWNEQUIP:uint = 2;
		public static const CANBUY:uint = 3;
		public static const NONESELL:uint = 4;
		public static const CANSELL:uint = 5;
		public static const NOTUNLOCK:uint = 6;
		
		
		private var moveSelectBoard:MoveSelectBoard;
		private var armature:Armature;
		private var _backButton:SimpleButton;
		private var _armButton:SimpleButton;
		private var _waistMototButton:SimpleButton;
		private var _shoulderMotorButton:SimpleButton;
		private var _buyButton:SimpleButton;
		private var _sellButton:SimpleButton;
		private var fontMessage:Font;
		private var _moneyText:TextField;
		private var _abilityBoard:AbilityBoard;
		private var _playerData:PlayerData;
		private var fontMessage1:Font;
		private var _priceText:TextField;
		private var _price1Text:TextField;
		private var _messageBoard:MessageBoard;
		private var _slideBoard:SlideBoard;
		
		public function TrainShopScreen() 
		{
			super();			
		}
		
		override protected function initScreens():void 
		{
			super.initScreens();
			
			fontMessage = Fonts.getFont("smooth");
			_backButton = new SimpleButton(Texture.fromColor(110, 40, 0x00000000), "返回");
			_backButton.fontColor = fontMessage.fontColor;
			_backButton.fontName = fontMessage.fontName;
			_backButton.fontSize = fontMessage.fontSize;
			_backButton.x = 0;
			_backButton.y = 0;
			addChild(_backButton);
			
			_backButton.addEventListener(Event.TRIGGERED, backButtonClick);
			
			_armButton = new SimpleButton(Texture.fromColor(90, 40, 0x00000000), "机械臂");
			_armButton.fontColor = fontMessage.fontColor;
			_armButton.fontName = fontMessage.fontName;
			_armButton.fontSize = fontMessage.fontSize * 0.7;
			/*_armButton.x = 80;
			_armButton.y = 100;
			addChild(_armButton);*/
			_armButton.onOut.add(onOut);
			
			_armButton.addEventListener(Event.TRIGGERED, armButtonClick);
			
			_shoulderMotorButton = new SimpleButton(Texture.fromColor(110, 40, 0x00000000), "推动马达");
			_shoulderMotorButton.fontColor = fontMessage.fontColor;
			_shoulderMotorButton.fontName = fontMessage.fontName;
			_shoulderMotorButton.fontSize = fontMessage.fontSize * 0.7;
			/*_shoulderMotorButton.x = _armButton.x + _armButton.width + 50;
			_shoulderMotorButton.y = 100;
			addChild(_shoulderMotorButton);*/
			_shoulderMotorButton.onOut.add(onOut);
			
			_shoulderMotorButton.addEventListener(Event.TRIGGERED, shoulderMotorButtonClick);
			
			_waistMototButton = new SimpleButton(Texture.fromColor(130, 40, 0x00000000), "弹力马达");
			_waistMototButton.fontColor = fontMessage.fontColor;
			_waistMototButton.fontName = fontMessage.fontName;
			_waistMototButton.fontSize = fontMessage.fontSize * 0.7;
			/*_waistMototButton.x = _shoulderMotorButton.x + _shoulderMotorButton.width + 50;
			_waistMototButton.y = 100;
			addChild(_waistMototButton);*/
			_waistMototButton.onOut.add(onOut);
			
			_waistMototButton.addEventListener(Event.TRIGGERED, waistMototButtonClick);
			
			_slideBoard = new SlideBoard();
			addChild(_slideBoard);
			_slideBoard.x = 80;
			_slideBoard.y = 80;
			_slideBoard.addLabel(_armButton);
			_slideBoard.addLabel(_shoulderMotorButton);
			_slideBoard.addLabel(_waistMototButton);
			_slideBoard.changeLable(_armButton);
			
			moveSelectBoard = new MoveSelectBoard();
			moveSelectBoard.x = 300;
			moveSelectBoard.y = 230;
			moveSelectBoard.scaleNum = 0.7;
			moveSelectBoard.middleDataChange.add(middleDataChange);
			addChild(moveSelectBoard);
			moveSelectBoard.setElements(UserData.getInstance().arms);
			
			
			_buyButton = new SimpleButton(Texture.fromColor(150, 40, 0x00000000), "购买");
			_buyButton.fontColor = fontMessage.fontColor;
			_buyButton.fontName = fontMessage.fontName;
			_buyButton.fontSize = fontMessage.fontSize;
			_buyButton.x = 100;
			_buyButton.y = stage.stageHeight - _buyButton.height - 50;
			addChild(_buyButton);
			_buyButton.onHover.add(onOver);
			_buyButton.onOut.add(onOut);
			
			_buyButton.addEventListener(Event.TRIGGERED, buyButtonClick);
			
			
			_sellButton = new SimpleButton(Texture.fromColor(150, 40, 0x00000000), "出售");
			_sellButton.fontColor = fontMessage.fontColor;
			_sellButton.fontName = fontMessage.fontName;
			_sellButton.fontSize = fontMessage.fontSize;
			_sellButton.x = _buyButton.x + _buyButton.width + 100;
			_sellButton.y = _buyButton.y;
			addChild(_sellButton);
			_sellButton.onHover.add(onOver);
			_sellButton.onOut.add(onOut);
			
			_sellButton.addEventListener(Event.TRIGGERED, sellButtonClick);
			
			
			_price1Text = new TextField(100, 40, "价格：");
			_price1Text.x = 215;
			_price1Text.y = stage.stageHeight - _buyButton.height - 100;
			_price1Text.vAlign = VAlign.CENTER;
			_price1Text.hAlign = HAlign.CENTER;
			_price1Text.touchable = false;
			_price1Text.autoScale = true;
			//fontMessage1 = Fonts.getFont("stencil");
			_price1Text.color = /*fontMessage1.fontColor*/0XFFFFFF;
			_price1Text.fontName = fontMessage.fontName;
			_price1Text.fontSize = fontMessage.fontSize * 0.9;
			addChild(_price1Text);
			
			_priceText = new TextField(60, 40, String(UserData.getInstance().money));
			_priceText.x = _price1Text.x + _price1Text.width;
			_priceText.y = _price1Text.y + 3;
			_priceText.vAlign = VAlign.CENTER;
			_priceText.hAlign = HAlign.CENTER;
			_priceText.touchable = false;
			_priceText.autoScale = true;
			fontMessage1 = Fonts.getFont("stencil");
			_priceText.color = /*fontMessage1.fontColor*/0XFFFFFF;
			_priceText.fontName = fontMessage1.fontName;
			_priceText.fontSize = fontMessage1.fontSize;
			_priceText.text = String(moveSelectBoard.getSelectElement().price);
			addChild(_priceText);
			
			var factoryName:String = Assets.getXML("Armature").@factoryName;
			armature = ArmatureFactory.getArmature(factoryName, "robot");
			(armature.display as DisplayObject).x = stage.stageWidth - 100;
			(armature.display as DisplayObject).y = (stage.stageHeight >> 1) - 50;
			(armature.display as DisplayObject).scaleX = 0.6;
			(armature.display as DisplayObject).scaleY = 0.6;
			addChild(armature.display as DisplayObject);
			armature.animation.gotoAndPlay("stop");
			WorldClock.clock.add(armature);
			
			_moneyText = new TextField(100, 40, "$ " + String(UserData.getInstance().money));
			_moneyText.x = stage.stageWidth - _moneyText.width;
			_moneyText.y = 0;
			_moneyText.vAlign = VAlign.CENTER;
			_moneyText.hAlign = HAlign.CENTER;
			_moneyText.touchable = false;
			_moneyText.autoScale = true;
			fontMessage1 = Fonts.getFont("stencil");
			_moneyText.color = /*fontMessage1.fontColor*/0XE8D706;
			_moneyText.fontName = fontMessage1.fontName;
			_moneyText.fontSize = fontMessage1.fontSize;
			addChild(_moneyText);
			
			
			//玩家角色信息创建
			_playerData = new PlayerData();
			_playerData.armatureData = new ArmatureData(0);
			
			_playerData.setArm(UserData.getInstance().unLockArms[0] as ArmData);
			_playerData.setShoulderMotor(UserData.getInstance().unLockShoulderMotors[0] as ShoulderMotorData);
			_playerData.setWaistMotor(UserData.getInstance().unLockWaistMotors[0] as WaistMotorData);
			
			_abilityBoard = new AbilityBoard();			
			addChild(_abilityBoard);
			_abilityBoard.x = (armature.display as DisplayObject).x - _abilityBoard.width / 2 - 20;
			_abilityBoard.y = stage.stageHeight - _abilityBoard.height - 30;
			_abilityBoard.setAbility(_playerData.equipAbility);
		}
		
		private function onOut(button:SimpleButton):void 
		{
			button.fontColor = fontMessage.fontColor;
		}
		
		private function onOver(button:SimpleButton):void 
		{
			//button.fontColor = 0X000000;
		}
		
		private function sellButtonClick(e:Event):void 
		{
			var state:uint = NOTOWNEQUIP;
			var data:EquipmentData = moveSelectBoard.getSelectElement();
			if (data is ArmData)
			{
				if (UserData.getInstance().ownArms.indexOf(data) != -1)
				{
					state = OWNEQUIP;
				}
			}
			else if (data is ShoulderMotorData)
			{
				if (UserData.getInstance().ownShoulderMotors.indexOf(data) != -1)
				{
					state = OWNEQUIP;
				}
			}
			else if (data is WaistMotorData)
			{
				if (UserData.getInstance().ownWaistMotors.indexOf(data) != -1)
				{
					state = OWNEQUIP;
				}
			}
			
			if (state == OWNEQUIP)
			{
				if ((data as EquipmentData).id == 0)
				{
					state = NONESELL;
					
				}
				else
				{
					state = CANSELL;
				}
				
			}
			
			if (state == NONESELL)
			{
				_messageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "您不能卖掉这个装备，否则您就一无所有了", 2000);
				_messageBoard.fontColor = fontMessage.fontColor;
				_messageBoard.fontName = fontMessage.fontName;
				_messageBoard.fontSize = fontMessage.fontSize;
				addChild(_messageBoard);
				_ce.sound.playSound("menu_error");
			}
			else if (state == CANSELL)
			{
				var simpleWindows:SimpleWindows = new SimpleWindows();
				addChild(simpleWindows);
				simpleWindows.setText("确定以半价出售该武器?");
				simpleWindows.OKSignal.add(sellOK);
				simpleWindows.cancelSignal.add(sellCancel);
			}
			else if (state == NOTOWNEQUIP)
			{
				_messageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "你没有该装备，不能出售", 2000);
				_messageBoard.fontColor = fontMessage.fontColor;
				_messageBoard.fontName = fontMessage.fontName;
				_messageBoard.fontSize = fontMessage.fontSize;
				addChild(_messageBoard);
				_ce.sound.playSound("menu_error");
			}
			
			
		}
		
		private function sellCancel():void 
		{
			
		}
		
		private function sellOK():void 
		{
			var _messageBoard:MessageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "出售成功", 2000);
			_messageBoard.fontColor = fontMessage.fontColor;
			_messageBoard.fontName = fontMessage.fontName;
			_messageBoard.fontSize = fontMessage.fontSize;
			addChild(_messageBoard);
			
			var data:EquipmentData = moveSelectBoard.getSelectElement();
			var ownArms:Vector.<EquipmentData> = UserData.getInstance().ownArms;
			var ownShoulderMotors:Vector.<EquipmentData> = UserData.getInstance().ownShoulderMotors;
			var ownWaistMotors:Vector.<EquipmentData> = UserData.getInstance().ownWaistMotors;
			if (data is ArmData)
			{
				ownArms.splice(ownArms.indexOf(data), 1);
			}
			else if (data is ShoulderMotorData)
			{
				ownShoulderMotors.splice(ownShoulderMotors.indexOf(data), 1);
			}
			else if (data is WaistMotorData)
			{
				ownWaistMotors.splice(ownWaistMotors.indexOf(data), 1);
			}
			UserData.getInstance().money += (data as EquipmentData).price / 2;
			_moneyText.text =  "$ " + String(UserData.getInstance().money);
		}
		
		private function buyButtonClick(e:Event):void 
		{
			var state:uint = LESSMONEY;
			var data:EquipmentData = moveSelectBoard.getSelectElement();
			if (data is ArmData)
			{
				if (UserData.getInstance().ownArms.indexOf(data) != -1)
				{
					state = OWNEQUIP;
				}
				else if (UserData.getInstance().unLockArms.indexOf(data) == -1)
				{
					state = NOTUNLOCK;
				}
				else if (UserData.getInstance().money < (data as ArmData).price)
				{
					state = LESSMONEY;
				}				
				else
				{
					state = CANBUY;
				}
			}
			else if (data is ShoulderMotorData)
			{
				if (UserData.getInstance().ownShoulderMotors.indexOf(data) != -1)
				{
					state = OWNEQUIP;
				}
				else if (UserData.getInstance().unLockShoulderMotors.indexOf(data) == -1)
				{
					state = NOTUNLOCK;
				}
				else if (UserData.getInstance().money < (data as EquipmentData).price)
				{
					state = LESSMONEY;
				}
				else
				{
					state = CANBUY;
				}
			}
			else if (data is WaistMotorData)
			{
				if (UserData.getInstance().ownWaistMotors.indexOf(data) != -1)
				{
					state = OWNEQUIP;
				}
				else if (UserData.getInstance().unLockWaistMotors.indexOf(data) == -1)
				{
					state = NOTUNLOCK;
				}
				else if (UserData.getInstance().money < (data as EquipmentData).price)
				{
					state = LESSMONEY;
				}
				else
				{
					state = CANBUY;
				}
			}
			
			if (state == CANBUY)
			{
				var simpleWindows:SimpleWindows = new SimpleWindows();
				addChild(simpleWindows);
				simpleWindows.setText("确定要买该装备吗？");
				simpleWindows.OKSignal.add(buyOK);
				simpleWindows.cancelSignal.add(buyCancel);
			}
			else if (state == NOTUNLOCK)
			{
				_messageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "该装备未解锁", 2000);
				_messageBoard.fontColor = fontMessage.fontColor;
				_messageBoard.fontName = fontMessage.fontName;
				_messageBoard.fontSize = fontMessage.fontSize;
				addChild(_messageBoard);
				_ce.sound.playSound("menu_error");
			}
			else if(state == OWNEQUIP)
			{
				_messageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "您已经拥有了该装备", 2000);
				_messageBoard.fontColor = fontMessage.fontColor;
				_messageBoard.fontName = fontMessage.fontName;
				_messageBoard.fontSize = fontMessage.fontSize;
				addChild(_messageBoard);
				_ce.sound.playSound("menu_error");
			}
			else if (state == LESSMONEY)
			{
				_messageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "您没有足够的钱", 2000);
				_messageBoard.fontColor = fontMessage.fontColor;
				_messageBoard.fontName = fontMessage.fontName;
				_messageBoard.fontSize = fontMessage.fontSize;
				addChild(_messageBoard);
				_ce.sound.playSound("menu_error");
			}
		}
		
		private function buyCancel():void 
		{
			
		}
		
		private function buyOK():void 
		{
			_ce.sound.playSound("menu_buttenreset");
			
			var _messageBoard:MessageBoard = new MessageBoard(Assets.getTexture("messageBackground") , "您成功购买了该装备", 2000);
			_messageBoard.fontColor = fontMessage.fontColor;
			_messageBoard.fontName = fontMessage.fontName;
			_messageBoard.fontSize = fontMessage.fontSize;
			addChild(_messageBoard);
			var data:EquipmentData = moveSelectBoard.getSelectElement();
			if (data is ArmData)
			{
				UserData.getInstance().ownArms.push(data);
			}
			else if (data is ShoulderMotorData)
			{
				UserData.getInstance().ownShoulderMotors.push(data);
			}
			else if (data is WaistMotorData)
			{
				UserData.getInstance().ownWaistMotors.push(data);
			}
			
			UserData.getInstance().money -= (data as EquipmentData).price;
			_moneyText.text =  "$ " + String(UserData.getInstance().money);
		}
		
		private function waistMototButtonClick(e:Event):void 
		{
			_slideBoard.changeLable(e.currentTarget as SimpleButton);
			
			moveSelectBoard.setElements(UserData.getInstance().waistMotors);
			/*if (UserData.getInstance().unLockWaistMotors.indexOf(moveSelectBoard.getSelectElement()) == -1)
			{
				//moveSelectBoard.lockImage.alpha = 1;
				moveSelectBoard.setLock(true);
			}
			else
			{
				//moveSelectBoard.lockImage.alpha = 0;
				moveSelectBoard.setLock(false);
			}*/
		}
		
		private function shoulderMotorButtonClick(e:Event):void 
		{
			_slideBoard.changeLable(e.currentTarget as SimpleButton);
			
			moveSelectBoard.setElements(UserData.getInstance().shoulderMotors);
			if (UserData.getInstance().unLockShoulderMotors.indexOf(moveSelectBoard.getSelectElement()) == -1)
			{
				//moveSelectBoard.lockImage.alpha = 1;
				//moveSelectBoard.setLock(true);
			}
			else
			{
				//moveSelectBoard.lockImage.alpha = 0;
				//moveSelectBoard.setLock(false);
			}
		}
		
		private function armButtonClick(e:Event):void 
		{
			_slideBoard.changeLable(e.currentTarget as SimpleButton);
			
			moveSelectBoard.setElements(UserData.getInstance().arms);
			if (UserData.getInstance().unLockArms.indexOf(moveSelectBoard.getSelectElement()) == -1)
			{
				//moveSelectBoard.lockImage.alpha = 1;
				//moveSelectBoard.setLock(true);
			}
			else
			{
				//moveSelectBoard.lockImage.alpha = 0;
				//moveSelectBoard.setLock(false);
			}
		}
		
		private function middleDataChange(data:Data):void 
		{
			_ce.sound.playSound("menu_buywepon");
			
			if (data is ArmData)
			{
		
				if (UserData.getInstance().unLockArms.indexOf(data) == -1)
				{
					//moveSelectBoard.lockImage.alpha = 1;
					//moveSelectBoard.setLock(true);
				}
				else
				{
					//moveSelectBoard.lockImage.alpha = 0;
					//moveSelectBoard.setLock(false);
					
					var _armImage1:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay((data as ArmData).path) as Image;
					var _armImage2:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay((data as ArmData).path2) as Image;
					var _arm1Bone:Bone;
					var _arm2Bone:Bone;
					
					_arm1Bone = armature.getBone((data as ArmData).bone1);
					_arm2Bone = armature.getBone((data as ArmData).bone2);
					
					_arm1Bone.display.dispose();
					_arm2Bone.display.dispose();
					
					_arm1Bone.display = _armImage1;
					_arm2Bone.display = _armImage2;
					
					_playerData.setArm(data as ArmData);
					_abilityBoard.setAbility(_playerData.equipAbility);
				}
				
			}	
			
			if (data is ShoulderMotorData)
			{
				if (UserData.getInstance().unLockShoulderMotors.indexOf(data) == -1)
				{
					//moveSelectBoard.lockImage.alpha = 1;
					//moveSelectBoard.setLock(true);
				}
				else
				{
					//moveSelectBoard.lockImage.alpha = 0;
					//moveSelectBoard.setLock(false);
					
					var _shoulderBone:Bone;
					var _shoulderImage:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay((data as ShoulderMotorData).path) as Image;
					_shoulderBone = armature.getBone((data as ShoulderMotorData).bone);
					
					_shoulderBone.display.dispose();
					
					_shoulderBone.display = _shoulderImage;
					_playerData.setShoulderMotor(data as ShoulderMotorData);
					_abilityBoard.setAbility(_playerData.equipAbility);
				}
			}
			
			if (data is WaistMotorData)
			{	
				if (UserData.getInstance().unLockWaistMotors.indexOf(data) == -1)
				{
						//moveSelectBoard.lockImage.alpha = 1;
					//moveSelectBoard.setLock(true);
				}
				else
				{
					//moveSelectBoard.lockImage.alpha = 0;
					//moveSelectBoard.setLock(false);
					
					var _waistMotorImage1:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay((data as WaistMotorData).path) as Image;
					var _waistMotorImage2:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay((data as WaistMotorData).path2) as Image;
					var _waistMotor1Bone:Bone;
					var _waistMotor2Bone:Bone;
					
					_waistMotor1Bone = armature.getBone((data as WaistMotorData).bone1);
					_waistMotor2Bone = armature.getBone((data as WaistMotorData).bone2);
					
					_waistMotor1Bone.display.dispose();
					_waistMotor2Bone.display.dispose();
					
					_waistMotor1Bone.display = _waistMotorImage1;
					_waistMotor2Bone.display = _waistMotorImage2;
					
					_playerData.setWaistMotor(data as WaistMotorData);
					_abilityBoard.setAbility(_playerData.equipAbility);
				}
				
			}
			_priceText.text = String(moveSelectBoard.getSelectElement().price);
		}
		
		private function backButtonClick(e:Event):void 
		{
			UserData.getInstance().saveData();
			screenController.dispatchSignal(ScreenConst.TRAIN_SHOP_SCREEN, ScreenConst.BACK_BUTTON_CLICK, this);
		}
		
	}

}