package src.factory
{
    import citrus.core.*;
    import citrus.objects.common.*;
    import citrus.view.spriteview.*;
    import flash.display.*;
    import src.*;
    import src.constants.*;
    import src.gameobjects.particle.*;
    import src.states.*;

    public class ParticleFactory extends Object
    {
        public static const TRAIL:String = "trail";
        public static const GRENADE_EXPLO:String = "grenade_explo";
        public static const ROCKET_EXPLO:String = "rocket_explo";
        public static const GUNNER:String = "gunner";
        public static const VIKING:String = "viking";
        public static const CRATE:String = "crate";
        public static const SHIELD:String = "shield";
        public static const HEALTH:String = "health";
        public static const HERO:String = "hero";
        public static const ZOMBIE:String = "zombie";

        public function ParticleFactory()
        {
            return;
        }// end function

        public function createMoneyParticle(param1:int, param2:int, param3:int) : void
        {
            if (!(CitrusEngine.getInstance().state is GameState) || MainClass(CitrusEngine.getInstance()).getGraphicQuality() < 2)
            {
                return;
            }
            var _loc_4:* = new MoneyParticle("money_part", {view:ZombieMoneyMC});
            new MoneyParticle("money_part", {view:ZombieMoneyMC}).x = param2;
            _loc_4.y = param3;
            _loc_4.group = GameState.EXPLO_GROUP;
            CitrusEngine.getInstance().state.add(_loc_4);
            var _loc_5:* = SpriteArt(CitrusEngine.getInstance().state.view.getArt(_loc_4)).content as MovieClip;
            (SpriteArt(CitrusEngine.getInstance().state.view.getArt(_loc_4)).content as MovieClip).moneyx.text = String(param1);
            return;
        }// end function

        public function createParticle(param1:String, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:Class = null;
            if (!(CitrusEngine.getInstance().state is GameState))
            {
                return;
            }
            switch(param1)
            {
                case TRAIL:
                {
                    if (MainClass(CitrusEngine.getInstance()).getGraphicQuality() <= 2)
                    {
                        return;
                    }
                    _loc_5 = BulletTrailMC;
                    break;
                }
                case GRENADE_EXPLO:
                {
                    _loc_5 = GrenadeExploMC;
                    break;
                }
                case ROCKET_EXPLO:
                {
                    _loc_5 = RocketExploMC;
                    break;
                }
                case GUNNER:
                {
                    _loc_5 = YellowBulletExploMC;
                    break;
                }
                case VIKING:
                {
                    _loc_5 = BrownBulletExploMC;
                    break;
                }
                case CRATE:
                {
                    _loc_5 = CrateExploMC;
                    break;
                }
                case SHIELD:
                {
                    _loc_5 = ShieldMC;
                    break;
                }
                case HEALTH:
                {
                    _loc_5 = HealthMC;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_6:* = new Particle("particle", {duration:param4, view:_loc_5});
            new Particle("particle", {duration:param4, view:_loc_5}).x = param2;
            _loc_6.y = param3;
            _loc_6.group = GameState.EXPLO_GROUP;
            CitrusEngine.getInstance().state.add(_loc_6);
            return;
        }// end function

        public function createLimbParticle(param1:String, param2:int, param3:int) : void
        {
            var _loc_4:Class = null;
            if (!(CitrusEngine.getInstance().state is GameState))
            {
                return;
            }
            var _loc_5:Number = 5;
            var _loc_6:Number = 200;
            switch(param1)
            {
                case HERO:
                {
                    _loc_4 = HeroLimbMC;
                    _loc_5 = 5;
                    _loc_6 = 500;
                    break;
                }
                case ZombieConst.GUNNER:
                {
                    _loc_4 = LimbGunnerMC;
                    break;
                }
                case ZombieConst.GRENADIER:
                {
                    _loc_4 = LimbGrenadierMC;
                    break;
                }
                case ZombieConst.ROCKET:
                {
                    _loc_4 = LimbRocketeerMC;
                    break;
                }
                case ZombieConst.VIKING:
                {
                    _loc_4 = LimbVikingMC;
                    break;
                }
                case ZombieConst.RIOT:
                {
                    _loc_4 = LimbRiotMC;
                    break;
                }
                case ZombieConst.GRIM:
                {
                    _loc_4 = LimbGrimMC;
                    break;
                }
                case ZombieConst.KNIGHT:
                {
                    _loc_4 = LimbKnightMC;
                    break;
                }
                case ZombieConst.PAN:
                {
                    _loc_4 = LimbPanMC;
                    break;
                }
                default:
                {
                    _loc_4 = LimbMC;
                    break;
                    break;
                }
            }
            var _loc_7:* = CitrusEngine.getInstance().state.add(new Emitter("limb")) as Emitter;
            (CitrusEngine.getInstance().state.add(new Emitter("limb")) as Emitter).graphic = _loc_4;
            _loc_7.x = param2;
            _loc_7.y = param3;
            _loc_7.gravityX = 0;
            _loc_7.gravityY = 10;
            _loc_7.maxImpulseX = 300;
            _loc_7.minImpulseX = -300;
            _loc_7.maxImpulseY = -400;
            _loc_7.emitFrequency = _loc_5;
            _loc_7.emitterLifeSpan = _loc_6;
            _loc_7.particleLifeSpan = 2000;
            _loc_7.group = GameState.EXPLO_GROUP;
            var _loc_8:* = new Particle("particle", {duration:500, view:BloodExploMC});
            new Particle("particle", {duration:500, view:BloodExploMC}).x = param2;
            _loc_8.y = param3;
            _loc_8.group = GameState.EXPLO_GROUP;
            CitrusEngine.getInstance().state.add(_loc_8);
            return;
        }// end function

        public function createHealthParticle(param1:int, param2:int) : void
        {
            if (!(CitrusEngine.getInstance().state is GameState))
            {
                return;
            }
            if (MainClass(CitrusEngine.getInstance()).getGraphicQuality() <= 2)
            {
                return;
            }
            var _loc_3:* = CitrusEngine.getInstance().state.add(new Emitter("limb")) as Emitter;
            _loc_3.graphic = HealthParticleMC;
            _loc_3.x = param1;
            _loc_3.y = param2;
            _loc_3.gravityX = 0;
            _loc_3.gravityY = -3;
            _loc_3.maxImpulseX = 0;
            _loc_3.minImpulseX = -50;
            _loc_3.emitAreaWidth = 30;
            _loc_3.emitAreaHeight = 50;
            _loc_3.maxImpulseY = -20;
            _loc_3.emitFrequency = 100;
            _loc_3.emitterLifeSpan = 80;
            _loc_3.particleLifeSpan = 1000;
            _loc_3.group = GameState.EXPLO_GROUP;
            return;
        }// end function

        public function createBloodParticle(param1:int) : void
        {
            var _loc_3:Class = null;
            if (!(CitrusEngine.getInstance().state is GameState))
            {
                return;
            }
            if (MainClass(CitrusEngine.getInstance()).getGraphicQuality() <= 1)
            {
                return;
            }
            var _loc_2:* = Math.ceil(Math.random() * 2);
            switch(_loc_2)
            {
                case 1:
                {
                    _loc_3 = Blood1MC;
                    break;
                }
                case 2:
                {
                    _loc_3 = Blood2MC;
                    break;
                }
                case 3:
                {
                    _loc_3 = Blood3MC;
                    break;
                }
                case 4:
                {
                    _loc_3 = Blood4MC;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_4:* = new Particle("particle", {duration:10000, view:_loc_3});
            new Particle("particle", {duration:10000, view:_loc_3}).x = param1;
            _loc_4.y = 330;
            _loc_4.group = GameState.BG_GROUP;
            CitrusEngine.getInstance().state.add(_loc_4);
            return;
        }// end function

    }
}
