package test2.math 
{
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Vec2;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MathMatrix22 extends b2Mat22 
	{
		
		public function MathMatrix22() 
		{
			super();
		}
		
		public static function GetMirrorMatrix22():b2Mat22
		{
			return b2Mat22.FromVV(new b2Vec2(1, 0), new b2Vec2(0, -1));
		}
		
	}

}