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
		}
		
		override protected function initLogicTree():void
		{
			super.initLogicTree();
		}
		
		override public function getCondition(process:Process, type:uint):Object
		{
			return null;
		}
		
		override protected function updateOrders():void
		{
			super.updateOrders();
		}
		
		override public function getClass():Class
		{
			return DynamicObjectLogic;
		}
	
	}

}