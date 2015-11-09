package data 
{
	import assets.Assets;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class WaistMotorData extends ArmatureData 
	{
		
		public var jumpBoosting:Number;
		
		public var bone1:String;
		
		public var bone2:String;
		
		public var path2:String;
		
		public function WaistMotorData(armatureID:int, waistMotorID:int)
		{
			super(armatureID);			
			bone1 = xml.Armature[armatureID].WaistMotors[0].@bone1;
			bone2 = xml.Armature[armatureID].WaistMotors[0].@bone2;
			id = xml.Armature[armatureID].WaistMotors[0].WaistMotor[waistMotorID].@id;
			name = xml.Armature[armatureID].WaistMotors[0].WaistMotor[waistMotorID].@name;
			path = xml.Armature[armatureID].WaistMotors[0].WaistMotor[waistMotorID].@path;
			path2 = xml.Armature[armatureID].WaistMotors[0].WaistMotor[waistMotorID].@path2;
			jumpBoosting = xml.Armature[armatureID].WaistMotors[0].WaistMotor[waistMotorID].@jumpBoosting;
			price = xml.Armature[armatureID].WaistMotors[0].WaistMotor[waistMotorID].@price;
		}
		
		
		public static function getWaistMotors(armatureID:int):Vector.<EquipmentData>
		{
			var waistMotors:Vector.<EquipmentData> = new Vector.<EquipmentData>;
			
			var i:int = 0;
			
			for each (var waistMotor:XML in xml.Armature[armatureID].WaistMotors.WaistMotor)
			{
				waistMotors[i] = new WaistMotorData(armatureID, i);
				i++;
			}			
			return waistMotors;	
		}
		
		public function toString():String
		{
			return "id:"+ String(id) + ", name:" + name + ", path:" + path + ", jumpBoosting:" + String(jumpBoosting);
		}
		
	}

}