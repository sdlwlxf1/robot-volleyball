package gameObjects
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
	import logics.*;
	import math.MathMatrix22;
	
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
	
	public class DynamicObject extends PhysicsObject
	{	
		protected var _groundContact:b2Contact;
		public var animationName:Object;
		
		//properties
		/**
		 * This is the rate at which the DynamicObject speeds up when you move him left and right.
		 */
		[Inspectable(defaultValue="1")]
		public var acceleration:Number = 1;
		
		protected var _linearVelocity:b2Vec2;
		
		protected var _groundContacts:Array = []; //Used to determine if he's on ground or not.
		protected var _interactiveClass:Class = Ball;
		protected var _friction:Number = 1;
		protected var _controlsEnabled:Boolean = true;
		protected var _combinedGroundAngle:Number = 0;
		
		protected var _control:String = "auto";
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
			updateCallEnabled = true;
		}
		
		protected function initializeBody():void 
		{

		}
		
		override public function addPhysics():void 
		{
			initializeBody();
			super.addPhysics();
			_linearVelocity = _body.GetLinearVelocity();
		}
		
		override protected function updateStates():void
		{
			super.updateStates();
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
			super.handlePreSolve(contact, oldManifold);
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			
			if (_collider is Ground)
			{
				_groundContact = contact;
			}
			
			//Collision angle if we don't touch a Sensor.
			if (contact.GetManifold().m_localPoint && !(_collider is Sensor)) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				var normalPoint:Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;
				
				if ((collisionAngle > 45 && collisionAngle < 135) || (collisionAngle > -30 && collisionAngle < 10 && collisionAngle != 0) || collisionAngle == -90)
				{
					//we don't want the Hero to be set up as onGround if it touches a cloud.
					if (_collider is Platform && (_collider as Platform).oneWay && collisionAngle == -90)
						return;
					
					_groundContacts.push(_collider.body.GetFixtureList());
					getStateByName("onGround").phase = Process.BEGIN;
					updateCombinedGroundAngle();
				}
			}
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
			
			if (_collider is Ground)
			{
				_groundContact = contact;
			}
			
			//Remove from ground contacts, if it is one.
			var index:int = _groundContacts.indexOf(_collider.body.GetFixtureList());
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
		
		
		
		public function get control():String
		{
			return _control;
		}
		
		public function set control(value:String):void
		{
			_control = value;
		}
		
		public function get linearVelocity():b2Vec2 
		{
			return _linearVelocity;
		}
	
	}
}