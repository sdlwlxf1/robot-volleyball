package test2.logic 
{
	/**
	 * ...
	 * @author ...
	 */
	public class State extends Process 
	{
		
		public function State(name:String, phase:uint = 0) 
		{
			super(name, phase);
		}
		
		
		
		override public function toString():String
		{
			return "[ State # name: " + name + " phase: " + phase + " ]";
		}
		
	}

}