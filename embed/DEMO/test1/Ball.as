package test1
{
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.utils.EasyBox2D;
	
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	/**
	 * A Platform is a rectangular object that is meant to be stood on. It can be given any position, width, height, or rotation to suit your level's needs.
	 * You can make your platform a "one-way" or "cloud" platform so that you can jump on from underneath (collision is only applied when coming from above it).
	 *
	 * There are two ways of adding graphics for your platform. You can give your platform a graphic just like you would any other object (by passing a graphical
	 * class into the view property) or you can leave your platform invisible and line it up with your backgrounds for a more custom look.
	 *
	 * <ul>Properties:
	 * <li>oneWay - Makes the platform only collidable when falling from above it.</li></ul>
	 */
	public class Ball extends Box2DPhysicsObject
	{
		
		private var launchSpeed:b2Vec2 = new b2Vec2(-15, -6);
		
		public function Ball(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{			
			super.initialize(poolObjectParams);
			_body.SetLinearVelocity(launchSpeed);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
	
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			//_bodyDef.angularDamping = 10;
			_bodyDef.linearDamping = 1;
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.m_customGravity = new b2Vec2(0, 5);
		}
		
		override protected function createShape():void
		{
			super.createShape();
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.density = 0.01;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Items");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("GoodGuys");
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
		}
		
		override protected function defineJoint():void
		{
			
		}
		
		override protected function createJoint():void
		{

		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			super.handlePreSolve(contact, oldManifold);
			//trace("小球碰撞提前处理");
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			//trace("小球碰撞开始处理");
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
			//trace("小球碰撞结束处理");
		}
	}
}