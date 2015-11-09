package test2.gameObjects 
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;
	import test2.logic.Process;
	/**
	 * ...
	 * @author ...
	 */
	public class Ground extends StaticObject 
	{
		private var _oneWay:Boolean;
		
		public function Ground(name:String, params:Object = null) 
		{
			super(name, params);
		}
		
		/**
		 * Makes the platform only collidable when falling from above it.
		 */
		public function get oneWay():Boolean
		{
			return _oneWay;
		}
		
		[Inspectable(defaultValue="false")]
		public function set oneWay(value:Boolean):void
		{
			if (_oneWay == value)
				return;
			
			_oneWay = value;
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			
			_bodyDef.type = b2Body.b2_staticBody;
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Ground");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
		}
			
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void {
			
			if (_oneWay) {
				
				//Get the y position of the top of the platform
				var platformTop:Number = _body.GetPosition().y - _height / 2;
				
				//Get the half-height of the collider, if we can guess what it is (we are hoping the collider extends PhysicsObject).
				var colliderHalfHeight:Number = 0;
				var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
				if (collider.height)
					colliderHalfHeight = collider.height / _box2D.scale / 2;
				else
					return;
				
				//Get the y position of the bottom of the collider
				var colliderBottom:Number = collider.body.GetPosition().y + colliderHalfHeight;
				
				//Find out if the collider is below the platform
				if (platformTop < colliderBottom)
					contact.SetEnabled(false);
			}
		}
		
		/*override protected function beginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			super.beginContactHanlder(selfBody, contactedBody);
			if (contactedBody.GetUserData().name == "ball")
			{
				(contactedBody.GetUserData() as Ball).getStateByName("touchGround").phase = Process.BEGIN;
				getStateByName("touchBall").phase = Process.BEGIN;
			}
		}
		
		override protected function endContactHanlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			super.endContactHanlder(selfBody, contactedBody);
			if (contactedBody.GetUserData().name == "ball")
			{
				(contactedBody.GetUserData() as Ball).getStateByName("touchGround").phase = Process.END;
				getStateByName("touchBall").phase = Process.END;
			}
		}*/
		
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