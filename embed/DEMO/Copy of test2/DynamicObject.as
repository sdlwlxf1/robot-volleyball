package test2
{
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Fixture;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import flash.utils.Dictionary;
	import test2.logic.*;
	import test2.math.MathMatrix22;
	
	import citrus.math.MathVector;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	import org.osflash.signals.Signal;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	public class DynamicObject extends Box2DPhysicsObject
	{
		
		//properties
		/**
		 * This is the rate at which the DynamicObject speeds up when you move him left and right.
		 */
		[Inspectable(defaultValue="1")]
		public var acceleration:Number = 1;
		
		public var animationName:Object;
		
		/**
		 * Dispatched whenever the DynamicObject's animation changes.
		 */
		public var onAnimationChange:Signal;
		
		protected var _linearVelocity:b2Vec2;
		
		protected var _groundContacts:Array = []; //Used to determine if he's on ground or not.
		protected var _interactiveClass:Class = Ball;
		protected var _friction:Number = 1;
		protected var _controlsEnabled:Boolean = true;
		protected var _combinedGroundAngle:Number = 0;
		protected var _logic:Logic;
		
		protected var _walkingSpeed:Number;
		
		/*protected var _animationCount:Number = 0;
		 protected var _animationDelay:Number = 20;*/
		
		/**
		 * Creates a new DynamicObject object.
		 */
		public function DynamicObject(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			super.initialize(poolObjectParams);
			_linearVelocity = _body.GetLinearVelocity();
			initializeLogic();
		}
		
		protected function initializeLogic():void
		{
			_logic = new DynamicObjectLogic(this);
			_logic.doExtraActions = doExtraActions;
			_logic.doAction = doAction;
			_logic.updateStates = updateStates;
			_logic.updateAnimation = updateAnimation;
		}
		
		public function get logic():Logic
		{
			return _logic as DynamicObjectLogic;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			_logic.update();
		}
		
		protected function doAction(action:Action):void
		{
		
		}
		
		/**
		 * 重写该方法定义
		 */
		protected function doExtraActions():void
		{
		
		}
		
		protected function updateStates():void
		{
			Logic.stateCondition(getStateByName("rise"), _linearVelocity.y < 0);
			Logic.stateCondition(getStateByName("drop"), _linearVelocity.y > 0);
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			
			_bodyDef.fixedRotation = true;
			_bodyDef.allowSleep = false;
		}
		
		override protected function createShape():void
		{
			super.createShape();
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = _friction;
			_fixtureDef.density = 50;
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Player");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
		
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			//Collision angle if we don't touch a Sensor.
			if (contact.GetManifold().m_localPoint && !(collider is Sensor)) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				var normalPoint:Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;
				
				if ((collisionAngle > 45 && collisionAngle < 135) || (collisionAngle > -30 && collisionAngle < 10 && collisionAngle != 0) || collisionAngle == -90)
				{
					//we don't want the Hero to be set up as onGround if it touches a cloud.
					if (collider is Platform && (collider as Platform).oneWay && collisionAngle == -90)
						return;
					
					_groundContacts.push(collider.body.GetFixtureList());
					getStateByName("onGround").phase = Process.BEGIN;
					updateCombinedGroundAngle();
				}
			}
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			//Remove from ground contacts, if it is one.
			var index:int = _groundContacts.indexOf(collider.body.GetFixtureList());
			if (index != -1)
			{
				_groundContacts.splice(index, 1);
				if (_groundContacts.length == 0)
				{
					getStateByName("onGround").phase = Process.END;
				}
				updateCombinedGroundAngle();
			}
		}
		
		protected function getSlopeBasedMoveAngle():b2Vec2
		{
			return Box2DUtils.Rotateb2Vec2(new b2Vec2(acceleration, 0), _combinedGroundAngle);
		}
		
		protected function updateCombinedGroundAngle():void
		{
			_combinedGroundAngle = 0;
			
			if (_groundContacts.length == 0)
				return;
			
			for each (var contact:b2Fixture in _groundContacts)
				var angle:Number = contact.GetBody().GetAngle();
			
			var turn:Number = 80 * Math.PI / 180;
			angle = angle % turn;
			_combinedGroundAngle += angle;
			_combinedGroundAngle /= _groundContacts.length;
		}
		
		protected function updateAnimation():void
		{
		
		}
		
		public function getOrderByName(name:String):Order
		{
			return _logic.getOrderByName(name);
		}
		
		public function getStateByName(name:String):State
		{
			return _logic.getStateByName(name);
		}
		
		public function getActionByName(name:String):Action
		{
			return _logic.getActionByName(name);
		}
		
		/**
		 * This is the amount of friction that the DynamicObject will have. Its value is multiplied against the
		 * friction value of other physics objects.
		 */
		public function get friction():Number
		{
			return _friction;
		}
		
		[Inspectable(defaultValue = "0.75").phase]
		
		public function set friction(value:Number):void
		{
			_friction = value;
			
			if (_fixture)
			{
				_fixture.SetFriction(_friction);
			}
		}
	
	}
}