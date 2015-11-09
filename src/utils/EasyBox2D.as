package utils
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import math.MathMatrix22;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class EasyBox2D
	{
		

		
		public function EasyBox2D()
		{
		
		}
		
		/**
		 *
		 * @param	bodyDef 刚体需求
		 * @param	position 位置（b2Vec2类型遵循AS坐标，b2Vec2类型遵循Box2D坐标）
		 * @param	angle 角度
		 * @param	type 类型
		 * @param	userData 用户数据
		 * @return	bodyDef 刚体需求
		 */
		public static function defineBody(bodyDef:b2BodyDef, position:* = null, angle:Number = 0, type:uint = 2, userData:* = null):b2BodyDef
		{
			if (position == null)
			{
				bodyDef.position = new b2Vec2();
			}
			else
			{
				if (position is Point)
				{
					bodyDef.position = new b2Vec2((position as Point).x / 30, (position as Point).y / 30);
				}
				else if (position is b2Vec2)
				{
					bodyDef.position = position as b2Vec2;
				}
			}
			
			bodyDef.type = type;
			bodyDef.angle = angle;
			bodyDef.userData = userData;
			
			return bodyDef;
		}
		
		/**
		 *
		 * @param	world box2D世界
		 * @param	bodyDef 刚体需求
		 * @return	body 刚体
		 */
		public static function createBody(world:b2World, bodyDef:b2BodyDef):b2Body
		{
			
			var body:b2Body = world.CreateBody(bodyDef);
			
			return body;
		}
		
		public static function createPolygonShape(width:Number = 30, height:Number = 30, center:b2Vec2 = null, angle:Number = 0.0):b2PolygonShape
		{
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			var b2width:Number = width * 0.5 / 30;
			var b2height:Number = height * 0.5 / 30;
			var b2angle:Number = angle * Math.PI / 180;
			if (center == null && angle == 0.0)
			{
				polygonShape.SetAsBox(b2width, b2height);
			}
			else
			{
				if (center == null)
				{
					polygonShape.SetAsOrientedBox(b2width, b2height, new b2Vec2(), b2angle);
				}
				else
				{
					polygonShape.SetAsOrientedBox(b2width, b2height, center, b2angle);
				}
			}
			return polygonShape;
		}
		
		public static function invertBody(body:b2Body):void
		{
			body.SetTransform(new b2Transform(body.GetPosition(), MathMatrix22.GetMirrorMatrix22()));
			//body.GetTransform() = new b2Transform(body.GetPosition(), MathMatrix22.GetMirrorMatrix22());
		}
		
		public static function createCircleShape(radius:Number):b2CircleShape
		{
			var b2Radius:Number = radius / 30;
			var circleShape:b2CircleShape = new b2CircleShape(b2Radius);
			return circleShape;
		}
		
		public static function createBeveledRectShape(width:Number, height:Number, bevel:Number):b2PolygonShape
		{
			var halfWidth:Number = width / 30 * 0.5;
			var halfHeight:Number = height / 30 * 0.5;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			var vertices:Array = [];
			vertices.push(new b2Vec2( -halfWidth + bevel, -halfHeight));
			vertices.push(new b2Vec2( halfWidth - bevel, -halfHeight));
			vertices.push(new b2Vec2( halfWidth, -halfHeight + bevel));
			vertices.push(new b2Vec2( halfWidth, halfHeight - bevel));
			vertices.push(new b2Vec2( halfWidth - bevel, halfHeight));
			vertices.push(new b2Vec2( -halfWidth + bevel, halfHeight));
			vertices.push(new b2Vec2( -halfWidth, halfHeight - bevel));
			vertices.push(new b2Vec2( -halfWidth, -halfHeight + bevel));
			shape.SetAsArray(vertices);
			
			return shape;
		}
		
		public static function defineFixture(fixtureDef:b2FixtureDef, shape:b2Shape, density:Number = 0.0, friction:Number = 0.2, restitution:Number = 0.0, categoryBits:uint = 0x0001, maskBits:uint = 0xFFFF, isSensor:Boolean = false):b2FixtureDef
		{
			fixtureDef.shape = shape;
			fixtureDef.density = density;
			fixtureDef.restitution = restitution;
			fixtureDef.filter.categoryBits = categoryBits;
			fixtureDef.filter.maskBits = maskBits;
			fixtureDef.isSensor = isSensor;
			return fixtureDef;
		}
		
		public static function createFixture(body:b2Body, fixtureDef:b2FixtureDef):b2Fixture
		{
			var fixture:b2Fixture = body.CreateFixture(fixtureDef);
			return fixture;
		}
		
		public static function defineRevoluteJoint(revoluteJointDef:b2RevoluteJointDef, bodyA:b2Body, bodyB:b2Body, anchor:b2Vec2 = null, enableMotor:Boolean = false, maxMotorTorque:Number = 0.0, motorSpeed:Number = 0.0, enableLimit:Boolean = false, lowerAngle:Number = 0.0, upperAngle:Number = 0.0):b2RevoluteJointDef
		{
			if (anchor == null)
			{
				revoluteJointDef.Initialize(bodyA, bodyB, bodyB.GetWorldCenter());
			}
			revoluteJointDef.Initialize(bodyA, bodyB, anchor);
			revoluteJointDef.lowerAngle = lowerAngle;
			revoluteJointDef.upperAngle = upperAngle;
			revoluteJointDef.enableLimit = enableLimit;
			revoluteJointDef.enableMotor = enableMotor;
			revoluteJointDef.maxMotorTorque = maxMotorTorque;
			revoluteJointDef.motorSpeed = motorSpeed;
			
			return revoluteJointDef;
		}
		
		public static function defineWeldJoint(weldJointDef:b2WeldJointDef, bodyA:b2Body, bodyB:b2Body, anchor:b2Vec2 = null):b2WeldJointDef
		{
			if (anchor == null)
			{
				weldJointDef.Initialize(bodyA, bodyB, bodyB.GetWorldCenter());
			}
			weldJointDef.Initialize(bodyA, bodyB, anchor);
			return weldJointDef;
		
		}
		
		public static function createJoint(world:b2World, jointDef:b2JointDef):b2Joint
		{
			var joint:b2Joint = world.CreateJoint(jointDef);
			return joint;
		}
		
		/**
		 * In Box2D we are blind concerning the collision, we are never sure which body is the collider. This function should help.
		 * Call this function to obtain the colliding physics object.
		 * @param self in CE's code, we give this. In your code it will be your hero, a sensor, ...
		 * @param the contact.
		 * @return the collider.
		 */
		public static function CollisionGetOther(self:b2Body, contact:b2Contact):b2Body {
			return self == contact.GetFixtureA().GetBody() ? contact.GetFixtureB().GetBody() : contact.GetFixtureA().GetBody();
		}
		
		/**
		 * In Box2D we are blind concerning the collision, we are never sure which body is the collider. This function should help.
		 * Call this function to obtain the collided physics object.
		 * @param self in CE's code, we give this. In your code it will be your hero, a sensor, ...
		 * @param the contact.
		 * @return the collided.
		 */
		public static function CollisionGetSelf(self:b2Body, contact:b2Contact):b2Body {
			return self == contact.GetFixtureA().GetBody() ? contact.GetFixtureA().GetBody() : contact.GetFixtureB().GetBody();
		}
	}

}