package citrus.physics.awayphysics {

	import awayphysics.dynamics.AWPDynamicsWorld;

	import citrus.physics.APhysicsEngine;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.view.ISpriteView;

	import flash.geom.Vector3D;
	
	/**
	 * This is a simple wrapper class that allows you to add an AwayPhysics world to your game's state.
	 * Add an instance of this class to your State before you create any physics bodies. It will need to 
	 * exist first, or your physics bodies will throw an error when they try to create themselves.
	 */
	public class AwayPhysics extends APhysicsEngine implements ISpriteView {
		
		/**
		 * timeStep the amount of time to simulate, this should not vary.
		 */
		public var timeStep:Number = 1 / 60;
		
		/**
		 * maxSubSteps the maximum number of steps that AwayPhysics is allowed to take each time you call it.
		 */
		public var maxSubSteps:uint = 1;
		
		/**
		 * fixedTimeStep is the size of that internal step.
		 */
		 public var fixedTimeStep:Number = 1 / 60;
		
		private var _world:AWPDynamicsWorld;
		private var _gravity:Vector3D = new Vector3D(0, -10, 0);
		
		/**
		 * Creates and initializes an AwayPhysics world. 
		 */
		public function AwayPhysics(name:String, params:Object = null) {
			
			if (params && params.view == undefined)
				params.view = AwayPhysicsDebugArt;
			else if (params == null)
				params = {view:AwayPhysicsDebugArt};
			
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void {
			
			super.initialize();
			
			_realDebugView = _view;
			
			_world = new AWPDynamicsWorld();
			_world.initWithDbvtBroadphase();
			_world.gravity = _gravity;
			_world.collisionCallbackOn = true;
			
			//Set up collision categories
			PhysicsCollisionCategories.Add("GoodGuys");
			PhysicsCollisionCategories.Add("BadGuys");
			PhysicsCollisionCategories.Add("Level");
			PhysicsCollisionCategories.Add("Items");
		}

		override public function destroy():void {
			
			_world.cleanWorld(true);
			_world.dispose();
			
			super.destroy();
		}
		
		/**
		 * Gets a reference to the actual AwayPhysics world object. 
		 */
		public function get world():AWPDynamicsWorld {
			return _world;
		}
		
		/**
		 * Change the gravity of the world.
		 */
		public function get gravity():Vector3D {
			return _gravity;
		}
		
		public function set gravity(value:Vector3D):void {
			_gravity = value;
			
			if (_world)
				_world.gravity = _gravity;
		}
		
		/**
		 * This is where the time step of the physics world occurs.
		 */
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			
			_world.step(timeStep, maxSubSteps, fixedTimeStep);
		}
	}
}
