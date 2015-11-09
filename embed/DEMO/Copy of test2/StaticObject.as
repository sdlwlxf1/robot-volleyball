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
	
	
	public class StaticObject extends Box2DPhysicsObject
	{
		
		protected var _groundContacts:Array = []; //Used to determine if he's on ground or not.
		protected var _interactiveClass:Class = Ball;
		protected var _friction:Number = 2;
		protected var _controlsEnabled:Boolean = true;
		protected var _logic:Logic;
		
		/**
		 * Creates a new DynamicObject object.
		 */
		public function StaticObject(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			super.initialize(poolObjectParams);
			initializeLogic();
		}
		
		protected function initializeLogic():void
		{
			_logic = new StaticObjectLogic(this);
			_logic.doExtraActions = doExtraActions;
			_logic.doAction = doAction;
			_logic.updateStates = updateStates;
			_logic.updateAnimation = updateAnimation;
		}
		
		
		
		public function get logic():Logic 
		{
			return _logic as StaticObjectLogic;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			_logic.update();
		}
		
		protected function doAction(action:Action):void
		{
			return;
		}
		
		protected function updateAnimation():void 
		{
			return;
		}
		
		/**
		 * 重写该方法定义
		 */
		protected function doExtraActions():void
		{
			
		}
		
		protected function updateStates():void
		{
			
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
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("StaticObject");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{	
			
		}
		
		override public function handleEndContact(contact:b2Contact):void
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