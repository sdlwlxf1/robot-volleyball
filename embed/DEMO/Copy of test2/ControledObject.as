package test2
{
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
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
	
	/**
	 * This is a common, simple, yet solid implementation of a side-scrolling DynamicObject.
	 * The DynamicObject can run, jump, get hurt, and kill enemies. It dispatches signals
	 * when significant events happen. The game state's logic should listen for those signals
	 * to perform game state updates (such as increment coin collections).
	 *
	 * Don't store data on the DynamicObject object that you will need between two or more levels (such
	 * as current coin count). The DynamicObject should be re-created each time a state is created or reset.
	 */
	public class ControledObject extends DynamicObject
	{
		
		/**
		 * This is the fastest speed that the DynamicObject can move left or right.
		 */
		[Inspectable(defaultValue="8")]
		public var maxVelocity:Number = 8;
		
		/**
		 * This is the fastest speed that the DynamicObject can move left or right.
		 */
		[Inspectable(defaultValue="(8, 0)")]
		public var velocityVec:b2Vec2 = new b2Vec2(7, 0);
		
		[Inspectable(defaultValue="(3, 0)")]
		public var velocityJumpVec:b2Vec2 = new b2Vec2(6, 0);
		
		/**
		 * This is the initial velocity that the DynamicObject will move at when he jumps.
		 */
		[Inspectable(defaultValue="11")]
		public var jumpHeight:Number = 16;
		
		/**
		 * This is the amount of "float" that the DynamicObject has when the player holds the jump button while jumping.
		 */
		[Inspectable(defaultValue="0.3")]
		public var jumpAcceleration:Number = 0.4;
		
		/**
		 * Determines whether or not the DynamicObject's ducking ability is enabled.
		 */
		[Inspectable(defaultValue="true")]
		public var canDuck:Boolean = true;
		
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
		
		protected var _control:String = "keyboard";
		
		/*protected var _animationCount:Number = 0;
		 protected var _animationDelay:Number = 20;*/
		
		/**
		 * Creates a new DynamicObject object.
		 */
		public function ControledObject(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			super.initialize(poolObjectParams);
			animationName = {"walk": "walk", "jump": "jump", "idle": "idle", "hurt": "hurt", "duck": "duck"};
			onJump = new Signal();
			onGiveDamage = new Signal();
			onTakeDamage = new Signal();
			onAnimationChange = new Signal();
		}
		
		override protected function initializeLogic():void
		{
			_logic = new ControledObjectLogic(this);
			_logic.doExtraActions = doExtraActions;
			_logic.doAction = doAction;
			_logic.updateStates = updateStates;
			_logic.updateAnimation = updateAnimation;
		}
		
		override public function get logic():Logic
		{
			return _logic as ControledObjectLogic;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		
		}
		
		override protected function doAction(action:Action):void
		{
			switch (action.name)
			{
				case "moveRight": 
					switch (action.phase)
				{
					case Process.BEGIN:
						break;
					case Process.END: 
						break;
					case Process.ON: 
						/*if (getActionByName("moveLeft").phase == Process.END)
						{
							_linearVelocity.x = velocityVec.x;
						}*/
						//_linearVelocity.x = velocityVec.x;
						break;
				}
					break;
				case "moveLeft": 
					switch (action.phase)
				{
					case Process.BEGIN:
						break;
					case Process.END: 
						break;
					case Process.ON: 
						/*if (getActionByName("moveRight").phase == Process.END)
						{
							_linearVelocity.x = -(velocityVec.x);
						}*/
						//_linearVelocity.x = -(velocityVec.x);
						break;
				}
					break;
				case "move": 
					switch (action.phase)
				{
					case Process.BEGIN:
						break;
					case Process.END:
						_linearVelocity.SetZero();
						_fixture.SetFriction(_friction);
						break;
					case Process.ON: 
						_fixture.SetFriction(0);
						if (getActionByName("moveRight").phase > 0 && !getActionByName("moveLeft").phase)
						{						
							_linearVelocity.x = velocityVec.x;
						}
						else if (getActionByName("moveLeft").phase > 0 && !getActionByName("moveRight").phase)
						{
							_linearVelocity.x = -(velocityVec.x);
						}
						else if (getActionByName("moveRight").phase > 0 && getActionByName("moveLeft").phase > 0)
						{
							_linearVelocity.SetZero();
						}
						break;
				}
					break;
				case "jump": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						_linearVelocity.y = -jumpHeight;
						onJump.dispatch();
						break;
					case Process.END: 
						break;
					case Process.ON: 
						break;
				}
					break;
				case "jumpAcceleration": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						break;
					case Process.END: 
						break;
					case Process.ON: 
						_linearVelocity.y -= jumpAcceleration;
						break;
				}
					break;
				case "moveRightMax": 
					switch (action.phase)
				{
					case Process.BEGIN: 
					case Process.END: 
					case Process.ON: 
						_linearVelocity.x = maxVelocity;
						break;
				}
					break;
				case "moveLeftMax": 
					switch (action.phase)
				{
					case Process.BEGIN: 
					case Process.END: 
					case Process.ON: 
						_linearVelocity.x = -maxVelocity;
						break;
				}
					break;
			}
		}
		
		/**
		 * 重写该方法定义
		 */
		override protected function doExtraActions():void
		{
		
		}
		
		override protected function updateStates():void
		{
			super.updateStates();
			_walkingSpeed = walkingSpeed;
			Logic.stateCondition(getStateByName("moveLeft"), _walkingSpeed < -acceleration);
			Logic.stateCondition(getStateByName("moveLeftMax"), _walkingSpeed < -maxVelocity);
			Logic.stateCondition(getStateByName("moveRight"), _walkingSpeed > acceleration);
			Logic.stateCondition(getStateByName("moveRightMax"), _walkingSpeed > maxVelocity);
			Logic.stateCondition(getStateByName("stop"), _walkingSpeed > -acceleration && _walkingSpeed < acceleration);
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
		}
		
		override protected function createBody():void 
		{
			super.createBody();
			_body.m_customGravity = new b2Vec2(0, 20);
		}
		
		override protected function createShape():void
		{
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.3);
		
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
		
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
		}
		
		override protected function beginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			super.beginContactHanlder(selfBody, contactedBody);
			if (contactedBody.GetUserData() is Wall)
			{
				getStateByName("touchWall").phase = Process.BEGIN;
			}
		}
		
		override protected function endContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			super.endContactHanlder(selfBody, contactedBody);
			if (contactedBody.GetUserData() is Wall)
			{
				getStateByName("touchWall").phase = Process.END;
			}
		}
		
		override protected function updateAnimation():void
		{
			var prevAnimation:String = _animation;
			
			if (getStateByName("onGround").phase == Process.OFF)
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
				_animation = animationName["ready"];
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
					if ( /*getStateByName("matchBegin").phase > 0 && */getActionByName("takeBall").phase > 0)
					{
						_animation = animationName["readyThrow"];
					}
					else
					{
						_animation = animationName["ready"];
					}
				}
			}
			
			if (prevAnimation != _animation)
				onAnimationChange.dispatch();
		}
		
		public function stop():void
		{
			if (getOrderByName("moveRight").phase == Process.ON)
			{
				getOrderByName("moveRight").phase = Process.END;
			}
			if (getOrderByName("moveLeft").phase == Process.ON)
			{
				getOrderByName("moveLeft").phase = Process.END;
			}
			if (getOrderByName("move").phase == Process.ON)
			{
				getOrderByName("move").phase = Process.END;
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