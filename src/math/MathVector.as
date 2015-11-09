package math
{
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	
	public class MathVector extends b2Vec2
	{
		
		private var angle:Number;
		
		public function MathVector(x:Number = 0, y:Number = 0)
		{
			super(x, y);
		}
		
		public function GetAngle():Number
		{
			return Math.atan2(y, x);
		}
		
		public function SetAngle(value:Number):void
		{
			x = length * Math.cos(value);
			y = length * Math.sin(value);
		}
		
		public function Rotate(angle:Number):void
		{
			var ca:Number = Math.cos(angle);
			var sa:Number = Math.sin(angle);
			
			x = x * ca - y * sa;
			y = x * sa + y * ca;
		}
		
		public static function invertVector(vec:b2Vec2, mirrorX:Number = 0):b2Vec2
		{
			vec.x = 2 * mirrorX - vec.x;
			return vec;
		}
		
		
		
		public function ScaleEquals(value:Number):void
		{
			x *= value;
			y *= value;
		}
		
		public function Scale(value:Number, result:MathVector = null):MathVector
		{
			if (result)
			{
				result.x = x * value;
				result.y = y * value;
				
				return result;
			}
			
			return new MathVector(x * value, y * value);
		}
		
		public function GetNormal():MathVector
		{
			return new MathVector(-y, x);
		}
		
		public function SetLength(value:Number):void
		{
			this.ScaleEquals(value / length);
		}
		
		public function PlusEquals(vector:MathVector):void
		{
			x += vector.x;
			y += vector.y;
		}
		
		public function Plus(vector:MathVector, result:MathVector = null):MathVector
		{
			if (result)
			{
				result.x = x + vector.x;
				result.y = y + vector.y;
				
				return result;
			}
			
			return new MathVector(x + vector.x, y + vector.y);
		}
		
		public function MinusEquals(vector:MathVector):void
		{
			x -= vector.x;
			y -= vector.y;
		}
		
		public function Minus(vector:MathVector, result:MathVector = null):MathVector
		{
			if (result)
			{
				result.x = x - vector.x;
				result.y = y - vector.y;
				
				return result;
			}
			
			return new MathVector(x - vector.x, y - vector.y);
		}
		
		public function get length():Number
		{
			return Math.sqrt((x * x) + (y * y));
		}
	}
}