package test2.data 
{
	import Box2D.Common.Math.b2Vec2;
	import test2.assets.Assets;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class ShoulderMotorData extends ArmatureData 
	{
		public var bone:String;
		
		public var moveBoosting:Number;
		
		public function ShoulderMotorData(armatureID:int, shoulderMotorID:int) 
		{
			super(armatureID);	
			bone = xml.Armature[armatureID].ShoulderMotors[0].@bone;
			id = xml.Armature[armatureID].ShoulderMotors[0].ShoulderMotor[shoulderMotorID].@id;
			name = xml.Armature[armatureID].ShoulderMotors[0].ShoulderMotor[shoulderMotorID].@name;
			path = xml.Armature[armatureID].ShoulderMotors[0].ShoulderMotor[shoulderMotorID].@path;
			moveBoosting = xml.Armature[armatureID].ShoulderMotors[0].ShoulderMotor[shoulderMotorID].@moveBoosting;
			price = xml.Armature[armatureID].ShoulderMotors[0].ShoulderMotor[shoulderMotorID].@price;
		}
		
		public static function getShoulderMotors(armatureID:int):Vector.<EquipmentData>
		{
			var shoulderMotors:Vector.<EquipmentData> = new Vector.<EquipmentData>;
			
			var i:int = 0;
			
			for each (var waistMotor:XML in xml.Armature[armatureID].ShoulderMotors.ShoulderMotor)
			{
				shoulderMotors[i] = new ShoulderMotorData(armatureID, i);
				i++;
			}			
			return shoulderMotors;	
		}
		
		public function toString():String
		{
			return "id:"+ String(id) + ", name:" + name + ", path:" + path + ", moveBoosting:" + String(moveBoosting);
		}
		
	}

}