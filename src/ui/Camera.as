package ui 
{
	import aze.motion.eaze;
	import citrus.core.CitrusEngine;
	import flash.utils.setTimeout;
	import gameObjects.Player;
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class Camera 
	{
		
		private static var _ce:CitrusEngine = CitrusEngine.getInstance();
		
		static private var _timeScaleGate:Boolean = true;
		static private var _cameraZoomGate:Boolean = true;
		static private var _timeScaleChanging:Boolean = false;
		static private var _cameraZoomChanging:Boolean = false;
		
		static private var _timeTarget:Object = null;
		static private var _cameraTarget:Object = null;

		
		
		
		
		public function Camera() 
		{
			
		}
		
		public static function changeTimeScale(toTimeScale:Number, target:Object = null, duration:Number = 0.1):void
		{
			if (_timeScaleGate == true && target != null)
			{
				_timeTarget = target;
				_timeScaleGate = false;
				
			}
			
			if (_timeScaleChanging == false && (_timeTarget == target || target == null))
			{
				eaze(_ce).to(duration, { timeScale:toTimeScale } ).onComplete(changeTimeHandler);
				_timeScaleChanging = true;
			}
		}	
		
		static public function changeCameraZoom(toZoom:Number, target:Object = null, zoomEasing:Number = 0.1, duration:Number = 0.1):void 
		{
			if (_cameraZoomGate == true && target != null)
			{
				CitrusEngine.getInstance().state.view.camera.allowZoom = true;
				
				
				_cameraTarget = target;
				CitrusEngine.getInstance().state.view.camera.target = _cameraTarget;
				_cameraZoomGate = false;
				
			}
			
			if (_cameraZoomChanging == false && (_cameraTarget == target || target == null))
			{
				CitrusEngine.getInstance().state.view.camera.zoomEasing = zoomEasing;
				CitrusEngine.getInstance().state.view.camera.setZoom(toZoom);
				setTimeout(changeCameraZoomHandler, duration * 1000);
				_cameraZoomChanging = true;
			}
		}
		
		static private function changeCameraZoomHandler():void 
		{
			_cameraZoomGate = true;
			_cameraZoomChanging = false;
		}
		
		
		
		static public function openCameraZoomGate():void 
		{
			_cameraZoomGate = true;
			_cameraZoomChanging = false;
		}
		
		static public function closeCameraZoomGate():void 
		{
			_cameraZoomGate = false;
			_cameraZoomChanging = true;
		}
		
		static private function changeTimeHandler():void 
		{
			_timeScaleGate = true;
			_timeScaleChanging = false;
		}
		
		static public function openTimeScaleGate():void 
		{
			_timeScaleGate = true;
			_timeScaleChanging = false;
		}
		
		static public function closeTimeScaleGate():void 
		{
			_timeScaleGate = false;
			_timeScaleChanging = true;
		}
		
		
		
		static public function get timeScaleGate():Boolean 
		{
			return _timeScaleGate;
		}
		
		static public function set timeScaleGate(value:Boolean):void 
		{
			_timeScaleGate = value;
		}
		
		static public function get timeScaleChanging():Boolean 
		{
			return _timeScaleChanging;
		}
		
		static public function set timeScaleChanging(value:Boolean):void 
		{
			_timeScaleChanging = value;
		}

	}

}