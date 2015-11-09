package src.data
{
    import flash.net.*;

    public class LevelData extends Object
    {
        private var level:int = 1;
        private var sharedObject:SharedObject;
        public static var instance:LevelData;

        public function LevelData(param1:SingletonEnforcer)
        {
            this.sharedObject = SharedObject.getLocal("data");
            return;
        }// end function

        public function resetData() : void
        {
            this.level = 1;
            this.saveData();
            return;
        }// end function

        public function saveData() : void
        {
            this.sharedObject.data.level = this.level;
            this.sharedObject.flush();
            return;
        }// end function

        public function loadData() : void
        {
            if (!this.sharedObject.data.hasOwnProperty("level"))
            {
                return;
            }
            this.level = this.sharedObject.data.level;
            return;
        }// end function

        public function increaseLevel() : void
        {
            (this.level + 1);
            return;
        }// end function

        public function getLevel() : int
        {
            return this.level;
        }// end function

        public static function getInstance() : LevelData
        {
            if (instance == null)
            {
                instance = new LevelData(new SingletonEnforcer());
            }
            return instance;
        }// end function

    }
}
