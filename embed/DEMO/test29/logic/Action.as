package test2.logic 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Action extends Process 
	{
		
		public function Action(name:String, phase:uint = 0) 
		{
			super(name, phase);
		}
		
		override public function toString():String
		{
			return "[ Action # name: " + name + " phase: " + phase + " ]";
		}
		
	}

}