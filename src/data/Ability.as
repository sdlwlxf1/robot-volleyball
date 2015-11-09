package data 
{
	import Box2D.Collision.b2Bound;
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class Ability 
	{
		
		public var jump:Number = 0;
		
		public var move:Number = 0;
		
		public var quick:Number = 0;
		
		public var power:Number = 0;
		
		public function Ability(jump:Number = 0, move:Number = 0, quick:Number = 0, power:Number = 0) 
		{
			this.jump = jump;
			this.move = move;
			this.quick = quick;
			this.power = power;
		}
		
		public function clone():Ability
		{
			var ability:Ability = new Ability();
			ability.jump = jump;
			ability.move = move;
			ability.quick = quick;
			ability.power = power;
			return ability;
		}
		
		public function setAbility(ability:Ability):void
		{
			jump = ability.jump;
			move = ability.move;
			quick = ability.quick;
			power = ability.power;
		}
		
		public function toString():String
		{
			return "  jump: " + jump + ",  move: " + move + ",  quick: " + quick + ",  power: " + power;
		}
		
	}

}