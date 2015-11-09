package test1.logic
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
		public static const UPDATE:uint = 0;
		
		public static const ONCE:uint = 1;
		
		public var updateStates:Function;
		public var updateActions:Function;
		
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
		
		protected var _ordersUpdate:Vector.<Order>;
		
		protected var _ordersOnce:Vector.<Order>;
		
		protected var _states:Dictionary;
		
		protected var _statesUpdate:Vector.<State>;
		
		protected var _statesOnce:Vector.<State>;
		
		protected var _actions:Dictionary;
		
		protected var _actionsUpdate:Vector.<Action>;
		
		protected var _actionsOnce:Vector.<Action>;
		
		public function Logic(object:CitrusObject)
		{
			_object = object;
			_ce = CitrusEngine.getInstance();
			initialize();
		}
		
		public function initialize():void
		{
			_orders = new Dictionary();
			_ordersUpdate = new Vector.<Order>();
			_ordersOnce = new Vector.<Order>();
			
			_states = new Dictionary();
			_statesUpdate = new Vector.<State>();
			_statesOnce = new Vector.<State>();
			
			_actions = new Dictionary();
			_actionsUpdate = new Vector.<Action>();
			_actionsOnce = new Vector.<Action>();
		}
		
		public function getClass():Class
		{
			return Logic;
		}
		
		public function addOrder(order:Order, type:uint = 0):void
		{
			_orders[order.name] = order;
			if (type == 0)
			{
				_ordersUpdate.push(order);
			}
			else if (type == 1)
			{
				_ordersOnce.push(order);
			}
		}
		
		public function addState(state:State, type:uint = 0):void
		{
			_states[state.name] = state;
			if (type == 0)
			{
				_statesUpdate.push(state);
			}
			else if (type == 1)
			{
				_statesOnce.push(state);
			}
		}
		
		public function addAction(action:Action, type:uint = 0):void
		{
			_actions[action.name] = action;
			if (type == 0)
			{
				_actionsUpdate.push(action);
			}
			else if (type == 1)
			{
				_actionsOnce.push(action);
			}
		}
		
		public function addOrderByName(name:String, type:uint = 0):void
		{
			var order:Order = new Order(name);
			_orders[name] = order;
			if (type == 0)
			{
				_ordersUpdate.push(order);
			}
			else if (type == 1)
			{
				_ordersOnce.push(order);
			}
		}
		
		public function addStateByName(name:String, type:uint = 0):void
		{
			var state:State = new State(name);
			_states[name] = state;
			if (type == 0)
			{
				_statesUpdate.push(state);
			}
			else if (type == 1)
			{
				_statesOnce.push(state);
			}
		}
		
		public function addActionByName(name:String, type:uint = 0):void
		{
			var action:Action = new Action(name);
			_actions[name] = action;
			if (type == 0)
			{
				_actionsUpdate.push(action);
			}
			else if (type == 1)
			{
				_actionsOnce.push(action);
			}
		}
		
		public function getOrderByName(name:String):Order
		{
			if (_orders[name])
			{
				return _orders[name];
			}
			else
				throw new Error("没有找到" + name + "命令" + ",请检查");
		}
		
		public function getStateByName(name:String):State
		{
			if (_states[name])
			{
				return _states[name];
			}
			else
				throw new Error("没有找到" + name + "状态" + ",请检查");
		}
		
		public function getActionByName(name:String):Action
		{
			if (_actions[name])
			{
				return _actions[name];
			}
			else
				throw new Error("没有找到" + name + "动作" + ",请检查");
		}
		
		public function getOrderPhaseByName(name:String):uint
		{
			if (_orders[name])
			{
				return _orders[name].phase;
			}
			else
				throw new Error("没有找到" + name + "命令" + ",请检查");
		}
		
		public function getStatePhaseByName(name:String):uint
		{
			if (_states[name])
			{
				return _states[name].phase;
			}
			else
				throw new Error("没有找到" + name + "状态" + ",请检查");
		}
		
		public function getActionPhaseByName(name:String):uint
		{
			if (_actions[name])
			{
				return _actions[name].phase;
			}
			else
				throw new Error("没有找到" + name + "动作" + ",请检查");
		}
		
		public function update():void
		{
			if (!_enabled)
				return;
				
			setAllActionsPhase(Process.OFF);
			setAllOrdersPhase(Process.OFF);
			setAllStatesPhase(Process.OFF);
			
			updateOrders();
			updateStates();
			updateActions();
		}
		
		protected function updateOrders():void
		{
		
		}
		
		public function setAllOrdersPhase(phase:uint, type:uint = 0):void
		{
			if (type == 0)
			{
				var length:int = _ordersUpdate.length;
				var i:int;
				for (i = 0; i < length; i++)
				{
					_ordersUpdate[i].phase = phase;
				}
			}
		}
		
		public function setAllStatesPhase(phase:uint, type:uint = 0):void
		{
			if (type == 0)
			{
				var length:int = _statesUpdate.length;
				var i:int;
				for (i = 0; i < length; i++)
				{
					_statesUpdate[i].phase = phase;
				}
			}
		}
		
		public function setAllActionsPhase(phase:uint, type:uint = 0):void
		{
			if (type == 0)
			{
				var length:int = _actionsUpdate.length;
				var i:int;
				for (i = 0; i < length; i++)
				{
					_actionsUpdate[i].phase = phase;
				}
			}
		}
		
		public function resetOrders():void
		{
			_orders = new Dictionary();
			_ordersUpdate = new Vector.<Order>();
			_ordersOnce = new Vector.<Order>();
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
	
	}

}