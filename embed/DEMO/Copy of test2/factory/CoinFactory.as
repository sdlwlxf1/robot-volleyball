package src.factory
{
    import citrus.core.*;
    import src.gameobjects.platform.*;
    import src.states.*;

    public class CoinFactory extends Object
    {

        public function CoinFactory()
        {
            return;
        }// end function

        public function createCoin(param1:String, param2:int, param3:int, param4:int = 0, param5:int = 0) : void
        {
            var _loc_6:Class = null;
            switch(param1)
            {
                case Coin.BRONZE:
                {
                    _loc_6 = BronzeCoinMC;
                    break;
                }
                case Coin.SILVER:
                {
                    _loc_6 = SilverCoinMC;
                    break;
                }
                case Coin.GOLD:
                {
                    _loc_6 = CoinMC;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_7:* = new Coin(param1, {registration:"topLeft", width:20, height:25, velX:param4, velY:param5, view:_loc_6});
            new Coin(param1, {registration:"topLeft", width:20, height:25, velX:param4, velY:param5, view:_loc_6}).x = param2;
            _loc_7.y = param3;
            _loc_7.group = GameState.COIN_GROUP;
            CitrusEngine.getInstance().state.add(_loc_7);
            return;
        }// end function

    }
}
