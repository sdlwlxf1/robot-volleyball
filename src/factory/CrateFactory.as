package src.factory
{
    import citrus.core.*;
    import citrus.view.spriteview.*;
    import flash.display.*;
    import src.gameobjects.platform.*;
    import src.states.*;

    public class CrateFactory extends Object
    {
        public static const HEALTH:String = "health";
        public static const ICE:String = "ice";
        public static const ACID:String = "acid";
        public static const ROCKET:String = "rocket";
        public static const GRENADE:String = "grenade";
        public static const SAW:String = "saw";
        public static const SHIELD:String = "shield";
        public static const COIN:String = "coin";

        public function CrateFactory()
        {
            return;
        }// end function

        public function createCrate(param1:String, param2:int) : void
        {
            var _loc_3:* = new PowerUpCrate(param1, {registration:"topLeft", width:70, height:70, view:CrateMC});
            _loc_3.x = param2;
            _loc_3.y = -50;
            _loc_3.rotation = Math.random() * 180;
            _loc_3.group = GameState.CRATE_GROUP;
            _loc_3.onDestroyed.add(GameState(CitrusEngine.getInstance().state).crateDestroyedHandler);
            CitrusEngine.getInstance().state.add(_loc_3);
            var _loc_4:* = SpriteArt(CitrusEngine.getInstance().state.view.getArt(_loc_3)).content as MovieClip;
            (SpriteArt(CitrusEngine.getInstance().state.view.getArt(_loc_3)).content as MovieClip).gotoAndStop(param1);
            return;
        }// end function

    }
}
