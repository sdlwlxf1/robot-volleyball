package test1.logic
{
	import citrus.core.CitrusObject;
	/**
	 * Order reinforces the Order object structure (and typing.)
	 * it contains static Order phase constants as well as helpful comparators.
	 */
	public class Process
	{
		//read only Order keys
		public var name:String;
		
		public var phase:uint;
		
		/**
		 * Order started in this frame.
		 * will be advanced to BEGAN on next frame.
		 */
		public static const OFF:uint = 0;
		 
		public static const BEGIN:uint = 1;
		
		public static const ON:uint = 2;
		
		public static const END:uint = 3;
		
		public function Process(name:String, phase:uint = 0)
		{
			this.name = name;		
			this.phase = phase;
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
			return "[ Order # name: " + name + " phase: " + phase + " ]";
		}
	
	}

}