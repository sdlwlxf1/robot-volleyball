package unit4399.events{
    import flash.events.Event;

    public class SaveEvent extends Event {
    	public static const LOG:String = "logreturn";
		public static const SAVE_SET:String = "saveuserdata";
		public static const SAVE_GET:String = "getuserdata";
		public static const SAVE_LIST:String = "getuserdatalist";
		
        protected var _data:Object;
		/**
		 *	Event(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		 */
        public function SaveEvent(type:String, dataOb:Object, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            _data = dataOb;
        }
		public function get ret():Object
		{
			return _data;
		}
        public function get data():Object{
            return _data;
        }
        override public function toString():String{
            return formatToString("DataEvent:", "type", "bubbles", "cancelable", "data");
        }
        override public function clone():Event{
            return new SaveEvent(type, data, bubbles, cancelable);
        }
}
}
