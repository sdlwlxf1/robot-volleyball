package test1
{
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import citrus.objects.platformer.box2d.Hero;
	import flash.utils.Dictionary;
	import test.logic.Process;
	import test.math.MathMatrix22;
	import test.math.MathUtils;
	import test.math.MathVector;
	
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
	public class Player extends DynamicObject
	{
		public var distance:Number = 10;
		
		public var anchorPosition:b2Vec2;
		private var handPosition:b2Vec2;
		private var hitAreaPosition:b2Vec2;
		
		private var handShapeWidth:Number = 20;
		private var handShapeHeight:Number = 80;
		private var hitAreaRadius:Number = 70;
		
		//手臂刚体相关参数
		private var handBodyDef:b2BodyDef = new b2BodyDef;
		private var handBody:b2Body;
		private var handShape:b2Shape;
		private var handFixtureDef:b2FixtureDef = new b2FixtureDef;
		private var handFixture:b2Fixture;
		private var handJoint:b2Joint;
		private var handRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef;
		private var handContactedBody:b2Body;
		
		//击球感应区相关参数
		private var hitAreaBodyDef:b2BodyDef = new b2BodyDef;
		private var hitAreaBody:b2Body;
		private var hitAreaShape:b2Shape;
		private var hitAreaFixtureDef:b2FixtureDef = new b2FixtureDef;
		private var hitAreaFixture:b2Fixture;
		private var hitAreaJoint:b2Joint;
		private var hitAreaJointDef:b2WeldJointDef = new b2WeldJointDef;
		private var hitAreaContactedBody:b2Body;
		
		//击球计算相关参数
		private var ballPosition:b2Vec2 = new b2Vec2();
		private var hitAreaBodyPosition:b2Vec2 = new b2Vec2();
		private var hitBallCurAngle:Number;
		private var hitBallCurVector:MathVector = new MathVector();
		private var ballFlipAngles:Vector.<b2Vec2>;
		private var ballFlipDirection:b2Vec2 = new b2Vec2();
		
		//手臂转动参数
		private var handMaxAngle:Number;
		private var handMinAngle:Number;
		private var handShapeAngle:Number;
		private var handAngularVelocity:Number;
		private var handBeginHitAngle:Number;
		private var handEndHitAngle:Number;
		
		//击球后弹出角度参数
		private var hitBallAngleExtent:Number;
		private var hitBallBeginAngle:Number;
		private var hitBallEndAngle:Number;
		private var hitBallAngleLength:Number;
		private var hitBallAngleAccuracy:Number;
		
		/**
		 * Creates a new hero object.
		 */
		public function Player(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			super.initialize(poolObjectParams);
		}
		
		override protected function initializeBody():void
		{
			
			ballFlipAngles = new Vector.<b2Vec2>();
			ballFlipAngles.push(
			MathVector.GetUnitVectorByAngle( -0.48 * Math.PI, 20),
			MathVector.GetUnitVectorByAngle( -0.46 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.43 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.4 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.3 * Math.PI, 20),
			MathVector.GetUnitVectorByAngle( -0.1 * Math.PI, 20),
			MathVector.GetUnitVectorByAngle( 0.03 * Math.PI, 20),
			MathVector.GetUnitVectorByAngle( 0.1 * Math.PI, 50)
			);
			hitBallAngleLength = ballFlipAngles.length;
			
			handPosition = new b2Vec2(_x, _y - _height / 2 - handShapeHeight / 30 / 2 - distance / 30);
			anchorPosition = new b2Vec2(_x, _y - _height / 3);
			hitAreaPosition = new b2Vec2(_x - _width * 0.5, _y - _height * 0.8);
			if (invertedBody == false)
			{
				inverted = false;
				handAngularVelocity = 9;
				handMaxAngle = 0.5 * Math.PI;
				handMinAngle = -0.25 * Math.PI;
				handBeginHitAngle = handMinAngle;
				handEndHitAngle = handMaxAngle;
				handShapeAngle = -0.15 * Math.PI;
				
				hitBallBeginAngle = -0.8;
				hitBallEndAngle = 0;
			}
			else if (invertedBody == true)
			{
				inverted = true;
				handAngularVelocity = -9;
				handMaxAngle = 0.25 * Math.PI;
				handMinAngle = -0.5 * Math.PI;
				handBeginHitAngle = handMaxAngle;
				handEndHitAngle = handMinAngle;
				handShapeAngle = 0.15 * Math.PI;
				
				hitBallBeginAngle = -0.2;
				hitBallEndAngle = -1;
				
				for (var i:Number = 0; i < ballFlipAngles.length; i++)
				{
					MathVector.invertVector(ballFlipAngles[i]);
				}
				MathVector.invertVector(handPosition, _x);
				MathVector.invertVector(anchorPosition, _x);
				MathVector.invertVector(hitAreaPosition, _x);
			}
			
			hitBallAngleExtent = hitBallEndAngle - hitBallBeginAngle;
			hitBallAngleAccuracy = hitBallAngleExtent / hitBallAngleLength;
			
			super.initializeBody();
		}
		
		override public function set invertedBody(value:Boolean):void
		{
			super.invertedBody = value;
		}
		
		override protected function initializeLogic():void
		{
			_logic = new PlayerLogic(this);
			_logic.updateActions = updateActions;
			_logic.updateStates = updateStates;
		}
		
		override protected function updateActions():void
		{
			super.updateActions();
			
			if (getStateByName("handOver").phase == Process.ON)
			{
				getActionByName("hitOverDo").phase = Process.ON;
			}
			
			if (getOrderByName("hit").phase == Process.ON && getActionByName("hitOverDo").phase == Process.OFF)
			{
				getActionByName("hit").phase = Process.ON;
			}
			else if (getOrderByName("hit").phase == Process.OFF)
			{
				getActionByName("hitOverDo").phase = Process.OFF;
				getActionByName("hit").phase = Process.OFF;
			}
			
			if (getActionByName("hit").phase == Process.ON && getStateByName("handTouchBall").phase)
			{
				getActionByName("hitBall").phase = Process.ON;
			}
			
			if (getActionByName("jump").phase == Process.ON && getActionByName("hit").phase == Process.ON)
			{
				getActionByName("jumpHang").phase = Process.ON;
			}
			
			if (getActionByName("jumpHang").phase == Process.ON)
			{
				_linearVelocity.SetZero();
			}
			
			if (getActionByName("hit").phase == Process.ON)
			{
				handBody.SetAngularVelocity(handAngularVelocity);
			}
			else if (getActionByName("hit").phase == Process.OFF /* || getActionByName("hitOverDo").phase == Process.ON*/)
			{
				handBody.SetAngle(handBeginHitAngle);
			}
			
			if (getActionByName("hitBall").phase == Process.ON)
			{
				ballPosition.SetV(handContactedBody.GetPosition());
				hitAreaBodyPosition.SetV(hitAreaBody.GetPosition());
				hitBallCurVector.SetV(ballPosition);
				hitBallCurVector.Subtract(hitAreaBodyPosition);
				hitBallCurAngle = hitBallCurVector.GetAngle() / Math.PI;

				ballFlipDirection.SetV(ballFlipAngles[0]);
				for (var i:int = 0; i < hitBallAngleLength; i++)
				{
					if (MathUtils.isInExtend(hitBallCurAngle, hitBallBeginAngle + i * hitBallAngleAccuracy, hitBallBeginAngle + (i + 1) * hitBallAngleAccuracy))
					{
						ballFlipDirection.SetV(ballFlipAngles[i]);
						break;
					}
				}
				
				handContactedBody.SetLinearVelocity(ballFlipDirection);
			}
		}
		
		override protected function updateStates():void
		{
			super.updateStates();
			if (Math.abs(handBody.GetAngle()) >= Math.abs(handEndHitAngle) - 0.1)
			{
				getStateByName("handOver").phase = Process.ON;
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			handBodyDef = EasyBox2D.defineBody(handBodyDef, handPosition, 0, 2, this);
			hitAreaBodyDef = EasyBox2D.defineBody(hitAreaBodyDef, hitAreaPosition, 0, 2, this);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
			handBody = EasyBox2D.createBody(_box2D.world, handBodyDef);
			handBody.beginContactHanlder = handBeginContactHanlder;
			handBody.endContactHanlder = handEndContactHanlder;
			
			hitAreaBody = EasyBox2D.createBody(_box2D.world, hitAreaBodyDef);
			hitAreaBody.beginContactHanlder = hitAreaBeginContactHanlder;
			hitAreaBody.endContactHanlder = hitAreaEndContactHanlder;
		}
		
		private function hitAreaBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			
			hitAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				getStateByName("hitAreaTouchBall").phase = Process.ON;
			}
		}
		
		private function hitAreaEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			
			hitAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				getStateByName("hitAreaTouchBall").phase = Process.OFF;
			}
		}
		
		private function handBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			handContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				getStateByName("handTouchBall").phase = Process.ON;
			}
		}
		
		private function handEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			handContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				getStateByName("handTouchBall").phase = Process.OFF;
			}
		}
		
		override protected function createShape():void
		{
			super.createShape();
			
			handShape = EasyBox2D.createPolygonShape(handShapeWidth, handShapeHeight, null, handShapeAngle);
			hitAreaShape = EasyBox2D.createCircleShape(hitAreaRadius);
			//hitAreaShape = EasyBox2D.createBeveledRectShape(110, 140, 1);
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			
			handFixtureDef = EasyBox2D.defineFixture(handFixtureDef, handShape, 1, 0.6, 0.5, PhysicsCollisionCategories.Get("BadGuys"), PhysicsCollisionCategories.GetAll(), true);
			//handFixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Level");
			hitAreaFixtureDef = EasyBox2D.defineFixture(hitAreaFixtureDef, hitAreaShape, 1, 0.2, 0.0, PhysicsCollisionCategories.Get("BadGuys"), PhysicsCollisionCategories.GetAll(), true);
			//handFixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			
			handFixture = EasyBox2D.createFixture(handBody, handFixtureDef);
			hitAreaFixture = EasyBox2D.createFixture(hitAreaBody, hitAreaFixtureDef);
		}
		
		override protected function defineJoint():void
		{
			handRevoluteJointDef = EasyBox2D.defineRevoluteJoint(handRevoluteJointDef, _body, handBody, anchorPosition, true, 0, 100, true, handMinAngle, handMaxAngle);
			hitAreaJointDef = EasyBox2D.defineWeldJoint(hitAreaJointDef, _body, hitAreaBody, anchorPosition);
		}
		
		override protected function createJoint():void
		{
			handJoint = EasyBox2D.createJoint(_box2D.world, handRevoluteJointDef);
			hitAreaJoint = EasyBox2D.createJoint(_box2D.world, hitAreaJointDef);
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			super.handlePreSolve(contact, oldManifold);
			//trace(contact.IshandTouchBalling());
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