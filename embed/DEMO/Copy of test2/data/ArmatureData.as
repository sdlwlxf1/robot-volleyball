package test2.data 
{
	import test2.assets.Assets;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class ArmatureData extends EquipmentData 
	{
		protected static var xml:XML = Assets.getXML("Armature");
		
		public var armatureId:int;
		
		public var armatureName:String;
		
		public var armaturePath:String;
		
		public function ArmatureData(armatureID:int) 
		{
			super();
			armatureId = xml.Armature[armatureID].@id;
			armatureName = xml.Armature[armatureID].@name;
			armaturePath = xml.Armature[armatureID].@path;
		}
		
		
		
	}

}