package data
{

    public class LevelData extends Data
    {
        public var levelID:int = 0;
		
		public var opponentData:PlayerData;
		
		public var cannonData:CannonData;
		
		public var mapData:MapData;
		
		public var rewardData:RewardData;

        public function LevelData()
        {
            super();
        }

    }
}
