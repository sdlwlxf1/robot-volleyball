package test2 
{
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Accumulator extends Sprite 
	{
		
		private var bar:DisplayObject;
		
		public var barWidth:Number = 50;
		public var barHeight:Number = 300;
		
		public function Accumulator() 
		{
			bar = new Quad(barWidth, 1, 0XFC4025);
			bar.pivotX = bar.width >> 1;
			bar.rotation = Math.PI;
			addChild(bar);
			//bar.alpha = 0.6;
		}
		
		public function update(power:Number, powerMax:Number):void
		{
			bar.height = power / powerMax * barHeight;
		}
		
	}

}