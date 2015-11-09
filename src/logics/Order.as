package logics 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Order extends Process 
	{
		
		public function Order(name:String, phase:uint = 0) 
		{
			super(name, phase);
			headNode = this;
			parent = this;
		}
		
		override public function toString():String
		{
			return "[ Order # name: " + name + " phase: " + phase + " ]";
		}
		
	}

}