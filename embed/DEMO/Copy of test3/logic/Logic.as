package test2.logic
{
	
	import citrus.core.CitrusEngine;
	import citrus.core.CitrusObject;
	import citrus.input.controllers.Keyboard;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	/**
	 * A class managing input of any controllers that is an InputController.
	 * Orders are inspired by Midi signals, but they carry an InputOrder object.
	 * "Order signals" are either ON, OFF, or VALUECHANGE.
	 * to track Order status, and check whether Order was just triggered or is still on,
	 * Orders have phases (see InputOrder).
	 **/
	public class Logic
	{
		private var _beginCondition:Object;
		private var _endCondition:Object;
		
		public var doExtraActions:Function;
		public var updateStates:Function;
		public var updateAnimation:Function;
		public var doAction:Function;
		protected var _ordersUpdate:Vector.<Order>;
		protected var _actionsUpdate:Vector.<Action>;
		
		protected var _ce:CitrusEngine;
		protected var _enabled:Boolean = true;
		
		/**
		 * Defines which input Channel to listen to.
		 */
		[Inspectable(defaultValue="0")]
		public var inputChannel:uint = 0;
		
		protected var _control:String;
		
		protected var _object:CitrusObject;
		
		protected var _orders:Dictionary;
		
		protected var _ordersVector:Vector.<Order>;
		
		protected var _states:Dictionary;
		
		protected var _statesVector:Vector.<State>;
		
		protected var _actions:Dictionary;
		
		protected var _actionsVector:Vector.<Action>;
		
		public function Logic(object:CitrusObject)
		{
			_object = object;
			_ce = CitrusEngine.getInstance();
			initialize();
		}
		
		public function initialize():void
		{
			_ordersUpdate = new Vector.<Order>();
			_actionsUpdate = new Vector.<Action>();
			
			_orders = new Dictionary();
			_ordersVector = new Vector.<Order>();
			
			_states = new Dictionary();
			_statesVector = new Vector.<State>();
			
			_actions = new Dictionary();
			_actionsVector = new Vector.<Action>();
			
			initLogicTree();
		}
		
		/**
		 * 重写该方法创建逻辑树
		 */
		protected function initLogicTree():void
		{
		
		}
		
		public function getCondition(process:Process, type:uint):Object
		{
			return null;
		}
		
		/**
		 * 逻辑更新
		 */
		public function update():void
		{
			if (!_enabled)
				return;
			//物理和渲染更新状态
			updateStates();
			//I/O或AI控制更新命令
			updateOrders();
			//更新并执行行动
			updateActions();
			//更新动画
			updateAnimation();
			//所有过程更新
			updateProcess();
		
		}
		
		private function updateActions():void
		{
			//逻辑树根据命令和状态更新需要执行的行动
			updateLogicTree();
			doActions();
			doExtraActions();
		}
		
		/**
		 * 对活动中的命令逻辑树递归遍历，获得需要更新执行的行动
		 */
		protected function updateLogicTree():void
		{
			while (_ordersUpdate.length)
			{
				traverseTree(_ordersUpdate[0]);
				//trace("一个order");
				_ordersUpdate.splice(0, 1);
			}
			//trace(_actionsUpdate);
		}
		
		/**
		 * 逻辑树递归遍历
		 * @param	process
		 */
		private function traverseTree(head:Process):void
		{
			
			if (head.childs)
			{
				
				//trace(head +" " + head.childs);
				for each (var action:Action in head.childs)
				{
					_beginCondition = action.beginCondition;
					_endCondition = action.endCondition;
					action.activated = false;
					if (action.phase == Process.OFF)
					{
						if (head.phase == Process.BEGIN && _beginCondition == null)
						{
							action.phase = Process.BEGIN;
							action.activated = true;
						}
						else if (_beginCondition == true)
						{
							action.phase = Process.BEGIN;
							action.activated = true;
						}
					}
					else if (action.phase == Process.ON)
					{
						if (head.phase == Process.END && _endCondition == null)
						{
							action.phase = Process.END;
							action.activated = true;
						}		
						else if (_endCondition == true)
						{
							action.phase = Process.END;
							action.activated = true;
						}
						else 
						{
							action.activated = true;
						}
					}
					
					if (action.activated == true)
					{
						_actionsUpdate.push(action);
						if (action.childs)
						{
							traverseTree(action);
						}
					}
				}
			}
		}
		
		private function updateProcess():void
		{
			for each (var order:Order in _ordersVector)
			{
				order.update();
			}
			for each (var state:State in _statesVector)
			{
				state.update();
			}
			for each (var action:Action in _actionsVector)
			{
				action.update();
			}
		}
		
		/**
		 * 重写该方法更新命令
		 */
		protected function updateOrders():void
		{
			for each (var order:Order in _ordersVector)
			{
				if (order.phase > 0)
				{
					_ordersUpdate.push(order);
				}
			}
		}
		
		/*public function orderCondition(order:Order, begin:Boolean, end:Boolean):void
		   {
		   if (begin)
		   {
		   order.phase = Process.BEGIN;
		   }
		   else if (end)
		   {
		   order.phase = Process.END;
		   }
		   if (order.phase > 0)
		   {
		   _ordersUpdate.push(order);
		   }
		 }*/
		
		public static function stateCondition(state:State, begin:Boolean, autoEnd:Boolean = true, end:Boolean = true):void
		{
			if (begin && state.phase == Process.OFF)
			{
				state.phase = Process.BEGIN;
			}
			if (autoEnd == true)
			{
				if (!begin && state.phase == Process.ON)
				{
					state.phase = Process.END;
				}
			}
			else
			{
				if (end && state.phase == Process.ON)
				{
					state.phase = Process.END;
				}
			}
		}
		
		/**
		 * 行动执行
		 */
		private function doActions():void
		{
			while (_actionsUpdate.length)
			{
				doAction(_actionsUpdate[0]);
				//_actionsUpdate.splice(0, 1);
				_actionsUpdate.shift();
			}
		}
		
		public function addOrderByName(name:String):Order
		{
			var order:Order = new Order(name);
			_orders[name] = order;
			_ordersVector.push(order);
			return order;
		
		}
		
		public function addStateByName(name:String):State
		{
			var state:State = new State(name);
			_states[name] = state;
			_statesVector.push(state);
			return state;
		
		}
		
		public function addActionByName(name:String):Action
		{
			var action:Action = new Action(name);
			_actions[name] = action;
			_actionsVector.push(action);
			return action;
		
		}
		
		public function getOrderByName(name:String):Order
		{
			if (_orders[name])
			{
				return _orders[name];
			}
			else
			{
				return addOrderByName(name);
			}
		
		}
		
		public function getStateByName(name:String):State
		{
			if (_states[name])
			{
				return _states[name];
			}
			else
			{
				return addStateByName(name);
			}
		}
		
		public function getActionByName(name:String):Action
		{
			if (_actions[name])
			{
				return _actions[name];
			}
			else
			{
				return addActionByName(name);
			}
		}
		
		public function resetOrders():void
		{
			_orders = new Dictionary();
			_ordersVector = new Vector.<Order>();
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			
			_enabled = value;
		}
		
		public function destroy():void
		{
			_orders = null;
			_states = null;
			_actions = null;
		}
		
		public function getClass():Class
		{
			return Logic;
		}
	
	}

}