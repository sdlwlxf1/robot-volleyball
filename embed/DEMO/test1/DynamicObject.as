package test1
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
	import test1.logic.*;
	import test1.math.MathMatrix22;
	
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
	
	/**
	 * This is a common, simple, yet solid implementation of a side-scrolling DynamicObject.
	 * The DynamicObject can run, jump, get hurt, and kill enemies. It dispatches signals
	 * when significant events happen. The game state's logic should listen for those signals
	 * to perform game state updates (such as increment coin collections).
	 *
	 * Don't store data on the DynamicObject object that you will need between two or more levels (such
	 * as current coin count). The DynamicObject should be re-created each time a state is created or reset.
	 */
	public class DynamicObject extends Box2DPhysicsObject
	{
		
		//properties
		/**
		 * This is the rate at which the DynamicObject speeds up when you move him left and right.
		 */
		[Inspectable(defaultValue="1")]
		public var acceleration:Number = 1;
		
		/**
		 * This is the fastest speed that the DynamicObject can move left or right.
		 */
		[Inspectable(defaultValue="8")]
		public var maxVelocity:Number = 8;
		
		/**
		 * This is the fastest speed that the DynamicObject can move left or right.
		 */
		[Inspectable(defaultValue="(8, 0)")]
		public var velocityVec:b2Vec2 = new b2Vec2(5, 0);
		
		[Inspectable(defaultValue="(3, 0)")]
		public var velocityJumpVec:b2Vec2 = new b2Vec2(3, 0);
		
		/**
		 * This is the initial velocity that the DynamicObject will move at when he jumps.
		 */
		[Inspectable(defaultValue="11")]
		public var jumpHeight:Number = 11;
		
		/**
		 * This is the amount of "float" that the DynamicObject has when the player holds the jump button while jumping.
		 */
		[Inspectable(defaultValue="0.3")]
		public var jumpAcceleration:Number = 0.3;
		
		/**
		 * Determines whether or not the DynamicObject's ducking ability is enabled.
		 */
		[Inspectable(defaultValue="true")]
		public var canDuck:Boolean = true;
		
		public var animationName:Object = {"walk": "walk", "jump": "jump", "idle": "idle", "hurt": "hurt", "duck": "duck"};
		
		//events
		/**
		 * Dispatched whenever the DynamicObject jumps.
		 */
		public var onJump:Signal;
		
		/**
		 * Dispatched whenever the DynamicObject gives damage to an enemy.
		 */
		public var onGiveDamage:Signal;
		
		/**
		 * Dispatched whenever the DynamicObject takes damage from an enemy.
		 */
		public var onTakeDamage:Signal;
		
		/**
		 * Dispatched whenever the DynamicObject's animation changes.
		 */
		public var onAnimationChange:Signal;
		
		protected var _linearVelocity:b2Vec2;
		
		protected var _groundContacts:Array = []; //Used to determine if he's on ground or not.
		protected var _interactiveClass:Class = Ball;
		protected var _friction:Number = 2;
		protected var _controlsEnabled:Boolean = true;
		protected var _combinedGroundAngle:Number = 0;
		protected var _logic:DynamicObjectLogic;
		
		protected var _control:String = "keyboard";
		
		/*protected var _animationCount:Number = 0;
		 protected var _animationDelay:Number = 20;*/
		
		/**
		 * Creates a new DynamicObject object.
		 */
		public function DynamicObject(name:String, params:Object = null)
		{
			super(name, params);
			onJump = new Signal();
			onGiveDamage = new Signal();
			onTakeDamage = new Signal();
			onAnimationChange = new Signal();
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
			_logic.updateActions = updateActions;
			_logic.updateStates = updateStates;
		}
		
		override public function update(timeDelta:Number):void
		{
			_logic.update();
		}
		
		protected function updateActions():void
		{
			
			if (getOrderByName("moveRight").phase == Process.ON)
			{
				getActionByName("moveRight").phase = Process.ON;
			}
			else if (getOrderByName("moveLeft").phase == Process.ON)
			{
				getActionByName("moveLeft").phase = Process.ON;
			}
			
			if (getOrderByName("move").phase == Process.BEGIN)
			{
				getActionByName("move").phase = Process.BEGIN;
			}
			
			else if (getOrderByName("move").phase == Process.END)
			{
				getActionByName("move").phase = Process.END;
			}
			
			if (getOrderByName("jump").phase == Process.BEGIN && !getStateByName("inAir").phase)
			{
				getActionByName("jump").phase = Process.BEGIN;
			}
			else if (getOrderByName("jump").phase == Process.ON && getStateByName("inAir").phase)
			{
				getActionByName("jump").phase = Process.ON;
			}
			
			if (getActionByName("jump").phase == Process.ON && getStateByName("rise").phase)
			{
				getActionByName("jumpAcceleration").phase = Process.ON;
			}
			
			if (getOrderByName("squat").phase == Process.ON)
			{
				getActionByName("squat").phase = Process.ON;
			}
			
			if (getActionByName("moveRight").phase == Process.ON)
			{
				//_linearVelocity.Add(getSlopeBasedMoveAngle());
				_linearVelocity.x = velocityVec.x;
				
			}
			else if (getActionByName("moveLeft").phase == Process.ON)
			{
				//_linearVelocity.Subtract(getSlopeBasedMoveAngle());
				_linearVelocity.x = -(velocityVec.x);
			}
			
			if (getActionByName("move").phase == Process.BEGIN)
			{
				_fixture.SetFriction(0); //Take away friction so he can accelerate.
			}
			//Player just stopped moving the DynamicObject this tick.
			else if (getActionByName("move").phase == Process.END)
			{
				_linearVelocity.SetZero();
				_fixture.SetFriction(_friction); //Add friction so that he stops running
			}
			
			if (getActionByName("jump").phase == Process.BEGIN)
			{
				_linearVelocity.y = -jumpHeight;
				onJump.dispatch();
			}
			
			if (getActionByName("jumpAcceleration").phase == Process.ON)
			{
				_linearVelocity.y -= jumpAcceleration;
			}
			
			if (getStateByName("moveRightMax").phase)
			{
				_linearVelocity.x = maxVelocity;
			}
			else if (getStateByName("moveLeftMax").phase)
			{
				_linearVelocity.x = -maxVelocity;
			}
			
			/*if (getActionByName("move").phase == Process.BEGIN)
			   {
			   if (getStateByName("moveLeft").phase == Process.ON)
			   {
			   invertedBody = false;
			   }
			   else
			   {
			   invertedBody = true;
			   }
			 }*/
			
			updateAnimation();
		}
		
		protected function updateStates():void
		{
			if (walkingSpeed < -acceleration)
			{
				
				getStateByName("moveLeft").phase = Process.ON;
				
				if (walkingSpeed < -maxVelocity)
				{
					getStateByName("moveLeftMax").phase = Process.ON;
				}
			}
			else if (walkingSpeed > acceleration)
			{
				getStateByName("moveRight").phase = Process.ON;
				
				if (walkingSpeed > maxVelocity)
				{
					getStateByName("moveRightMax").phase = Process.ON;
				}
			}
			else
			{
				getStateByName("stop").phase = Process.ON;
			}
			
			if (_linearVelocity.y < 0)
			{
				getStateByName("rise").phase = Process.ON;
			}
			else if (_linearVelocity.y > 0)
			{
				getStateByName("fall").phase = Process.ON;
			}
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			
			_bodyDef.fixedRotation = true;
			_bodyDef.allowSleep = false;
		}
		
		override protected function createShape():void
		{
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.3);
		
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = _friction;
			_fixtureDef.density = 50;
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("GoodGuys");
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
					getStateByName("inAir").phase = Process.OFF;
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
					getStateByName("inAir").phase = Process.ON;
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
			
			var prevAnimation:String = _animation;
			
			if (getStateByName("inAir").phase == Process.ON)
			{
				_animation = animationName["jump"];
				if (getStateByName("moveLeft").phase)
				{
					//inverted = true;
				}
				else if (getStateByName("moveRight").phase)
				{
					//inverted = false;
				}
			}
			else if (getActionByName("squat").phase == Process.ON)
			{
				_animation = animationName["duck"];
			}
			else
			{
				if (getStateByName("moveLeft").phase)
				{
					//inverted = true;
					_animation = animationName["walk"];
				}
				else if (getStateByName("moveRight").phase)
				{
					//inverted = false;
					_animation = animationName["walk"];
				}
				else if (getStateByName("stop").phase)
				{
					_animation = animationName["idle"];
				}
			}
			
			if (prevAnimation != _animation)
				onAnimationChange.dispatch();
		}
		
		protected function getOrderByName(name:String):Order
		{
			return _logic.getOrderByName(name);
		}
		
		protected function getStateByName(name:String):State
		{
			return _logic.getStateByName(name);
		}
		
		protected function getActionByName(name:String):Action
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
		
		/**
		 * Returns the absolute walking speed, taking moving platforms into account.
		 * Isn't super performance-light, so use sparingly.
		 */
		public function get walkingSpeed():Number
		{
			var groundVelocityX:Number = 0;
			for each (var groundContact:b2Fixture in _groundContacts)
			{
				groundVelocityX += groundContact.GetBody().GetLinearVelocity().x;
			}
			
			return _body.GetLinearVelocity().x - groundVelocityX;
		}
		
		public function get control():String
		{
			return _control;
		}
		
		public function set control(value:String):void
		{
			_control = value;
		}
	}
}