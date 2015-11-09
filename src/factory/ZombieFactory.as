package src.factory
{
    import citrus.core.*;
    import citrus.view.spriteview.*;
    import flash.display.*;
    import src.constants.*;
    import src.data.*;
    import src.gameobjects.player.*;
    import src.gameobjects.zombie.*;
    import src.states.*;

    public class ZombieFactory extends Object
    {

        public function ZombieFactory()
        {
            return;
        }// end function

        public function createZombie(param1:String, param2:int, param3:int) : void
        {
            var _loc_4:Class = null;
            var _loc_5:int = 0;
            var _loc_16:Zombie = null;
            _loc_5 = ZombieConst[String(param1 + "_damage_level_" + ZombieData.getInstance().getLevel()).toUpperCase()];
            var _loc_6:* = ZombieConst[String(param1 + "_speed").toUpperCase()];
            var _loc_7:* = ZombieConst[String(param1 + "_health_level_" + ZombieData.getInstance().getLevel()).toUpperCase()];
            var _loc_8:int = 50;
            var _loc_9:int = 95;
            var _loc_10:int = 10;
            var _loc_11:int = -20;
            var _loc_12:int = 30;
            var _loc_13:int = 30;
            var _loc_14:int = 1000;
            var _loc_15:int = 800;
            switch(param1)
            {
                case ZombieConst.NORMAL:
                {
                    _loc_4 = ZombieMC;
                    _loc_14 = 666;
                    _loc_15 = 333;
                    break;
                }
                case ZombieConst.PAN:
                {
                    _loc_4 = PanZombieMC;
                    _loc_14 = 666;
                    _loc_15 = 416;
                    break;
                }
                case ZombieConst.FRANK:
                {
                    _loc_4 = FrankMC;
                    _loc_9 = 100;
                    _loc_14 = 1100;
                    _loc_12 = 50;
                    _loc_13 = 50;
                    break;
                }
                case ZombieConst.BABY:
                {
                    _loc_4 = BabyZombieMC;
                    _loc_14 = 666;
                    _loc_15 = 250;
                    break;
                }
                case ZombieConst.GUNNER:
                {
                    _loc_4 = GunnerZombieMC;
                    break;
                }
                case ZombieConst.GRENADIER:
                {
                    _loc_4 = GrenadierMC;
                    _loc_14 = 1500;
                    break;
                }
                case ZombieConst.RIOT:
                {
                    _loc_4 = RiotZombieMC;
                    _loc_14 = 833;
                    _loc_15 = 416;
                    break;
                }
                case ZombieConst.ROCKET:
                {
                    _loc_4 = RocketZombieMC;
                    _loc_14 = 2000;
                    _loc_10 = 60;
                    _loc_11 = -50;
                    break;
                }
                case ZombieConst.KNIGHT:
                {
                    _loc_4 = KnightZombieMC;
                    _loc_14 = 1166;
                    _loc_15 = 666;
                    _loc_9 = 100;
                    _loc_10 = 40;
                    _loc_11 = -30;
                    _loc_12 = 80;
                    _loc_13 = 80;
                    break;
                }
                case ZombieConst.VIKING:
                {
                    _loc_4 = VikingZombieMC;
                    _loc_14 = 2000;
                    break;
                }
                case ZombieConst.GRIM:
                {
                    _loc_4 = GrimZombieMC;
                    _loc_14 = 1166;
                    _loc_15 = 666;
                    _loc_12 = 60;
                    _loc_13 = 60;
                    _loc_10 = 30;
                    _loc_11 = -20;
                    break;
                }
                default:
                {
                    break;
                }
            }
            switch(param1)
            {
                case ZombieConst.GUNNER:
                {
                    _loc_16 = new ZombieGunner(param1, {registration:"topLeft", width:_loc_8, height:_loc_9, hero:CitrusEngine.getInstance().state.getObjectByName("hero") as Player, attackDelay:_loc_14, view:_loc_4});
                    break;
                }
                case ZombieConst.VIKING:
                {
                    _loc_16 = new ZombieViking(param1, {registration:"topLeft", width:_loc_8, height:_loc_9, hero:CitrusEngine.getInstance().state.getObjectByName("hero") as Player, attackDelay:_loc_14, view:_loc_4});
                    break;
                }
                case ZombieConst.GRENADIER:
                {
                    _loc_16 = new ZombieGrenadier(param1, {registration:"topLeft", width:_loc_8, height:_loc_9, hero:CitrusEngine.getInstance().state.getObjectByName("hero") as Player, attackDelay:_loc_14, view:_loc_4});
                    break;
                }
                case ZombieConst.ROCKET:
                {
                    _loc_16 = new ZombieRocketer(param1, {registration:"topLeft", width:_loc_8, height:_loc_9, hero:CitrusEngine.getInstance().state.getObjectByName("hero") as Player, attackDelay:_loc_14, view:_loc_4});
                    break;
                }
                default:
                {
                    _loc_16 = new Zombie(param1, {registration:"topLeft", width:_loc_8, height:_loc_9, hero:CitrusEngine.getInstance().state.getObjectByName("hero") as Player, attackDelay:_loc_14, meleeWidth:_loc_12, meleeOffsetX:_loc_13, sensorWidth:_loc_10, sensorOffsetX:_loc_11, view:_loc_4});
                    break;
                    break;
                }
            }
            _loc_16.x = param2;
            _loc_16.y = param3;
            _loc_16.meleeDelay = _loc_15;
            _loc_16.speed = _loc_6;
            _loc_16.damage = _loc_5;
            _loc_16.health = _loc_7;
            _loc_16.group = GameState.ENEMY_GROUP;
            _loc_16.onDead.add(GameState(CitrusEngine.getInstance().state).zombieDeadHandler);
            CitrusEngine.getInstance().state.add(_loc_16);
            var _loc_17:* = SpriteArt(CitrusEngine.getInstance().state.view.getArt(_loc_16)).content as MovieClip;
            (SpriteArt(CitrusEngine.getInstance().state.view.getArt(_loc_16)).content as MovieClip).shadowx.visible = false;
            return;
        }// end function

    }
}
