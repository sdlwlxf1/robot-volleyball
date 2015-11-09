package test2.data
{
    import __AS3__.vec.*;
    import flash.net.*;
    import src.constants.*;

    public class GunData extends Object
    {
        private var max_health_level:int = 1;
        private var damage_level:int = 1;
        private var spread_level:int = 1;
        private var reload_speed_level:int = 1;
        private var ammo_num_level:int = 1;
        private var magz_capacity_level:int = 1;
        private var fire_rate_level:int = 1;
        private var blade_level:int = 1;
        private var grenade_level:int = 1;
        private var rocket_level:int = 1;
        private var flame_level:int = 1;
        private var ice_level:int = 1;
        private var acid_level:int = 1;
        private var health_level:int = 1;
        private var sharedObject:SharedObject;
        private static var instance:GunData;

        public function GunData(param1:SingletonEnforcer)
        {
            this.sharedObject = SharedObject.getLocal("data");
            return;
        }// end function

        public function resetData() : void
        {
            this.max_health_level = 1;
            this.damage_level = 1;
            this.spread_level = 1;
            this.fire_rate_level = 1;
            this.ammo_num_level = 1;
            this.magz_capacity_level = 1;
            this.reload_speed_level = 1;
            this.blade_level = 1;
            this.rocket_level = 1;
            this.grenade_level = 1;
            this.flame_level = 1;
            this.acid_level = 1;
            this.ice_level = 1;
            this.health_level = 1;
            this.saveData();
            return;
        }// end function

        public function saveData() : void
        {
            this.sharedObject.data.max_health_level = this.max_health_level;
            this.sharedObject.data.damage_level = this.damage_level;
            this.sharedObject.data.spread_level = this.spread_level;
            this.sharedObject.data.fire_rate_level = this.fire_rate_level;
            this.sharedObject.data.ammo_num_level = this.ammo_num_level;
            this.sharedObject.data.magz_capacity_level = this.magz_capacity_level;
            this.sharedObject.data.reload_speed_level = this.reload_speed_level;
            this.sharedObject.data.blade_level = this.blade_level;
            this.sharedObject.data.rocket_level = this.rocket_level;
            this.sharedObject.data.grenade_level = this.grenade_level;
            this.sharedObject.data.flame_level = this.flame_level;
            this.sharedObject.data.acid_level = this.acid_level;
            this.sharedObject.data.ice_level = this.ice_level;
            this.sharedObject.data.health_level = this.health_level;
            this.sharedObject.flush();
            return;
        }// end function

        public function loadData() : void
        {
            if (!this.sharedObject.data.hasOwnProperty("blade_level"))
            {
                return;
            }
            this.max_health_level = this.sharedObject.data.max_health_level;
            this.damage_level = this.sharedObject.data.damage_level;
            this.spread_level = this.sharedObject.data.spread_level;
            this.fire_rate_level = this.sharedObject.data.fire_rate_level;
            this.ammo_num_level = this.sharedObject.data.ammo_num_level;
            this.magz_capacity_level = this.sharedObject.data.magz_capacity_level;
            this.reload_speed_level = this.sharedObject.data.reload_speed_level;
            this.blade_level = this.sharedObject.data.blade_level;
            this.rocket_level = this.sharedObject.data.rocket_level;
            this.grenade_level = this.sharedObject.data.grenade_level;
            this.flame_level = this.sharedObject.data.flame_level;
            this.acid_level = this.sharedObject.data.acid_level;
            this.ice_level = this.sharedObject.data.ice_level;
            this.health_level = this.sharedObject.data.health_level;
            return;
        }// end function

        public function setAllLevel(param1:int) : void
        {
            this.max_health_level = param1;
            this.damage_level = param1;
            this.spread_level = param1;
            this.fire_rate_level = param1;
            this.ammo_num_level = param1;
            this.magz_capacity_level = param1;
            this.reload_speed_level = param1;
            this.blade_level = param1;
            this.rocket_level = param1;
            this.grenade_level = param1;
            this.flame_level = param1;
            this.acid_level = param1;
            this.ice_level = param1;
            this.health_level = param1;
            return;
        }// end function

        public function increaseLevel(param1:String) : void
        {
            (this[param1 + "_level"] + 1);
            return;
        }// end function

        public function getLevel(param1:String) : int
        {
            return this[param1 + "_level"];
        }// end function

        public function allMaxed() : Boolean
        {
            var _loc_1:* = this.Vector.<String>([GunConst.MAX_HEALTH, GunConst.DAMAGE, GunConst.SPREAD, GunConst.FIRE_RATE, GunConst.RELOAD_SPEED, GunConst.AMMO_NUM, GunConst.MAGZ_CAPACITY, GunConst.BLADE, GunConst.ROCKET, GunConst.GRENADE, GunConst.ACID, GunConst.FLAME, GunConst.ICE, GunConst.HEALTH]);
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                if (this.getLevel(_loc_1[_loc_2]) < 5)
                {
                    return false;
                }
                _loc_2++;
            }
            return true;
        }// end function

        public static function getInstance() : GunData
        {
            if (instance == null)
            {
                instance = new GunData(new SingletonEnforcer());
            }
            return instance;
        }// end function

    }
}
