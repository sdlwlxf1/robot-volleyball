package test2.logic
{
	import citrus.core.CitrusObject;
	
	/**
	 * Order reinforces the Order object structure (and typing.)
	 * it contains static Order phase constants as well as helpful comparators.
	 */
	public class Process extends Node
	{
		//read only Order keys
		public var name:String;
		
		private var _phase:uint;
		
		protected var _actived:Boolean;
		
		protected var _beginCondition:Object;
		
		protected var _endCondition:Object;
		
		public var activated:Boolean;
		
		/**
		 * Order started in this frame.
		 * will be advanced to BEGAN on next frame.
		 */
		public static const OFF:uint = 0;
		
		public static const BEGIN:uint = 1;
		
		public static const ON:uint = 2;
		
		public static const END:uint = 3;
		
		public var logic:Logic;
		
		public function Process(name:String, phase:uint = 0)
		{
			super();
			this.name = name;
			this._phase = phase;
		}
		
		public function isDoing():Boolean
		{
			return _phase == BEGIN || _phase == ON;
		}
		
		override public function addChild(childNode:Node, logic:Logic):void
		{
			super.addChild(childNode, logic);
			(childNode as Process).logic = logic;
			//this.logic = logic;
		}
		
		public function update():void
		{
			if (_phase == Process.BEGIN)
			{
				_phase = Process.ON;
			}
			else if (_phase == Process.END)
			{
				_phase = Process.OFF;
			}
		
		}
		
		public function get beginCondition():Object
		{
			_beginCondition = logic.getCondition(this, Process.BEGIN);
			
			if (_beginCondition == null)
			{
				return null;
			}
			else
			{
				return Boolean(_beginCondition);
			}
		}
		
		public function get endCondition():Object
		{
			_endCondition = logic.getCondition(this, Process.END);
			
			if (_endCondition == null)
			{
				
				return null;
			}
			else
			{
				return Boolean(_endCondition);
			}
		}
		
		public function get phase():uint
		{
			return _phase;
		}
		
		public function set phase(value:uint):void
		{
			if ((_phase == OFF && value == BEGIN) || (_phase == ON && value == END))
			{
				_phase = value;
			}
		}
		
		/**
		 * Clones the Order and returns a new Order instance with the same properties.
		 */
		public function clone():Order
		{
			return new Order(name, phase);
		}
		
		/**
		 * comp is used to compare an Order with another Order without caring about which controller
		 * the Orders came from. it is the most common form of Order comparison.
		 */
		public function comp(order:Order):Boolean
		{
			return name == order.name;
		}
		
		/**
		 * eq is almost a strict Order comparator. It will not only compare names and channels
		 * but also which controller the Orders came from.
		 */
		public function eq(order:Order):Boolean
		{
			return name == order.name;
		}
		
		public function toString():String
		{
			return "[ Process # name: " + name + " phase: " + phase + " ]";
		}
	
	}

}