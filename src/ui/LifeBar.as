package ui 
{
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class LifeBar extends Sprite 
	{
		
		private var _lifeMax:Number;
		
		private var _life:Number = -1;
		
		private var _lifeMarks:Vector.<LifeMark>;
		
		private var _markGap:Number = 10;
		
		
		private var i:int;
		
		public function LifeBar() 
		{
			super();			
		}
		
		public function init(lifeMax:Number):void
		{
			_lifeMax = lifeMax;
			
			_lifeMarks = new Vector.<LifeMark>;
			
			i = 0;
			for (i = 0; i < _lifeMax; i++ )
			{
				var lifeMark:LifeMark = new LifeMark();
				lifeMark.x = i * lifeMark.width + i * _markGap + lifeMark.width / 2;
				lifeMark.y = lifeMark.height / 2;
				addChild(lifeMark);
				_lifeMarks[i] = lifeMark;
			}
			
			life = _lifeMax;
		}
		
		public function get life():Number 
		{
			return _life + 1;
		}
		
		public function set life(value:Number):void 
		{
			var newLife:Number = value - 1;
			
			
			if (newLife > _life)
			{
				if (newLife <= _lifeMax - 1)
				{
					for (i = _life + 1; i <= newLife; i++ )
					{
						_lifeMarks[i].setAlive();
					}
				}
			}
			else if (newLife < _life)
			{
				if (newLife >= -1)
				{
					for (i = _life; i > newLife; i-- )
					{
						_lifeMarks[i].setOver();
					}
				}
			}
			
			_life = newLife;
		}
		
		public function get lifeMax():Number 
		{
			return _lifeMax;
		}
		
	}

}