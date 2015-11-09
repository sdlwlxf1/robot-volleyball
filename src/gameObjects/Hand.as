package gameObjects 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.PhysicsCollisionCategories;
	import starling.display.DisplayObject;
	import logics.Process;
	import utils.EasyBox2D;
	/**
	 * ...
	 * @author ...
	 */
	public class Hand extends ViewObject 
	{
		
		public var player:Player;
		
		public var ball:Ball;
		
		
		
		public function Hand(name:String, params:Object = null) 
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void 
		{
			super.initialize(poolObjectParams);
		}
		
		override protected function defineFixture():void 
		{
			super.defineFixture();
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("PlayerHand");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.Get("Ball");
		}
		
		override protected function createShape():void 
		{
			if (_invertedViewAndBody)
			{
				_shape = EasyBox2D.createPolygonShape(width, height, new b2Vec2(-_width / 2, _height / 2));
			}
			else
			{
				_shape = EasyBox2D.createPolygonShape(width, height, new b2Vec2(_width / 2, _height / 2));
			}
		}
		
		/*override public function handleBeginContact(contact:b2Contact):void 
		{
			super.handleBeginContact(contact);
			if (_collider is Ball)
			{
				getStateByName("touchBall").phase = Process.BEGIN;
			}
		}
		
		override public function handleEndContact(contact:b2Contact):void 
		{
			super.handleEndContact(contact);
			if (_collider is Ball)
			{
				getStateByName("touchBall").phase = Process.END;
			}
		}*/
		
		override protected function beginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			super.beginContactHanlder(selfBody, contactedBody);

			if (contactedBody.GetUserData() is Ball)
			{
				ball = contactedBody.GetUserData();
				getStateByName("touchBall").phase = Process.BEGIN;
			}
		}
		
		override protected function endContactHandlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			super.endContactHandlder(selfBody, contactedBody);
			
			if (contactedBody.GetUserData() is Ball)
			{
				ball = contactedBody.GetUserData();
				getStateByName("touchBall").phase = Process.END;
			}
		}
		
		
	}

}