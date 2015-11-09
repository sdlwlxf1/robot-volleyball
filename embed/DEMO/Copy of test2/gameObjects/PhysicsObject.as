package test2.gameObjects
{
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.box2d.Box2DUtils;
	import test2.utils.EasyBox2D;
	import flash.utils.Dictionary;
	import test2.data.Data;
	import test2.logic.Action;
	import test2.logic.State;
	
	import citrus.core.CitrusEngine;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2D;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.view.ISpriteView;
	
	/**
	 * You should extend this class to take advantage of Box2D. This class provides template methods for defining
	 * and creating Box2D bodies, fixtures, shapes, and joints. If you are not familiar with Box2D, you should first
	 * learn about it via the <a href="http://www.box2d.org/manual.html">Box2D Manual</a>.
	 */
	public class PhysicsObject extends Box2DPhysicsObject
	{
		
		protected var _data:Data;
		
		private var _states:Dictionary;
		private var _statesVector:Vector.<State>;
		
		private var _actions:Dictionary;
		private var _actionsVector:Vector.<test2.logic.Action>;
		protected var _collider:IBox2DPhysicsObject;
		
		protected var _invertedBody:Boolean = false;
		protected var _invertedViewAndBody:Boolean = false;
		
		/**
		 * Creates an instance of a Box2DPhysicsObject. Natively, this object does not default to any graphical representation,
		 * so you will need to set the "view" property in the params parameter.
		 */
		public function PhysicsObject(name:String, params:Object = null)
		{	
			super(name, params);
			_states = new Dictionary();
			_statesVector = new Vector.<State>();
			_actions = new Dictionary();
			_actionsVector = new Vector.<Action>();
		}
		
		
		override protected function createBody():void 
		{
			super.createBody();
			_body.beginContactHanlder = beginContactHanlder;
			_body.endContactHanlder = endContactHandlder;
		}
		
		protected function endContactHandlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			
		}
		
		protected function beginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			
		}
		
		public function addStateByName(name:String):State
		{
			var state:State = new State(name);
			_states[name] = state;
			_statesVector.push(state);
			return state;		
		}
		
		public function getStateByName(name:String):State
		{
			if (_states[name])
			{
				return _states[name];
			}
			else
			{
				return addStateByName(name);
			}
		}
		
		public function addActionByName(name:String):Action
		{
			var action:Action = new Action(name);
			_actions[name] = action;
			_actionsVector.push(action);
			return action;
		
		}
		
		public function getActionByName(name:String):Action
		{
			if (_actions[name])
			{
				return _actions[name];
			}
			else
			{
				return addActionByName(name);
			}
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			updateStates();
			updateActions();
			updateAnimation();
			updateProcess();
		}

		
		protected function updateActions():void
		{
			
		}
		
		protected function updateStates():void
		{
			
		}
		
				
		protected function updateAnimation():void
		{
		
		}
		
				
		private function updateProcess():void
		{
			for each (var state:State in _statesVector)
			{
				state.update();
			}
			for each (var action:Action in _actionsVector)
			{
				action.update();
			}
		}
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
			super.handleBeginContact(contact);
			_collider = Box2DUtils.CollisionGetOther(this, contact);
		}
		
		override public function handleEndContact(contact:b2Contact):void 
		{
			super.handleEndContact(contact);
			_collider = Box2DUtils.CollisionGetOther(this, contact);
		}
		
		override public function handlePostSolve(contact:b2Contact, impulse:b2ContactImpulse):void 
		{
			super.handlePostSolve(contact, impulse);
			_collider = Box2DUtils.CollisionGetOther(this, contact);
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void 
		{
			super.handlePreSolve(contact, oldManifold);
			_collider = Box2DUtils.CollisionGetOther(this, contact);
		}
		
		public function set invertedBody(value:Boolean):void
		{
			_invertedBody = value;
		}
		
		public function get invertedBody():Boolean
		{
			return _invertedBody;
		}
		
		public function set inverted(value:Boolean):void
		{
			_inverted = value;
		}
		
		public function set invertedViewAndBody(value:Boolean):void
		{
			_invertedViewAndBody = value;
			inverted = value;
			invertedBody = value;
		}
		
		public function get invertedViewAndBody():Boolean
		{
			return _invertedViewAndBody;
		}
		
		public function get data():Data 
		{
			return _data;
		}
		
		public function set data(value:Data):void 
		{
			_data = value;
		}
	
	}
}