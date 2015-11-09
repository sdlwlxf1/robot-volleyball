package citrus.view.away3dview {

	import away3d.containers.ObjectContainer3D;

	import citrus.core.CitrusEngine;
	import citrus.physics.APhysicsEngine;
	import citrus.physics.IDebugView;

	/**
	 * A wrapper for Away3D to display the debug view of the different physics engine.
	 */
	public class Away3DPhysicsDebugView extends ObjectContainer3D {
		
		private var _ce:CitrusEngine;
		
		private var _physicsEngine:APhysicsEngine;
		private var _debugView:IDebugView;
		
		public function Away3DPhysicsDebugView() {
			
			_ce = CitrusEngine.getInstance();
			
			_physicsEngine = _ce.state.getFirstObjectByType(APhysicsEngine) as APhysicsEngine;
			_debugView = new _physicsEngine.realDebugView();
						
			if ((_ce.state.view as Away3DView).mode != "3D") {
				
				_debugView.initialize();
			}
		}
		
		public function update():void {
			_debugView.update();
		}
		
		public function debugMode(mode:uint):void {
			_debugView.debugMode(mode);
		}
	}
}
