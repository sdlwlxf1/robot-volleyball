package data 
{
	import Box2D.Common.Math.b2Vec2;
	import math.MathUtils;
	import math.MathVector;
	/**
	 * ...
	 * @author ...
	 */
	public class BallFlipData 
	{
		
		public var angle:Number;
		
		public var vec:b2Vec2;
		
		public var power:Number;
		
		
		
		public var originalVec:b2Vec2;
		
		public var invertVec:b2Vec2;
		
		public var originalAngle:Number;
		
		public var invertAngle:Number;
		
		public var powerVec:b2Vec2;
		
		public function BallFlipData(angle:Number = 0, power:Number = 0) 
		{
			powerVec = new b2Vec2();			
			invertVec = new b2Vec2();
			
			init(angle, power);
		}
		
		public function init(angle:Number, power:Number):void
		{
			this.originalAngle = angle;
			this.power = power;
			
			originalVec = MathUtils.GetUnitVectorByAngle(originalAngle);
			
			invertVec.SetV(originalVec);
			invertVec = MathVector.invertVector(invertVec, 0);
			
			if (originalAngle >= 0)
			{
				invertAngle = Math.PI - originalAngle;
			}
			else
			{
				invertAngle = - Math.PI - originalAngle;
			}
			
			this.angle = originalAngle;
			vec = originalVec;
			powerVec.SetV(vec);
			powerVec.Multiply(power);
		}
		
		public function invert():void
		{
			angle = invertAngle;
			vec = invertVec;
			powerVec = MathVector.invertVector(powerVec, 0);
		}
		
	}

}