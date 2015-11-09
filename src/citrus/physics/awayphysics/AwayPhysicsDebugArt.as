package citrus.physics.awayphysics {

	import away3d.containers.ObjectContainer3D;

	import awayphysics.debug.AWPDebugDraw;

	import citrus.core.CitrusEngine;
	import citrus.core.away3d.Away3DCitrusEngine;
	import citrus.physics.IDebugView;
	import citrus.view.away3dview.Away3DArt;

	import flash.geom.Matrix;

	/**
	 * This displays AwayPhysics's debug graphics. It does so properly through Citrus Engine's view manager.
	 */
	public class AwayPhysicsDebugArt extends ObjectContainer3D implements IDebugView {
		
		private var _debugDrawer:AWPDebugDraw;
		
		private var _ce:Away3DCitrusEngine;
		
		private var _awayPhysics:AwayPhysics;

		public function AwayPhysicsDebugArt() {
			
			_ce = CitrusEngine.getInstance() as Away3DCitrusEngine;
			
			if (parent is Away3DArt)
				_awayPhysics = Away3DArt(parent).citrusObject as AwayPhysics;
			else
				_awayPhysics = _ce.state.getFirstObjectByType(AwayPhysics) as AwayPhysics;
				
			_debugDrawer = new AWPDebugDraw(_ce.away3D, _awayPhysics.world);
		}
		
		public function initialize():void {
			
		}
		
		public function update():void {
			
			if (_debugDrawer && _awayPhysics.visible)
				_debugDrawer.debugDrawWorld();
		}
		
		public function debugMode(flags:uint):void {
			_debugDrawer.debugMode = flags;
		}
		
		public function destroy():void {
			
		}
		
		public function set transformMatrix(m:Matrix):void {
			
		}
		
		public function get transformMatrix():Matrix {
			return null;
		}
		
		public function set visibility(val:Boolean):void {
			
		}
		public function get visibility():Boolean {
			return true;	
		}
		
		public function get debugDrawer():* {
			
			return _debugDrawer;
		}
	}
}
