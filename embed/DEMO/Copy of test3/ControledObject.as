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
		}
		
		override protected function updateActions():void
		{
			super.updateActions();		
		}
		
		override protected function updateStates():void
		{
			super.updateStates();
			
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
		}
		
		override protected function createBody():void
		{
			super.createBody();

		}
		
		override protected function createShape():void
		{
			
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
		
		
		
		override protected function updateAnimation():void
		{
			
		}

	}
}