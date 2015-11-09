package gameObjects 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.PhysicsCollisionCategories;
	import dragonBones.Armature;
	import starling.display.DisplayObject;
	import logics.Process;
	import utils.EasyBox2D;
	/**
	 * ...
	 * @author ...
	 */
	public class Gun extends ViewObject 
	{
		
		public var cannon:Cannon;
		
		public var ball:Ball;
		
		public var armature:Armature;
		
		
		
		public function Gun(name:String, params:Object = null) 
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
			/*_fixtureDef.isSensor = false;*/
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Gun");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();/*PhysicsCollisionCategories.Get("Ball");*/
		}
		
		public function fire():void
		{
			if (armature)
			{
				armature.animation.gotoAndPlay("fire");
			}
		}
		
		override protected function createShape():void 
		{
			if (_invertedViewAndBody)
			{
				
				
				_shape = EasyBox2D.createPolygonShape(width, height, new b2Vec2(-_width / 2 + bodyCenterX / 30, _height / 2 + bodyCenterY / 30));
			}
			else
			{
				
				
				_shape = EasyBox2D.createPolygonShape(width, height, new b2Vec2(_width / 2 + bodyCenterX / 30, _height / 2 + bodyCenterY / 30));
			}
		}
		
		/*override public function GunleBeginContact(contact:b2Contact):void 
		{
			super.GunleBeginContact(contact);
			if (_collider is Ball)
			{
				getStateByName("touchBall").phase = Process.BEGIN;
			}
		}
		
		override public function GunleEndContact(contact:b2Contact):void 
		{
			super.GunleEndContact(contact);
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