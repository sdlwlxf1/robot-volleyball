package src.data
{
    import flash.net.*;
    import org.osflash.signals.*;
    import src.constants.*;

    public class PlayerData extends Object
    {
        private var health:int = 20;
        private var money:int = 0;
        private var deadCount:int = 0;
        private var zombieKilled:int = 0;
        private var bossKilled:int = 0;
        private var gameCompleted:Boolean = false;
        public var onHealthChange:Signal;
        public var onHealthIncreased:Signal;
        public var onMoneyChange:Signal;
        public var onDead:Signal;
        private var sharedObject:SharedObject;
        private static var instance:PlayerData;

        public function PlayerData(param1:SingletonEnforcer)
        {
            this.onMoneyChange = new Signal();
            this.onHealthChange = new Signal();
            this.onHealthIncreased = new Signal();
            this.onDead = new Signal();
            this.sharedObject = SharedObject.getLocal("data");
            return;
        }// end function

        public function resetHealth() : void
        {
            this.health = this.getMaxHealth();
            return;
        }// end function

        public function saveData() : void
        {
            this.sharedObject.data.money = this.money;
            this.sharedObject.data.deadCount = this.deadCount;
            this.sharedObject.data.zombieKilled = this.zombieKilled;
            this.sharedObject.data.bossKilled = this.bossKilled;
            this.sharedObject.data.gameCompleted = this.gameCompleted;
            this.sharedObject.flush();
            return;
        }// end function

        public function loadData() : void
        {
            if (!this.sharedObject.data.hasOwnProperty("money"))
            {
                return;
            }
            this.money = this.sharedObject.data.money;
            this.deadCount = this.sharedObject.data.deadCount;
            this.zombieKilled = this.sharedObject.data.zombieKilled;
            this.bossKilled = this.sharedObject.data.bossKilled;
            this.gameCompleted = this.sharedObject.data.gameCompleted;
            return;
        }// end function

        public function resetData() : void
        {
            this.money = 0;
            this.deadCount = 0;
            this.zombieKilled = 0;
            this.bossKilled = 0;
            this.gameCompleted = false;
            this.saveData();
            return;
        }// end function

        public function increaseHealth(param1:int) : void
        {
            if (this.health + param1 > this.getMaxHealth())
            {
                this.health = this.getMaxHealth();
            }
            else
            {
                this.health = this.health + param1;
            }
            this.onHealthChange.dispatch();
            this.onHealthIncreased.dispatch();
            return;
        }// end function

        public function decreaseHealth(param1:int) : void
        {
            if (this.health - param1 <= 0)
            {
                this.health = 0;
                this.onDead.dispatch();
            }
            else
            {
                this.health = this.health - param1;
            }
            this.onHealthChange.dispatch();
            return;
        }// end function

        public function increaseMoney(param1:int) : void
        {
            this.money = this.money + param1;
            this.onMoneyChange.dispatch();
            return;
        }// end function

        public function decreaseMoney(param1:int) : void
        {
            if (this.money - param1 <= 0)
            {
                this.money = 0;
            }
            else
            {
                this.money = this.money - param1;
            }
            this.onMoneyChange.dispatch();
            return;
        }// end function

        public function increaseDeadCount() : void
        {
            (this.deadCount + 1);
            return;
        }// end function

        public function increaseZombieKilled() : void
        {
            (this.zombieKilled + 1);
            return;
        }// end function

        public function increaseBossKilled() : void
        {
            (this.bossKilled + 1);
            return;
        }// end function

        public function setGameCompleted() : void
        {
            this.gameCompleted = true;
            return;
        }// end function

        public function getHealth() : int
        {
            return this.health;
        }// end function

        public function getMaxHealth() : int
        {
            return GunConst["MAX_HEALTH_LEVEL_" + GunData.getInstance().getLevel(GunConst.MAX_HEALTH)];
        }// end function

        public function getMoney() : int
        {
            return this.money;
        }// end function

        public function getZombieKilled() : int
        {
            return this.zombieKilled;
        }// end function

        public function getBossKilled() : int
        {
            return this.bossKilled;
        }// end function

        public function getGameCompleted() : Boolean
        {
            return this.gameCompleted;
        }// end function

        public function getDeadCount() : int
        {
            return this.deadCount;
        }// end function

        public static function getInstance() : PlayerData
        {
            if (instance == null)
            {
                instance = new PlayerData(new SingletonEnforcer());
            }
            return instance;
        }// end function

    }
}
