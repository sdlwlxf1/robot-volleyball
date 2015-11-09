package src.factory
{
    import src.constants.*;
    import src.states.*;
    import src.states.screen.*;

    public class ScreenFactory extends Object
    {
        private var menuState:MenuState;

        public function ScreenFactory(param1:MenuState)
        {
            this.menuState = param1;
            return;
        }// end function

        public function createScreen(param1:String) : void
        {
            var _loc_2:* = this.getScreen(param1);
            this.menuState.addChild(_loc_2);
            return;
        }// end function

        private function getScreen(param1:String) : BaseScreen
        {
            switch(param1)
            {
                case ScreenNameConst.MENU_SCREEN:
                {
                    return new MenuScreen(this.menuState);
                }
                case ScreenNameConst.UPGRADE_SCREEN:
                {
                    return new UpgradeScreen(this.menuState);
                }
                default:
                {
                    break;
                }
            }
            return null;
        }// end function

        public function destroy() : void
        {
            this.menuState = null;
            return;
        }// end function

    }
}
