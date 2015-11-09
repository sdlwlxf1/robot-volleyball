package test2
{
	import citrus.core.CitrusObject;
	import flash.utils.setTimeout;
	import test2.logic.Logic;
	import test2.logic.Process;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerLogic extends ControledObjectLogic
	{
		private var player:Player;
		
		public function PlayerLogic(object:CitrusObject)
		{
			super(object);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			player = _object as Player;
		}
		
		override protected function initLogicTree():void
		{
			super.initLogicTree();
			getOrderByName("hit").addChild(getActionByName("hit"), this);
			getActionByName("hit").addChild(getActionByName("hitDelay"), this);
			
			getActionByName("hit").addChild(getActionByName("jumpHit"), this);
			getActionByName("jumpHit").addChild(getActionByName("jumpHitBall"), this);
			
			getActionByName("hit").addChild(getActionByName("generalHit"), this);
			getActionByName("generalHit").addChild(getActionByName("generalHitBall"), this);
			
			getActionByName("hit").addChild(getActionByName("squatHit"), this);
			getActionByName("squatHit").addChild(getActionByName("squatHitBall"), this);
			
			getOrderByName("serve").addChild(getActionByName("serve"), this);
			getOrderByName("takeBall").addChild(getActionByName("takeBall"), this);
			getOrderByName("moveToServe").addChild(getActionByName("moveToServe"), this);
			
			getActionByName("jumpHitBall").addChild(getActionByName("hitBall"), this);
			getActionByName("generalHitBall").addChild(getActionByName("hitBall"), this);
			getActionByName("squatHitBall").addChild(getActionByName("hitBall"), this);
		}
		
		override public function getCondition(process:Process, type:uint):Object
		{
			switch (process.name)
			{
				case "hit": 
					switch (type)
				{
					case Process.BEGIN: 
						return null;
						break;
					case Process.END: 
						return null /*getStateByName("upperHandInRange").phase == Process.OFF*/;
						break;
				}
					break;
				case "hitDelay": 
					switch (type)
				{
					case Process.BEGIN: 
						return null;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "jumpHit": 
					switch (type)
				{
					case Process.BEGIN: 
						return getActionByName("hit").phase == Process.BEGIN && getStateByName("onGround").phase == Process.OFF;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "jumpHitBall": 
					switch (type)
				{
					case Process.BEGIN: 
						return getStateByName("upperHandTouchBall").phase == Process.BEGIN;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "generalHit": 
					switch (type)
				{
					case Process.BEGIN: 
						return getActionByName("hit").phase == Process.BEGIN && getActionByName("squat").phase == Process.OFF && getStateByName("onGround").phase > 0;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "generalHitBall": 
					switch (type)
				{
					case Process.BEGIN: 
						return getStateByName("upperHandTouchBall").phase == Process.BEGIN;
						break;
					case Process.END: 
						return null; /*getStateByName("handTouchBall").phase == Process.END*/
						break;
				}
					break;
				case "squatHit": 
					switch (type)
				{
					case Process.BEGIN: 
						return getActionByName("hit").phase == Process.BEGIN && getActionByName("squat").phase > 0 && getStateByName("onGround").phase > 0;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "squatHitBall": 
					switch (type)
				{
					case Process.BEGIN: 
						return getStateByName("underHandTouchBall").phase == Process.BEGIN;
						break;
					case Process.END: 
						return null; /*getStateByName("handTouchBall").phase == Process.END*/
						break;
				}
					break;
				case "serve": 
					switch (type)
				{
					case Process.BEGIN: 
						return null;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "takeBall": 
					switch (type)
				{
					case Process.BEGIN: 
						return null;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "hitBall": 
					switch (type)
				{
					case Process.BEGIN: 
						return null;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "moveToServe": 
					switch (type)
				{
					case Process.BEGIN: 
						return null;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
			
			}
			return super.getCondition(process, type);
		}
		
		override protected function updateOrders():void
		{
			if (getStateByName("matchBegin").phase == Process.BEGIN)
			{
				player.stop();
				trace(player.name + "比赛开始");
				getStateByName("getScore").phase = Process.END;
				player.x = player.invertedBody ? player.ce.stage.stageWidth - 100 : 100;
				player.hitBall.x = player.invertedBody ? player.x - player.width * 1.3 : player.x + player.width * 1.3;
				player.hitBall.y = player.y - player.height * 1.5 /* * 0.18*/;
			}
			if (getStateByName("matchBegin").phase > 0)
			{
				switch (_control)
				{
					case "keyboard1": 
						if (_ce.input.justDid("rightCtrl"))
						{
							if (getStateByName("takeBallExtent").phase > 0)
							{
								getOrderByName("serve").phase = Process.BEGIN;
							}
							else
							{
								getOrderByName("hit").phase = Process.BEGIN;
							}
						}
						else if (_ce.input.justEnd("rightCtrl"))
						{
							getOrderByName("serve").phase = Process.END;
								//getOrderByName("hit").phase = Process.END;
						}
						break;
					case "keyboard2": 
						if (_ce.input.justDid("space"))
						{
							if (getStateByName("takeBallExtent").phase > 0)
							{
								getOrderByName("serve").phase = Process.BEGIN;
							}
							else
							{
								getOrderByName("hit").phase = Process.BEGIN;
							}
						}
						else if (_ce.input.justEnd("space"))
						{
							getOrderByName("serve").phase = Process.END;
								//getOrderByName("hit").phase = Process.END;
						}
						break;
					case "auto":
						
						if (getOrderByName("takeBall").phase > 0)
						{
							getOrderByName("serve").phase = Process.BEGIN;
						}
						if (getOrderByName("serve").phase == Process.BEGIN)
						{
							setTimeout(function hitBall():void
								{
									getOrderByName("hit").phase = Process.BEGIN;
								}, 1000);
						}
						break;
				}
				if (getStateByName("waitBallExtent").phase > 0)
				{
					getOrderByName("serve").phase = Process.END;
				}
				
				if (getStateByName("takeBallExtent").phase > 0 && getOrderByName("serve").phase == Process.OFF)
				{
					getOrderByName("takeBall").phase = Process.BEGIN;
				}
				else
				{
					getOrderByName("takeBall").phase = Process.END;
				}
				
				if (getStateByName("upperHandInRange").phase == Process.OFF)
				{
					trace("超限");
					getOrderByName("hit").phase = Process.END;
				}
				
				if (getActionByName("hitBall").phase > 0)
				{
					getStateByName("matchBegin").phase = Process.END;
					getStateByName("matchOn").phase = Process.BEGIN;
					player.opponent.getStateByName("matchBegin").phase = Process.END;
					player.opponent.getStateByName("matchOn").phase = Process.BEGIN;
				}
			}
			else if (getStateByName("matchOn").phase > 0)
			{
				switch (_control)
				{
					case "keyboard1": 
						if (_ce.input.justDid("rightCtrl"))
						{
							getOrderByName("hit").phase = Process.BEGIN;
						}
						/*else if (_ce.input.justEnd("rightCtrl"))
						   {
						   getOrderByName("hit").phase = Process.END;
						 }*/
						break;
					case "keyboard2": 
						if (_ce.input.justDid("space"))
						{
							getOrderByName("hit").phase = Process.BEGIN;
						}
						/*else if (_ce.input.justEnd("space"))
						   {
						   getOrderByName("hit").phase = Process.END;
						 }*/
						break;
					case "auto": 
						if (getStateByName("youTurn").phase == Process.ON)
						{
							if (getStateByName("hitAreaTouchBall").phase == Process.BEGIN)
							{
								getOrderByName("hit").phase = Process.BEGIN;
							}
							
							if (getStateByName("ballIsRight").phase == Process.BEGIN)
							{
								//trace(player.name + "球在右边开始");
								getOrderByName("moveLeft").phase = Process.END;
								getOrderByName("moveRight").phase = Process.BEGIN;
								getOrderByName("move").phase = Process.BEGIN;
							}
							else if (getStateByName("ballIsRight").phase == Process.END)
							{
								
							}
							
							else if (getStateByName("ballIsLeft").phase == Process.BEGIN)
							{
								//trace(player.name + "球在左边开始");
								getOrderByName("moveRight").phase = Process.END;
								getOrderByName("moveLeft").phase = Process.BEGIN;
								getOrderByName("move").phase = Process.BEGIN;
							}
							else if (getStateByName("ballIsLeft").phase == Process.END)
							{
								
							}
							
						}
						else if (getStateByName("youTurn").phase == Process.END /* || getStateByName("ballOnGround").phase == Process.BEGIN*/)
						{
							//trace(player.name + "击球结束");
							//trace("击球结束停止");
							player.stop();
							
						}
						else if (getStateByName("youTurn").phase == Process.BEGIN)
						{
							//trace(player.name + "准备击球");
						}
						
						break;
				
				}
				if (getStateByName("ballOnGround").phase == Process.BEGIN)
				{
					//trace(player.name + "球落地");
					
				}
				if (getStateByName("upperHandInRange").phase == Process.OFF)
				{
					trace("超限");
					getOrderByName("hit").phase = Process.END;
				}
				
				if (getStateByName("score").phase == Process.BEGIN)
				{
					player.opponent.stop();
					
					trace(player.name + "得分");
					/*getStateByName("matchOn").phase = Process.END;
					   player.opponent.getStateByName("matchOn").phase = Process.END;
					   getStateByName("matchEnd").phase = Process.BEGIN;
					   player.opponent.getStateByName("matchEnd").phase = Process.BEGIN;
					 player.onLose.dispatch();*/
				}
				
			}
			else if (getStateByName("matchEnd").phase > 0)
			{
				if (getStateByName("score").phase == Process.END)
				{
					//trace(player.name + "发球");
					if (getStateByName("getScore").phase == Process.OFF)
					{
						setTimeout(function matchBegin():void
							{
								getStateByName("matchBegin").phase = Process.BEGIN;
							}, 2000);
						//getStateByName("matchBegin").phase = Process.BEGIN;
						getStateByName("getScore").phase = Process.BEGIN;
					}
				}
			}
			super.updateOrders();
		
		}
		
		override public function getClass():Class
		{
			return PlayerLogic;
		}
	
	}

}