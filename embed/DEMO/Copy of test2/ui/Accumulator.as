package test2.ui 
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
		private var barBackground:DisplayObject;
		private var bar:DisplayObject;
		
		private var _barWidth:Number = 50;
		private var _barHeight:Number = 300;

		
		public function Accumulator(barWidth:Number = 50, barHeight:Number = 300) 
		{
			_barWidth = barWidth;
			_barHeight = barHeight;
			barBackground = new Quad(_barWidth, _barHeight, 0X7C7C7C);
			barBackground.pivotX = barBackground.width >> 1;
			barBackground.rotation = Math.PI;
			addChild(barBackground);
			
			
			bar = new Quad(_barWidth, 1, 0XFFFFFF);
			bar.pivotX = bar.width >> 1;
			bar.rotation = Math.PI;
			addChild(bar);
			//bar.alpha = 0.6;
		}
		
		public function update(power:Number, powerMax:Number):void
		{
			bar.height = power / powerMax * _barHeight;
		}
		
	}

}