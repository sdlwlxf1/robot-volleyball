package src.data
{
    import __AS3__.vec.*;
    import src.constants.*;

    public class ZombieData extends Object
    {
        private static var instance:ZombieData;

        public function ZombieData(param1:SingletonEnforcer)
        {
            return;
        }// end function

        public function getLevel() : int
        {
            var _loc_8:int = 0;
            var _loc_1:* = this.Vector.<String>([GunConst.DAMAGE, GunConst.AMMO_NUM, GunConst.MAX_HEALTH, GunConst.BLADE]);
            var _loc_2:* = this.Vector.<String>([GunConst.FIRE_RATE, GunConst.ROCKET, GunConst.GRENADE, GunConst.HEALTH]);
            var _loc_3:* = this.Vector.<String>([GunConst.SPREAD, GunConst.MAGZ_CAPACITY, GunConst.RELOAD_SPEED, GunConst.ICE, GunConst.ACID, GunConst.FLAME]);
            var _loc_4:int = 0;
            var _loc_5:Number = 0;
            var _loc_6:Number = 0;
            var _loc_7:Number = 0;
            var _loc_9:int = 0;
            while (_loc_9 < _loc_1.length)
            {
                
                _loc_4 = _loc_4 + GunData.getInstance().getLevel(_loc_1[_loc_9]);
                _loc_9++;
            }
            _loc_5 = Math.round(_loc_4 / _loc_1.length);
            _loc_4 = 0;
            var _loc_10:int = 0;
            while (_loc_10 < _loc_2.length)
            {
                
                _loc_4 = _loc_4 + GunData.getInstance().getLevel(_loc_2[_loc_10]);
                _loc_10++;
            }
            _loc_6 = Math.round(_loc_4 / _loc_2.length);
            _loc_4 = 0;
            var _loc_11:int = 0;
            while (_loc_11 < _loc_3.length)
            {
                
                _loc_4 = _loc_4 + GunData.getInstance().getLevel(_loc_3[_loc_11]);
                _loc_11++;
            }
            _loc_7 = Math.floor(_loc_4 / _loc_3.length);
            _loc_8 = Math.max(_loc_5, _loc_6, _loc_7);
            return _loc_8;
        }// end function

        public static function getInstance() : ZombieData
        {
            if (instance == null)
            {
                instance = new ZombieData(new SingletonEnforcer());
            }
            return instance;
        }// end function

    }
}
