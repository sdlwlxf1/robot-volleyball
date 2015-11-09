package test2.data
{
	import test2.assets.Assets;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ArmData extends ArmatureData
	{
		
		//public static var armNum:int;
		
		public var power:Number;
		
		public var bone1:String;
		
		public var bone2:String;
		
		public var path2:String;
		
		public function ArmData(armatureID:int, armID:int)
		{
			super(armatureID);
			bone1 = xml.Armature[armatureID].Arms[0].@bone1;
			bone2 = xml.Armature[armatureID].Arms[0].@bone2;
			id = xml.Armature[armatureID].Arms[0].Arm[armID].@id;
			name = xml.Armature[armatureID].Arms[0].Arm[armID].@name;
			path = xml.Armature[armatureID].Arms[0].Arm[armID].@path;
			path2 = xml.Armature[armatureID].Arms[0].Arm[armID].@path2;
			power = xml.Armature[armatureID].Arms[0].Arm[armID].@power;
			price = xml.Armature[armatureID].Arms[0].Arm[armID].@price;
		
		}
		
		public static function getArms(armatureID:int):Vector.<EquipmentData>
		{
			var arms:Vector.<EquipmentData> = new Vector.<EquipmentData>;
			
			var i:int = 0;
			
			for each (var arm:XML in xml.Armature[armatureID].Arms.Arm)
			{
				arms[i] = new ArmData(armatureID, i);
				i++;
			}			
			return arms;	
		}
		
		public function toString():String
		{
			return "id:" + String(id) + ", name:" + name + ", path:" + path + ", power:" + String(power);
		}
	
	}

}