package test2.math {
	
	import Box2D.Common.Math.b2Vec2;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class MathUtils {
		
		public static function DistanceBetweenTwoPoints(x1:Number, x2:Number, y1:Number, y2:Number):Number {
			
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function RotateAroundInternalPoint(object:DisplayObject, pointToRotateAround:Point, rotation:Number):void {
			
			// Thanks : http://blog.open-design.be/2009/02/05/rotate-a-movieclipdisplayobject-around-a-point/
			
			var m:Matrix = object.transform.matrix;
			
			var point:Point = pointToRotateAround;
			point = m.transformPoint(point);
			
			RotateAroundExternalPoint(object, point, rotation);
		}

		
		public static function RotateAroundExternalPoint(object:DisplayObject, pointToRotateAround:Point, rotation:Number):void {
			
			var m:Matrix = object.transform.matrix;
			
			m.translate(-pointToRotateAround.x, -pointToRotateAround.y);
			m.rotate(rotation * (Math.PI / 180));
			m.translate(pointToRotateAround.x, pointToRotateAround.y);
			
			object.transform.matrix = m;
		}
		
		/**
		 * Rotates a flash Point around Origin (like MathVector.rotate() )
		 * @param	p flash.geom.Point
		 * @param	a angle in radians
		 * @return	returns a new rotated point.
		 */
		public static  function rotatePoint(p:Point, a:Number):Point
		{
			var c:Number = Math.cos(a);
			var s:Number = Math.sin(a);
			return new Point(p.x * c + p.y * s, -p.x * s + p.y * c);
		}
		
		/**
		 * Creates the axis aligned bounding box for a rotated rectangle.
		 * @param w width of the rotated rectangle
		 * @param h height of the rotated rectangle
		 * @param a angle of rotation around the topLeft point in radian
		 * @return flash.geom.Rectangle
		 */
		public static function createAABB(x:Number, y:Number, w:Number, h:Number, a:Number = 0):Rectangle {
			
			var aabb:Rectangle = new Rectangle(x, y, w, h);
			
			if (a == 0)
				return aabb;
				
			var c:Number = Math.cos(a);
			var s:Number = Math.sin(a);
			var cpos:Boolean;
			var spos:Boolean;
			
			if (s < 0) { s = -s; spos = false; } else { spos = true; }
			if (c < 0) { c = -c; cpos = false; } else { cpos = true; }
			
			aabb.width = h * s + w * c;
			aabb.height = h * c + w * s;
			
			if (cpos)
				if (spos)
					aabb.x -= h * s;
				else
					aabb.y -= w * s;
			else if (spos)
			{
				aabb.x -= w * c + h * s;
				aabb.y -= h * c;
			}
			else
			{
				aabb.x -= w * c;
				aabb.y -= w * s + h * c;
			}
			
			return aabb;
		}
		
		public static function GetAngleFromVec(vector:b2Vec2):Number
		{
			return Math.atan2(vector.y, vector.x);
		}
		
		public static function GetUnitVectorByAngle(angle:Number = 0, scale:Number = 1):b2Vec2
		{
			var unitVector:b2Vec2 = new b2Vec2(scale, 0);
			
			var ca:Number = Math.cos(angle);
			var sa:Number = Math.sin(angle);
			
			var unitVectorX:Number = unitVector.x;
			var unitVectorY:Number = unitVector.y;
			
			unitVector.x = unitVectorX * ca - unitVectorY * sa;
			unitVector.y = unitVectorX * sa + unitVectorY * ca;
			
			return unitVector;
		}
		
		/**
		 * Creates the axis aligned bounding box for a rotated rectangle
		 * and returns offsetX , offsetY which is simply the x and y position of 
		 * the aabb relative to the rotated rectangle.
		 * @param w width of the rotated rectangle
		 * @param h height of the rotated rectangle
		 * @param a angle of rotation around the topLeft point in radian
		 * @return {rect:flash.geom.Rectangle,offsetX:Number,offsetY:Number}
		 */
		public static function createAABBData(x:Number, y:Number, w:Number, h:Number, a:Number = 0):Object {
			
			var aabb:Rectangle = new Rectangle(x, y, w, h);
			var offX:Number = 0;
			var offY:Number = 0;
			
			if (a == 0)
				return { offsetX:0, offsetY:0, rect:aabb };
				
			var c:Number = Math.cos(a);
			var s:Number = Math.sin(a);
			var cpos:Boolean;
			var spos:Boolean;
			
			if (s < 0) { s = -s; spos = false; } else { spos = true; }
			if (c < 0) { c = -c; cpos = false; } else { cpos = true; }
			
			aabb.width = h * s + w * c;
			aabb.height = h * c + w * s;
			
			if (cpos)
				if (spos)
					offX -= h * s;
				else
					offY -= w * s;
			else if (spos)
			{
				offX -= w * c + h * s;
				offY -= h * c;
			}
			else
			{
				offX -= w * c;
				offY -= w * s + h * c;
			}
			
			aabb.x += offX;
			aabb.y += offY;
			
			return { offsetX:offX, offsetY:offY, rect:aabb };
		}
		
		public static function isInExtend(value:Number, x1:Number, x2:Number):Boolean
		{
			return x1 < x2 ? (value > x1 && value < x2):(value < x1 && value > x2);
		}
		
		public static function invertVector(vec:b2Vec2, mirrorX:Number = 0):b2Vec2
		{
			vec.x = 2 * mirrorX - vec.x;
			return vec;
		}
		
		public static function invertNewVector(vec:b2Vec2, mirrorX:Number = 0):b2Vec2
		{
			var vector:b2Vec2 = new b2Vec2();
			vector.x = 2 * mirrorX - vec.x;
			vector.y = vec.y;
			return vector;
		}
	}
}