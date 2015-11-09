package factory
{
	import test2.data.LevelData;

    public class LevelFactory extends Object
    {
		private var _levelData:LevelData;

        public function LevelFactory()
        {
			
        }// end function
		
		public function createLevel(levelData:LevelData):void
		{
			_levelData = levelData;
			
		}

    }
}
