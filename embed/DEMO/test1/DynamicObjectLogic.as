package test1 
{
	import citrus.core.CitrusObject;
	import test1.logic.Logic;
	import test1.logic.Order;
	import test1.logic.Process;
	/**
	 * ...
	 * @author ...
	 */
	public class DynamicObjectLogic extends Logic 
	{
		private var dynamicObject:DynamicObject;
		
		public function DynamicObjectLogic(object:CitrusObject) 
		{
			super(object);	
		}
		
		override public function initialize():void
		{
			super.initialize();
						
			dynamicObject = _object as DynamicObject;
			_control = dynamicObject.control;
			
			addOrderByName("moveLeft");
			addOrderByName("moveRight");
			addOrderByName("move");
			addOrderByName("jump");			
			addOrderByName("squat");
			
			addStateByName("moveLeft");
			addStateByName("moveRight");
			addStateByName("moveLeftMax");
			addStateByName("moveRightMax");
			addStateByName("stop");
			addStateByName("fall");
			addStateByName("rise");
			addStateByName("inAir", Logic.ONCE);
			
			addActionByName("moveLeft");
			addActionByName("moveRight");
			addActionByName("jump");
			addActionByName("move");
			addActionByName("squat");
			addActionByName("jumpAcceleration");
		}
		
		override protected function updateOrders():void
		{			
			setAllOrdersPhase(Process.OFF);
			
			if (_control == "keyboard")
			{
				if (_ce.input.justDid("right"))
				{
					getOrderByName("moveRight").phase = Process.BEGIN;
					getOrderByName("move").phase = Process.BEGIN;
				}
				else if (_ce.input.justDid("left"))
				{
					getOrderByName("moveLeft").phase = Process.BEGIN;
					getOrderByName("move").phase = Process.BEGIN;
				}
				else if (_ce.input.isDoing("right"))
				{
					getOrderByName("moveRight").phase = Process.ON;
					getOrderByName("move").phase = Process.ON;
				}
				else if (_ce.input.isDoing("left"))
				{
					getOrderByName("moveLeft").phase = Process.ON;
					getOrderByName("move").phase = Process.ON;
				}
				else if (_ce.input.justEnd("right"))
				{
					getOrderByName("moveRight").phase = Process.END;
					getOrderByName("move").phase = Process.END;
				}
				else if (_ce.input.justEnd("left"))
				{
					getOrderByName("moveLeft").phase = Process.END;
					getOrderByName("move").phase = Process.END;
				}
				
				if (_ce.input.justDid("up"))
				{
					getOrderByName("jump").phase = Process.BEGIN;
				}
				else if (_ce.input.isDoing("up"))
				{
					getOrderByName("jump").phase = Process.ON;
				}

				else if (_ce.input.isDoing("down"))
				{
					getOrderByName("squat").phase = Process.ON;
				}
			}
		}
		
		override public function getClass():Class
		{
			return DynamicObjectLogic;
		}
		
	}

}