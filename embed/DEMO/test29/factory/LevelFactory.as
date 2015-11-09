package src.factory
{
    import __AS3__.vec.*;
    import src.constants.*;

    public class LevelFactory extends Object
    {
        private var zombieArray:Vector.<String>;

        public function LevelFactory()
        {
            this.zombieArray = new Vector.<String>;
            return;
        }// end function

        public function getZombieArray(param1:int) : Vector.<String>
        {
            var _loc_3:int = 0;
            this.selectLevel(param1);
            var _loc_2:* = new Vector.<String>(this.zombieArray.length);
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_3 = int(Math.random() * this.zombieArray.length);
                _loc_2[_loc_4] = this.zombieArray.splice(_loc_3, 1)[0];
                _loc_4++;
            }
            return _loc_2;
        }// end function

        private function selectLevel(param1:int) : void
        {
            switch(param1)
            {
                case 1:
                {
                    this.insertZombie(ZombieConst.NORMAL, 50);
                    break;
                }
                case 2:
                {
                    this.insertZombie(ZombieConst.NORMAL, 30);
                    this.insertZombie(ZombieConst.PAN, 20);
                    break;
                }
                case 3:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 30);
                    break;
                }
                case 4:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 40);
                    this.insertZombie(ZombieConst.BABY, 20);
                    break;
                }
                case 5:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 40);
                    this.insertZombie(ZombieConst.BABY, 30);
                    break;
                }
                case 6:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 30);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.GUNNER, 20);
                    break;
                }
                case 7:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 20);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    break;
                }
                case 8:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 30);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    break;
                }
                case 9:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 30);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 20);
                    break;
                }
                case 10:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 30);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    break;
                }
                case 11:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 20);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 20);
                    break;
                }
                case 12:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 20);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 30);
                    break;
                }
                case 13:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 20);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.FRANK, 20);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 40);
                    break;
                }
                case 14:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 40);
                    this.insertZombie(ZombieConst.RIOT, 40);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    break;
                }
                case 15:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 40);
                    this.insertZombie(ZombieConst.GRENADIER, 40);
                    break;
                }
                case 16:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 10);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 50);
                    this.insertZombie(ZombieConst.GRENADIER, 50);
                    break;
                }
                case 17:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 20);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 20);
                    this.insertZombie(ZombieConst.RIOT, 40);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    this.insertZombie(ZombieConst.GRIM, 20);
                    break;
                }
                case 18:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 10);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 40);
                    this.insertZombie(ZombieConst.GRENADIER, 40);
                    this.insertZombie(ZombieConst.GRIM, 30);
                    break;
                }
                case 19:
                {
                    this.insertZombie(ZombieConst.NORMAL, 30);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.FRANK, 10);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 30);
                    this.insertZombie(ZombieConst.GRENADIER, 20);
                    this.insertZombie(ZombieConst.GRIM, 40);
                    break;
                }
                case 20:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 30);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 30);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    this.insertZombie(ZombieConst.GRIM, 20);
                    this.insertZombie(ZombieConst.ROCKET, 30);
                    break;
                }
                case 21:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 30);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    this.insertZombie(ZombieConst.GRIM, 30);
                    this.insertZombie(ZombieConst.ROCKET, 40);
                    break;
                }
                case 22:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 30);
                    this.insertZombie(ZombieConst.RIOT, 30);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    this.insertZombie(ZombieConst.GRIM, 30);
                    this.insertZombie(ZombieConst.ROCKET, 30);
                    this.insertZombie(ZombieConst.VIKING, 20);
                    break;
                }
                case 23:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 30);
                    this.insertZombie(ZombieConst.FRANK, 20);
                    this.insertZombie(ZombieConst.GUNNER, 40);
                    this.insertZombie(ZombieConst.RIOT, 30);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    this.insertZombie(ZombieConst.GRIM, 20);
                    this.insertZombie(ZombieConst.ROCKET, 30);
                    this.insertZombie(ZombieConst.VIKING, 30);
                    break;
                }
                case 24:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 20);
                    this.insertZombie(ZombieConst.BABY, 10);
                    this.insertZombie(ZombieConst.FRANK, 20);
                    this.insertZombie(ZombieConst.GUNNER, 40);
                    this.insertZombie(ZombieConst.RIOT, 30);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    this.insertZombie(ZombieConst.GRIM, 40);
                    this.insertZombie(ZombieConst.ROCKET, 30);
                    this.insertZombie(ZombieConst.VIKING, 20);
                    this.insertZombie(ZombieConst.KNIGHT, 30);
                    break;
                }
                case 25:
                {
                    this.insertZombie(ZombieConst.NORMAL, 10);
                    this.insertZombie(ZombieConst.PAN, 10);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 30);
                    this.insertZombie(ZombieConst.GUNNER, 20);
                    this.insertZombie(ZombieConst.RIOT, 40);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    this.insertZombie(ZombieConst.GRIM, 30);
                    this.insertZombie(ZombieConst.ROCKET, 20);
                    this.insertZombie(ZombieConst.VIKING, 30);
                    this.insertZombie(ZombieConst.KNIGHT, 30);
                    break;
                }
                default:
                {
                    this.insertZombie(ZombieConst.NORMAL, 20);
                    this.insertZombie(ZombieConst.PAN, 20);
                    this.insertZombie(ZombieConst.BABY, 20);
                    this.insertZombie(ZombieConst.FRANK, 40);
                    this.insertZombie(ZombieConst.GUNNER, 40);
                    this.insertZombie(ZombieConst.RIOT, 30);
                    this.insertZombie(ZombieConst.GRENADIER, 30);
                    this.insertZombie(ZombieConst.GRIM, 30);
                    this.insertZombie(ZombieConst.ROCKET, 20);
                    this.insertZombie(ZombieConst.VIKING, 20);
                    this.insertZombie(ZombieConst.KNIGHT, 30);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function insertZombie(param1:String, param2:int) : void
        {
            var _loc_3:int = 0;
            while (_loc_3 < param2)
            {
                
                this.zombieArray.push(param1);
                _loc_3++;
            }
            return;
        }// end function

        public function removeSelf() : void
        {
            var _loc_1:* = this.zombieArray.length - 1;
            while (_loc_1 >= 0)
            {
                
                this.zombieArray.splice(_loc_1, 1);
                _loc_1++;
            }
            this.zombieArray = null;
            return;
        }// end function

    }
}
