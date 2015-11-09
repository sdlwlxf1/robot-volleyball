package unit4399.events{
    import flash.events.Event;

    public class MedalEvent extends Event {
		public static const MEDAL_RESTARTGAME:String = "medalRestartGame";
		
        protected var _data:Object;
		
        public function MedalEvent(type:String, dataOb:Object=null, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            _data = dataOb;
        }
		
        public function get data():Object{
            return _data;
        }
        
        override public function clone():Event{
            return new MedalEvent(type, data, bubbles, cancelable);
        }
	}
}
