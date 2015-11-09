package unit4399.events{
    import flash.events.Event;

    public class PayEvent extends Event {
		public static const RECHARGED_MONEY:String = "rechargedMoney";
		public static const PAIED_MONEY:String = "paiedMoney";
    	public static const LOG:String = "logsuccess";
		public static const INC_MONEY:String = "incMoney";
		public static const DEC_MONEY:String = "decMoney";
		public static const GET_MONEY:String = "getMoney";
		public static const PAY_MONEY:String = "payMoney";
		public static const PAY_ERROR:String ="payError";//0|请重试!若还不行,请重新登录!!,1|程序有问题，请联系技术人员100584399!!2|请检查,目前传进来的值等于0!!,3|游戏不存在或者没有支付接口!!
														 //4|余额不足!!,5|出错了,请重新登录!
		
        protected var _data:Object;
		
        public function PayEvent(type:String, dataOb:Object, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            _data = dataOb;
        }
		
        public function get data():Object{
            return _data;
        }
        
        override public function clone():Event{
            return new PayEvent(type, data, bubbles, cancelable);
        }
	}
}
