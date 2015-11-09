package test2.data 
{
	import Box2D.Common.Math.b2Vec2;
	import test2.math.MathUtils;
	import test2.math.MathVector;
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
		
		public function BallFlipData(angle:Number, power:Number) 
		{
			this.originalAngle = angle;
			this.power = power;
			
			originalVec = MathUtils.GetUnitVectorByAngle(originalAngle);
			
			invertVec = new b2Vec2();
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
			
		}
		
		public function invert():void
		{
			angle = invertAngle;
			vec = invertVec;
		}
		
	}

}