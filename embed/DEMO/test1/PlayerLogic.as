package test1
{
	import citrus.core.CitrusObject;
	import test1.logic.Logic;
	import test1.logic.Process;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerLogic extends DynamicObjectLogic
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
			
			addOrderByName("hit");
			
			addActionByName("hit");
			addActionByName("hitOverDo", Logic.ONCE);			
			addActionByName("hitBall");
			addActionByName("jumpHang");
			
			addStateByName("handTouchBall", Logic.ONCE);
			addStateByName("hitAreaTouchBall", Logic.ONCE);
			addStateByName("handOver");
		}
		
		override protected function updateOrders():void
		{
			super.updateOrders();
			
			if (_control == "keyboard")
			{
				if (_ce.input.justDid("space", inputChannel))
				{
					getOrderByName("hit").phase = Process.BEGIN;
				}
				else if (_ce.input.isDoing("space", inputChannel))
				{
					getOrderByName("hit").phase = Process.ON;
				}
			
			}
			else if (_control == "auto")
			{
				if (getStateByName("hitAreaTouchBall").phase == Process.ON)
				{
					getOrderByName("hit").phase = Process.ON;
				}
			}
			
		}
		
		override public function getClass():Class
		{
			return PlayerLogic;
		}
	
	}

}