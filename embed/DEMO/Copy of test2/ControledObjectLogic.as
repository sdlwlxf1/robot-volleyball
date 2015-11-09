package test2
{
	import citrus.core.CitrusObject;
	import test2.logic.Logic;
	import test2.logic.Order;
	import test2.logic.Process;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ControledObjectLogic extends DynamicObjectLogic
	{
		private var controledObject:ControledObject;
		
		public function ControledObjectLogic(object:CitrusObject)
		{
			super(object);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			controledObject = _object as ControledObject;
			_control = controledObject.control;
		}
		
		override protected function initLogicTree():void
		{
			super.initLogicTree();
			getOrderByName("moveRight").addChild(getActionByName("moveRight"), this);
			getOrderByName("moveLeft").addChild(getActionByName("moveLeft"), this);
			
			getOrderByName("move").addChild(getActionByName("move"), this);
			
			getOrderByName("jump").addChild(getActionByName("jump"), this);
			getActionByName("jump").addChild(getActionByName("jumpAcceleration"), this);
			getOrderByName("squat").addChild(getActionByName("squat"), this);
		}
		
		override public function getCondition(process:Process, type:uint):Object
		{
			switch (process.name)
			{
				case "moveRight": 
					switch (type)
				{
					case Process.BEGIN: 
						return getActionByName("squat").phase == Process.OFF;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "moveLeft": 
					switch (type)
				{
					case Process.BEGIN: 
						return getActionByName("squat").phase == Process.OFF;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "jump": 
					switch (type)
				{
					case Process.BEGIN: 
						return getOrderByName("jump").phase == Process.BEGIN && getStateByName("onGround").phase;
						break;
					case Process.END: 
						return null;
						break;
				}
					break;
				case "jumpAcceleration": 
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
				case "squat": 
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
				case "move": 
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
				default: 
					return null;
			}
			return null;
		}
		
		override protected function updateOrders():void
		{
			if (getStateByName("matchBegin").phase > 0)
			{
				switch (_control)
				{
					case "keyboard1": 
						break;
					case "keyboard2": 
						break;
					case "auto": 
						break;
				}
				
			}
			else if (getStateByName("matchOn").phase > 0 || (controledObject as Player).opponent.getStateByName("matchBegin").phase > 0)
			{
				switch (_control)
				{
					case "keyboard1": 
						if (_ce.input.justDid("right"))
						{
							getOrderByName("moveRight").phase = Process.BEGIN;						
							getOrderByName("move").phase = Process.BEGIN;
						}
						else if (_ce.input.justEnd("right"))
						{
							getOrderByName("moveRight").phase = Process.END;
							if (!_ce.input.isDoing("left"))
							{
								getOrderByName("move").phase = Process.END;
							}
						}
						
						if (_ce.input.justDid("left"))
						{
							getOrderByName("moveLeft").phase = Process.BEGIN;
							getOrderByName("move").phase = Process.BEGIN;
						}
						else if (_ce.input.justEnd("left"))
						{
							getOrderByName("moveLeft").phase = Process.END;
							if (!_ce.input.isDoing("right"))
							{
								getOrderByName("move").phase = Process.END;
							}
						}
						
						if (_ce.input.justDid("up"))
						{
							getOrderByName("jump").phase = Process.BEGIN;
						}
						else if (_ce.input.justEnd("up"))
						{
							getOrderByName("jump").phase = Process.END;
						}
						
						if (_ce.input.justDid("down"))
						{
							getOrderByName("squat").phase = Process.BEGIN;
						}
						else if (_ce.input.justEnd("down"))
						{
							getOrderByName("squat").phase = Process.END;
						}
						break;
					case "keyboard2": 
						if (_ce.input.justDid("d"))
						{
							getOrderByName("moveRight").phase = Process.BEGIN;
						}
						else if (_ce.input.justDid("a"))
						{
							getOrderByName("moveLeft").phase = Process.BEGIN;
						}
						else if (_ce.input.justEnd("d"))
						{
							getOrderByName("moveRight").phase = Process.END;
						}
						else if (_ce.input.justEnd("a"))
						{
							getOrderByName("moveLeft").phase = Process.END;
						}
						
						if (_ce.input.justDid("w"))
						{
							getOrderByName("jump").phase = Process.BEGIN;
						}
						else if (_ce.input.justEnd("w"))
						{
							getOrderByName("jump").phase = Process.END;
						}
						
						if (_ce.input.justDid("s"))
						{
							getOrderByName("squat").phase = Process.BEGIN;
						}
						else if (_ce.input.justEnd("s"))
						{
							getOrderByName("squat").phase = Process.END;
						}
						break;
					case "auto": 
						break;
				}
				
				/*if (getStateByName("touchWall").phase == Process.BEGIN)
				{
					trace("touchWall");
					if (getOrderByName("moveRight").phase == Process.ON)
					{
						getOrderByName("moveRight").phase = Process.END;
					}
					if (getOrderByName("moveLeft").phase == Process.ON)
					{
						getOrderByName("moveLeft").phase = Process.END;
					}
				}*/
				
			}
			super.updateOrders();
		}
		
		override public function getClass():Class
		{
			return DynamicObjectLogic;
		}
	
	}

}