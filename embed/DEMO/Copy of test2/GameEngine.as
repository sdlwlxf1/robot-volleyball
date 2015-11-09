package test2
{
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.input.controllers.Keyboard;
	import citrus.physics.PhysicsCollisionCategories;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import test2.data.ArmData;
	import test2.data.ShoulderMotorData;
	import test2.data.UserData;
	import test2.logic.gameLogic.ScreenController;
	import test2.state.MatchState;
	import test2.state.MenuState;
	
	//[SWF(width="1000", height="600", frameRate="60", backgroundColor="#030303")]
	
	/**
	 * @author Aymeric
	 */
	public class GameEngine extends StarlingCitrusEngine
	{	
		public function GameEngine()
		{
			super();		
			
			sound.addSound("Hurt", "sounds/hurt.mp3");
			sound.addSound("Kill", "sounds/kill.mp3");
			
			//Set up collision categories
			PhysicsCollisionCategories.Add("GoodGuys");
			PhysicsCollisionCategories.Add("BadGuys");
			PhysicsCollisionCategories.Add("Level");
			PhysicsCollisionCategories.Add("Items");
			
			PhysicsCollisionCategories.Add("DynamicObject");
			PhysicsCollisionCategories.Add("StaticObject");
			PhysicsCollisionCategories.Add("Player");
			PhysicsCollisionCategories.Add("PlayerHand");
			PhysicsCollisionCategories.Add("PlayerSensor");
			PhysicsCollisionCategories.Add("PlayerSensor2");
			PhysicsCollisionCategories.Add("Wall");		
			PhysicsCollisionCategories.Add("Ground");
			PhysicsCollisionCategories.Add("Ball");
			
			
		}
		
		override protected function handleAddedToStage(e:Event):void 
		{
			super.handleAddedToStage(e);
			//default arrow keys + space bar jump
			
			setUpStarling(false);
			
			
			state = new MenuState();
			
			_input.keyboard.addKeyAction("p1left", UserData.getInstance().p1KeySet["leftKey"]);
			_input.keyboard.addKeyAction("p1jump", UserData.getInstance().p1KeySet["jumpKey"]);
			_input.keyboard.addKeyAction("p1right", UserData.getInstance().p1KeySet["rightKey"]);
			_input.keyboard.addKeyAction("p1hit", UserData.getInstance().p1KeySet["hitKey"]);
			
			_input.keyboard.addKeyAction("p2left", UserData.getInstance().p2KeySet["leftKey"]);
			_input.keyboard.addKeyAction("p2jump", UserData.getInstance().p2KeySet["jumpKey"]);
			_input.keyboard.addKeyAction("p2right", UserData.getInstance().p2KeySet["rightKey"]);
			_input.keyboard.addKeyAction("p2hit", UserData.getInstance().p2KeySet["hitKey"]);
			
			
		}
		
		/*override protected function _context3DCreated(evt:Event):void
		{
			super._context3DCreated(evt);
			_starling.stage.addChild(new Screen());
		}*/
	}
}