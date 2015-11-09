package test1
{
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import citrus.objects.platformer.box2d.Hero;
	import flash.utils.Dictionary;
	
	import citrus.math.MathVector;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.utils.EasyBox2D;
	
	import org.osflash.signals.Signal;
	
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	/**
	 * This is a common, simple, yet solid implementation of a side-scrolling Hero.
	 * The hero can run, jump, get hurt, and kill enemies. It dispatches signals
	 * when significant events happen. The game state's logic should listen for those signals
	 * to perform game state updates (such as increment coin collections).
	 *
	 * Don't store data on the hero object that you will need between two or more levels (such
	 * as current coin count). The hero should be re-created each time a state is created or reset.
	 */
	public class MyHero extends Hero
	{
		public var distance:Number = 10;
		
		public var anchorPosition:b2Vec2;
		private var weldPosition:b2Vec2;
		
		private var weldRadius:Number = 70;
		
		private var weldBodyDef:b2BodyDef = new b2BodyDef;
		private var weldBody:b2Body;
		private var weldShape:b2Shape;
		private var weldFixtureDef:b2FixtureDef = new b2FixtureDef;
		private var weldFixture:b2Fixture;
		private var weldJoint:b2Joint;
		private var weldJointDef:b2WeldJointDef = new b2WeldJointDef;
		
		private var hitBall:Boolean = false;
		private var contactedBody:b2Body;
		private var ballPosition:b2Vec2 = new b2Vec2();
		private var weldBodyPosition:b2Vec2 = new b2Vec2();
		private var vec:b2Vec2 = new b2Vec2();
		private var directVec:b2Vec2 = new b2Vec2();
		private var angle:Number;
		
		/**
		 * Creates a new hero object.
		 */
		public function MyHero(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			
			super.initialize(poolObjectParams);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (controlsEnabled)
			{
				if (_ce.input.justEnd("hit", inputChannel) && hitBall && contactedBody)
				{
					ballPosition.SetV(contactedBody.GetPosition());
					weldBodyPosition.SetV(weldBody.GetPosition());
					vec.SetV(ballPosition);
					vec.Subtract(weldBodyPosition)
					angle = Box2DUtils.B2Vec2toAngle(vec) / Math.PI;
					//则添加一个向右的速度
					if (angle > -0.8 && angle < -0.5)
					{
						directVec.Set(1, -2);
						directVec.Multiply(10);
						contactedBody.SetLinearVelocity(directVec);
					} 
					else if (angle >= -0.5 && angle < -0.3)
					{
						directVec.Set(1, -1);
						directVec.Multiply(13);
						contactedBody.SetLinearVelocity(directVec);
					}
					else if (angle >= -0.3 && angle < -0.1)
					{
						directVec.Set(1, -0.5);
						directVec.Multiply(15);
						contactedBody.SetLinearVelocity(directVec);
					}
					else if (angle >= -0.1 && angle < 0)
					{
						directVec.Set(1, 0.5);
						directVec.Multiply(15);
						contactedBody.SetLinearVelocity(directVec);
					}
				}
				
			}
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			
			anchorPosition = new b2Vec2(_x, _y - _height / 3);
			weldPosition = new b2Vec2(_x, _y - _height / 3);
			
			weldBodyDef = EasyBox2D.defineBody(weldBodyDef, weldPosition, 0, 2, this);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
			weldBody = EasyBox2D.createBody(_box2D.world, weldBodyDef);
			weldBody.beginContactHanlder = weldBeginContactHanlder;
			weldBody.endContactHanlder = weldEndContactHanlder;

		}
		
		private function weldBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			this.contactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				hitBall = true;			
			}
		}
		
		private function weldEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			if (contactedBody.GetUserData().name == "ball")
			{
				hitBall = false;			
			}
		}
		
		override protected function createShape():void
		{
			super.createShape();
			weldShape = EasyBox2D.createCircleShape(weldRadius);
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			
			weldFixtureDef = EasyBox2D.defineFixture(weldFixtureDef, weldShape, 1, 0.2, 0.0, PhysicsCollisionCategories.Get("BadGuys"), PhysicsCollisionCategories.GetAll(), true);
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			
			weldFixture = EasyBox2D.createFixture(weldBody, weldFixtureDef);
		}
		
		override protected function defineJoint():void
		{
			weldJointDef = EasyBox2D.defineWeldJoint(weldJointDef, _body, weldBody, anchorPosition);
		}
		
		override protected function createJoint():void
		{
			weldJoint = EasyBox2D.createJoint(_box2D.world, weldJointDef);
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			super.handlePreSolve(contact, oldManifold);
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
		}
	}
}