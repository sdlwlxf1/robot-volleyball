package test2.gameObjects 
{
	import citrus.physics.PhysicsCollisionCategories;
	/**
	 * ...
	 * @author ...
	 */
	public class VirtualNet extends Wall 
	{
		
		public function VirtualNet(name:String, params:Object=null) 
		{
			super(name, params);
			
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = _friction;
			_fixtureDef.density = 50;
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("StaticObject");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.Get("Player");
		}
		
	}

}