package test2.factory
{
    import citrus.core.*;
    import src.constants.*;
    import src.data.*;
    import src.gameobjects.bullet.*;
    import src.gameobjects.zombie.zombieobjects.*;
    import src.states.*;

    public class BulletFactory extends Object
    {

        public function BulletFactory()
        {
            return;
        }// end function

        public function createBullet(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int = 1) : void
        {
            var _loc_7:Class = null;
            switch(param1)
            {
                case GunConst.ACID:
                {
                    _loc_7 = AcidBulletMC;
                    break;
                }
                case GunConst.FLAME:
                {
                    _loc_7 = FlameBulletMC;
                    break;
                }
                case GunConst.HEALTH:
                {
                    _loc_7 = HealthBulletMC;
                    break;
                }
                case GunConst.ICE:
                {
                    _loc_7 = IceBulletMC;
                    break;
                }
                case Bullet.NORMAL:
                {
                    _loc_7 = BulletMC;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_8:* = new Bullet(param1, {registration:"center", width:10, height:10, angle:param4, speed:param5, fuseDuration:500, explodeDuration:100, damage:param6, view:_loc_7});
            new Bullet(param1, {registration:"center", width:10, height:10, angle:param4, speed:param5, fuseDuration:500, explodeDuration:100, damage:param6, view:_loc_7}).x = param2;
            _loc_8.y = param3;
            _loc_8.group = GameState.BULLET_GROUP;
            CitrusEngine.getInstance().state.add(_loc_8);
            return;
        }// end function

        public function createSaw() : void
        {
            var _loc_1:* = new Saw(Saw.SAW, {registration:"topLeft", width:200, height:200, fuseDuration:5000, speed:5, view:SawMC});
            _loc_1.x = -100;
            _loc_1.y = 400;
            _loc_1.group = GameState.BULLET_GROUP;
            CitrusEngine.getInstance().state.add(_loc_1);
            return;
        }// end function

        public function createBossSaw(param1:int) : void
        {
            var _loc_2:BossSaw = null;
            var _loc_3:BossSaw = null;
            if (param1 == 1)
            {
                _loc_2 = new BossSaw("left_saw", {registration:"topLeft", width:200, height:200, fuseDuration:8000, speed:5, view:BossSawLeftMC});
                _loc_2.x = -100;
                _loc_2.y = 400;
                _loc_2.group = GameState.BULLET_GROUP;
                CitrusEngine.getInstance().state.add(_loc_2);
            }
            else
            {
                _loc_3 = new BossSaw("right_saw", {registration:"topLeft", width:200, height:200, fuseDuration:8000, speed:-5, view:BossSawRightMC});
                _loc_3.x = 1400;
                _loc_3.y = 400;
                _loc_3.group = GameState.BULLET_GROUP;
                CitrusEngine.getInstance().state.add(_loc_3);
            }
            return;
        }// end function

        public function createRocket(param1:int, param2:int, param3:Number, param4:Number = 0, param5:Number = 0, param6:int = 1000, param7:int = 50) : void
        {
            var _loc_8:* = new Rocket("rocket", {registration:"topLeft", width:30, height:15, fuseDuration:param6, explodeDuration:100, accelerationX:param3, accelerationY:param4, angle:param5, damage:param7, view:RocketMC});
            new Rocket("rocket", {registration:"topLeft", width:30, height:15, fuseDuration:param6, explodeDuration:100, accelerationX:param3, accelerationY:param4, angle:param5, damage:param7, view:RocketMC}).x = param1;
            _loc_8.y = param2;
            _loc_8.group = GameState.BULLET_GROUP;
            _loc_8.onDestroyed.add(GameState(CitrusEngine.getInstance().state).rocketExplodeHandler);
            CitrusEngine.getInstance().state.add(_loc_8);
            return;
        }// end function

        public function createGrenade(param1:int, param2:int, param3:int, param4:int = -5, param5:int = 50) : void
        {
            var _loc_6:* = new Grenade("grenade", {registration:"topLeft", width:15, height:10, horVelocity:param3, verVelocity:param4, damage:param5, view:GrenadeMC});
            new Grenade("grenade", {registration:"topLeft", width:15, height:10, horVelocity:param3, verVelocity:param4, damage:param5, view:GrenadeMC}).x = param1;
            _loc_6.y = param2;
            _loc_6.rotation = Math.random() * 360;
            _loc_6.group = GameState.BULLET_GROUP;
            _loc_6.onDestroyed.add(GameState(CitrusEngine.getInstance().state).rocketExplodeHandler);
            CitrusEngine.getInstance().state.add(_loc_6);
            return;
        }// end function

        public function createZombieBullet(param1:String, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:Class = null;
            var _loc_6:* = ZombieConst[param1.toUpperCase() + "_DAMAGE_LEVEL_" + ZombieData.getInstance().getLevel()];
            switch(param1)
            {
                case ZombieConst.GUNNER:
                {
                    _loc_5 = ZombieBulletMC;
                    break;
                }
                case ZombieConst.VIKING:
                {
                    _loc_5 = AxeMC;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_7:* = new ZombieBullet(param1, {registration:"topLeft", width:15, height:15, damage:_loc_6, fuseDuration:1500, explodeDuration:100, speed:param4, view:_loc_5});
            new ZombieBullet(param1, {registration:"topLeft", width:15, height:15, damage:_loc_6, fuseDuration:1500, explodeDuration:100, speed:param4, view:_loc_5}).x = param2;
            _loc_7.y = param3;
            _loc_7.group = GameState.BULLET_GROUP;
            CitrusEngine.getInstance().state.add(_loc_7);
            return;
        }// end function

        public function createZombieGrenade(param1:String, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:* = new ZombieGrenade("zombie_grenade", {registration:"topLeft", width:25, height:18, horVelocity:param4, view:ZombieGrenadeMC});
            new ZombieGrenade("zombie_grenade", {registration:"topLeft", width:25, height:18, horVelocity:param4, view:ZombieGrenadeMC}).x = param2;
            _loc_5.y = param3;
            _loc_5.rotation = Math.random() * 360;
            _loc_5.group = GameState.BULLET_GROUP;
            _loc_5.onDestroyed.add(GameState(CitrusEngine.getInstance().state).rocketExplodeHandler);
            CitrusEngine.getInstance().state.add(_loc_5);
            return;
        }// end function

        public function createZombieRocket(param1:int, param2:int, param3:Number) : void
        {
            var _loc_4:* = new ZombieRocket("zombie_rocket", {registration:"topLeft", width:40, height:20, fuseDuration:1500, explodeDuration:100, accelerationX:param3, view:ZombieRocketMC});
            new ZombieRocket("zombie_rocket", {registration:"topLeft", width:40, height:20, fuseDuration:1500, explodeDuration:100, accelerationX:param3, view:ZombieRocketMC}).x = param1;
            _loc_4.y = param2;
            _loc_4.group = GameState.BULLET_GROUP;
            _loc_4.onDestroyed.add(GameState(CitrusEngine.getInstance().state).rocketExplodeHandler);
            CitrusEngine.getInstance().state.add(_loc_4);
            return;
        }// end function

    }
}
