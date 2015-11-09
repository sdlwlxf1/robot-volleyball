package test2.data 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.net.SharedObject;
	import test2.data.Data;
	import test2.math.MathVector;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerData extends Data 
	{
		public var name:String;
		
		public var control:String = "keyboard";
		public var invertedViewAndBody:Boolean = false;
		
		public var velocityVec:b2Vec2 = new b2Vec2(1.2, 0);
		private var _maxVelocity:Number = 3;
		private var _minVelocity:Number = 1.2;
				
		public var jumpHeight:Number = 8;
		private var _maxJumpHeight:Number = 15;
		private var _minJumpHeight:Number = 8;
		
		public var jumpAcceleration:Number = 0.3;
		
		public var serveBallVec:b2Vec2 = new b2Vec2(0, -5);
		
		public var powerMax:Number = 5;
		private var _maxPowerMax:Number = 13;
		private var _minPowerMax:Number = 3;
		
		
		public var powerA:Number = 0.1;
		
		public var timeScale:Number = 1;
		private var _maxTimeScale:Number = 1.5;
		private var _minTimeScale:Number = 1;
		
		public var inputName:Object;
		public var animationName:Object;
		
		public var scale:Number = 0.25;
		
		public var startX:Number = 100;
		public var startY:Number = 300;
		

		
		public var ability:Ability;
		
		public var armatureData:ArmatureData;
		
		public var equipAbility:Ability;		
		public var equipArmData:ArmData;
		public var equipWaistMotorData:WaistMotorData;
		public var equipShoulderMotorData:ShoulderMotorData;
		
		public var canAutoJump:Boolean = true;
		
		public function PlayerData() 
		{
			super();
			initUserData();
		}
		
		private function initUserData():void 
		{
			name = UserData.getInstance().name;
			ability = UserData.getInstance().ability.clone();
			equipAbility = ability.clone();
		}
		
		public function setArm(armData:ArmData):void
		{
			equipArmData = armData;
			equipAbility.power = ability.power;
			equipAbility.power += armData.power;
			//handTextureName = armData.
		}
		
		public function setWaistMotor(waistMotorData:WaistMotorData):void
		{
			equipWaistMotorData = waistMotorData;
			equipAbility.jump = ability.jump;
			equipAbility.jump += waistMotorData.jumpBoosting;
		}
		
		public function setShoulderMotor(shoulderMotorData:ShoulderMotorData):void
		{
			equipShoulderMotorData = shoulderMotorData;
			equipAbility.move = ability.move;
			equipAbility.move += shoulderMotorData.moveBoosting;
		}
		
		public function dataByAbility():void
		{
			velocityVec.x = _minVelocity + equipAbility.move * 0.1 * (_maxVelocity - _minVelocity);
			timeScale = _minTimeScale + equipAbility.move * 0.1 * (_maxTimeScale - _minTimeScale);
			jumpHeight = _minJumpHeight + equipAbility.jump * 0.1 * (_maxJumpHeight - _minJumpHeight);
			powerMax = _minPowerMax + equipAbility.power * 0.1 * (_maxPowerMax - _minPowerMax);
		}
		
	}

}