package test2.ui
{
	import citrus.core.CitrusEngine;
	import org.osflash.signals.Signal;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.customObjects.Font;
	import test2.data.ArmData;
	import test2.data.RewardData;
	import test2.data.ShoulderMotorData;
	import test2.data.UserData;
	import test2.data.WaistMotorData;
	import test2.logic.gameLogic.LevelController;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class RewardBoard extends Sprite
	{
		
		private var _rewardData:RewardData;
		private var _messageBoard:MessageBoard;
		private var fontMessage:Font;
		
		public var onOver:Signal;
		
		public function RewardBoard(rewardData:RewardData)
		{
			super();
			_rewardData = rewardData;
			onOver = new Signal();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			fontMessage = Fonts.getFont("black");
			
			_messageBoard = new MessageBoard(Assets.getTexture("messageBackground"), "恭喜你\n" + "获得" + _rewardData.experience + "经验" + "\n" + "获得" + _rewardData.money + "金钱", 2000);
			_messageBoard.fontColor = fontMessage.fontColor;
			_messageBoard.fontName = fontMessage.fontName;
			_messageBoard.fontSize = fontMessage.fontSize;
			_messageBoard.addToParent(this);
			
			_messageBoard.onOver.add(moneyOver);
			
			UserData.getInstance().experience += _rewardData.experience;
			UserData.getInstance().money += _rewardData.money;
		}
		
		private function moneyOver():void
		{
			if (_rewardData.unlockMapData)
			{						
				if (UserData.getInstance().unLockMaps.indexOf(_rewardData.unlockMapData) != -1)
				{
					mapOver();
				}
				else
				{
					UserData.getInstance().unLockMaps.push(_rewardData.unlockMapData);
					
					_messageBoard = new MessageBoard(Assets.getTexture("messageBackground"), "解锁新地图", 2000);
					_messageBoard.fontColor = fontMessage.fontColor;
					_messageBoard.fontName = fontMessage.fontName;
					_messageBoard.fontSize = fontMessage.fontSize;
					_messageBoard.textHAlign = HAlign.CENTER;
					_messageBoard.textVAlign = VAlign.BOTTOM;
					
					var mapImage:Image = new Image(Assets.getTexture(_rewardData.unlockMapData.path))
					mapImage.pivotX = mapImage.width >> 1;
					mapImage.pivotY = mapImage.height >> 1;
					
					mapImage.scaleX = 0.2;
					mapImage.scaleY = 0.2;
					mapImage.x = _messageBoard.mContents.width >> 1;
					mapImage.y = (mapImage.height >> 1) + 20;
					
					_messageBoard.mContents.addChild(mapImage);
					
					
					_messageBoard.addToParent(this);
					
					_messageBoard.onOver.add(mapOver);
				}		
				
			}
			else
			{
				mapOver();
			}
		}
		
		private function mapOver():void
		{
			if (_rewardData.unlockArmatrueData)
			{
				
				if (_rewardData.unlockArmatrueData is ArmData)
				{
					//equipmentImage.rotation = -Math.PI / 4 * 3;
					
					if (UserData.getInstance().unLockArms.indexOf(_rewardData.unlockArmatrueData) != -1)
					{
						equipmentOver();
					}
					else
					{
						UserData.getInstance().unLockArms.push(_rewardData.unlockArmatrueData);
						equipmentMessage();
					}
				}
				else if (_rewardData.unlockArmatrueData is WaistMotorData)
				{
					if (UserData.getInstance().unLockWaistMotors.indexOf(_rewardData.unlockArmatrueData) != -1)
					{
						equipmentOver();
					}
					else
					{
						UserData.getInstance().unLockWaistMotors.push(_rewardData.unlockArmatrueData);
						equipmentMessage();
					}
					
				}
				else if (_rewardData.unlockArmatrueData is ShoulderMotorData)
				{
					if (UserData.getInstance().unLockShoulderMotors.indexOf(_rewardData.unlockArmatrueData) != -1)
					{
						equipmentOver();
					}
					else
					{
						UserData.getInstance().unLockShoulderMotors.push(_rewardData.unlockArmatrueData);
						equipmentMessage();
					}
					
				}
				
			}
			else
			{
				equipmentOver();
			}
		}
		
		private function equipmentMessage():void
		{
			_messageBoard = new MessageBoard(Assets.getTexture("messageBackground"), "解锁新装备可以购买", 0, true);
			_messageBoard.fontColor = fontMessage.fontColor;
			_messageBoard.fontName = fontMessage.fontName;
			_messageBoard.fontSize = fontMessage.fontSize;
			_messageBoard.textHAlign = HAlign.CENTER;
			_messageBoard.textVAlign = VAlign.BOTTOM;

			
			var equipmentImage:Image = new Image(Assets.getTexture(_rewardData.unlockArmatrueData.path))
			equipmentImage.pivotX = equipmentImage.width >> 1;
			equipmentImage.pivotY = equipmentImage.height >> 1;
			
			equipmentImage.scaleX = 0.8;
			equipmentImage.scaleY = 0.8;
			/*equipmentImage.x = Starling.current.stage.stageWidth >> 1;
			equipmentImage.y = Starling.current.stage.stageHeight >> 1;*/
			
			_messageBoard.mContents.addChild(equipmentImage);
			equipmentImage.x = _messageBoard.mContents.width >> 1;
			equipmentImage.y = equipmentImage.height >> 1;
			
			//equipmentImage.y = equipmentImage.width >> 1;
			
			if (_rewardData.unlockArmatrueData is ArmData)
			{
				equipmentImage.rotation = Math.PI / 2;
			}
			
			_messageBoard.addToParent(this);
			
			_messageBoard.onOver.add(equipmentOver);
		}
		
		private function equipmentOver():void
		{
			onOver.dispatch();
		}
	
	}

}