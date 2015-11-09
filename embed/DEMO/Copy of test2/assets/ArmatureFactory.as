package test2.assets 
{
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class ArmatureFactory extends Object 
	{
		
		
		public static var armatureFactory:StarlingFactory;
		
		
		public function ArmatureFactory() 
		{
			super();
			
		}
		
		public static function getStarlingFactory(name:String):StarlingFactory
		{
			if (armatureFactory == null)
			{
				armatureFactory = new StarlingFactory();
				armatureFactory.parseData(Assets.getSWF(name));
				armatureFactory.addEventListener(Event.COMPLETE, _textureCompleteHandler);
			}
			return armatureFactory;
			
		}
		
		static private function _textureCompleteHandler(e:Event):void 
		{
			
		}
		
		public static function getArmature(factoryName:String, armatureName:String):Armature
		{
			return getStarlingFactory(factoryName).buildArmature(armatureName)
		}
		
		
	}

}