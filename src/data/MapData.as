package data 
{
	import assets.Assets;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class MapData extends EquipmentData 
	{				
		protected static var xml:XML = Assets.getXML("Map");
	
		public var netpath:String;
		
		public var ballType:uint;
		
		public function MapData(mapID:int) 
		{
			super();
			id = xml.Map[mapID].@id;
			name = xml.Map[mapID].@name;
			path = xml.Map[mapID].@path;
			netpath = xml.Map[mapID].@netpath;
		}
		
		
		public function toString():String
		{
			return "id:"+ String(id) + ", name:" + name + ", path:" + path;
		}
		
		public static function getMaps():Vector.<EquipmentData>
		{
			var maps:Vector.<EquipmentData> = new Vector.<EquipmentData>;
			
			var i:int = 0;
			
			for each (var map:XML in xml.Map)
			{
				maps[i] = new MapData(i);
				i++;
			}			
			return maps;	
		}
		
	}

}