package dragonBones.events
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	[Event(name="soundFrame", type="dragonBones.events.SoundEvent")]
	
	/**
	 * A manager object control the sound event.
	 */
	public final class SoundEventManager extends EventDispatcher
	{
		private static var _instance:SoundEventManager;
		public static function getInstance():SoundEventManager
		{
			if(!_instance){
				_instance = new SoundEventManager();
			}
			return _instance;
		}
		
		public function SoundEventManager()
		{
			super();
			if (_instance) {
				throw new IllegalOperationError("Singleton already constructed!");
			}
		}
	}
}