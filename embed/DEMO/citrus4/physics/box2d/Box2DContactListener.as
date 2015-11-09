package citrus.physics.box2d {

	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;

	/**
	 * Used to report the contact's interaction between objects. It calls function in Box2dPhysicsObject.
	 */
	public class Box2DContactListener extends b2ContactListener {
		private var bodyA:b2Body;
		private var bodyB:b2Body;
		public var myContact:b2Contact;

		public function Box2DContactListener() {
		}

		override public function BeginContact(contact:b2Contact):void {
			
			contact.GetFixtureA().GetBody().GetUserData().handleBeginContact(contact);
			contact.GetFixtureB().GetBody().GetUserData().handleBeginContact(contact);
			
			myContact = contact;
			
			bodyA = contact.GetFixtureA().GetBody();
			bodyB = contact.GetFixtureB().GetBody();
			
			if (bodyA.beginContactHanlder != null) bodyA.beginContactWith(bodyB);
			if (bodyB.beginContactHanlder != null) bodyB.beginContactWith(bodyA);
		}
			
		override public function EndContact(contact:b2Contact):void {
			
			contact.GetFixtureA().GetBody().GetUserData().handleEndContact(contact);
			contact.GetFixtureB().GetBody().GetUserData().handleEndContact(contact);
			
			bodyA = contact.GetFixtureA().GetBody();
			bodyB = contact.GetFixtureB().GetBody();
			
			if (bodyA.endContactHanlder != null) bodyA.endContactWith(bodyB);
			if (bodyB.endContactHanlder != null) bodyB.endContactWith(bodyA);
		}

		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void {
			contact.GetFixtureA().GetBody().GetUserData().handlePreSolve(contact, oldManifold);
			contact.GetFixtureB().GetBody().GetUserData().handlePreSolve(contact, oldManifold);
		}

		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void {
			
			contact.GetFixtureA().GetBody().GetUserData().handlePostSolve(contact, impulse);
			contact.GetFixtureB().GetBody().GetUserData().handlePostSolve(contact, impulse);
		}

	}
}

