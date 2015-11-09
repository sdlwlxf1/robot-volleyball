package 
{
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.input.controllers.Keyboard;
	import citrus.physics.PhysicsCollisionCategories;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import logics.gameLogic.TrainSmashBall;
	import starling.core.Starling;
	import constants.StageConst;
	import data.ArmData;
	import data.ShoulderMotorData;
	import data.UserData;
	import state.MatchState;
	import state.MenuState;
	import state.TrainMenuState;
	import state.TrainSmashBallState;
	import unit4399.events.RankListEvent;
	import unit4399.events.SaveEvent;
	import unit4399.events.RankListEvent;
	import unit4399.events.SaveEvent;
	
	//[SWF(width="1000", height="600", frameRate="60", backgroundColor="#030303")]
	
	/**
	 * @author Aymeric
	 */
	public class GameEngine extends StarlingCitrusEngine
	{	

		public function GameEngine()
		{
			super();		
			
			sound.addSound("background1", {sound:"sounds/background1.mp3"});		
			//sound.addSound("boost", "sounds/boost.mp3");
			//sound.addSound("boost2", "sounds/boost2.mp3");
			//sound.addSound("boost3", "sounds/boost3.mp3");
			sound.addSound("boost4", {sound:"sounds/boost4.mp3"});
			sound.addSound("hit_body", {sound:"sounds/hit_body.mp3"});
			//sound.addSound("hit_ground1", "sounds/hit_ground1.mp3");
			//sound.addSound("hit_ground2", "sounds/hit_ground2.mp3");
			sound.addSound("hit_ground3", {sound:"sounds/hit_ground3.mp3"});
			sound.addSound("hit_ground4", {sound:"sounds/hit_ground4.mp3"});
			sound.addSound("hit_net", {sound:"sounds/hit_net.mp3"});
			//sound.addSound("hit_net2", "sounds/hit_net2.mp3");
			//sound.addSound("hit_net3", "sounds/hit_net3.mp3");
			sound.addSound("hit1", {sound:"sounds/hit1.mp3"});
			sound.addSound("hit2", {sound:"sounds/hit2.mp3"});
			sound.addSound("hit3", {sound:"sounds/hit3.mp3"});
			//sound.addSound("jump", "sounds/jump.mp3");
			//sound.addSound("jump2", "sounds/jump2.mp3");
			//sound.addSound("menu_buttenreset", "sounds/menu_buttenreset.mp3");
			//sound.addSound("menu_buywepon", "sounds/menu_buywepon.mp3");
			sound.addSound("menu_click1", {sound:"sounds/menu_click1.mp3"});
			//sound.addSound("menu_click2", "sounds/menu_click2.mp3");
			sound.addSound("menu_doorclose1", {sound:"sounds/menu_doorclose1.mp3"});
			//sound.addSound("menu_doorclose2", "sounds/menu_doorclose2.mp3");
			sound.addSound("menu_entercompeteclose", {sound:"sounds/menu_entercompeteclose.mp3"});
			sound.addSound("menu_entercompeteopen", {sound:"sounds/menu_entercompeteopen.mp3"});
			//sound.addSound("menu_entersetting", "sounds/menu_entersetting.mp3");
			//sound.addSound("menu_entersetting2", "sounds/menu_entersetting2.mp3");
			//sound.addSound("menu_error", "sounds/menu_error.mp3");
			sound.addSound("menu_mousepass", {sound:"sounds/menu_mousepass.mp3"});
			sound.addSound("menu_short_doo", {sound:"sounds/menu_short_doo.mp3"});
			//sound.addSound("start1", "sounds/start1.mp3");
			sound.addSound("win1", {sound:"sounds/win1.mp3"});
			sound.addSound("win2", {sound:"sounds/win2.mp3"});
			
			sound.addSound("menu_down", {sound:"sounds/menu_down.mp3"});
			
			
			//Set up collision categories
			/*PhysicsCollisionCategories.Add("GoodGuys");
			PhysicsCollisionCategories.Add("BadGuys");
			PhysicsCollisionCategories.Add("Level");
			PhysicsCollisionCategories.Add("Items");*/
			
			PhysicsCollisionCategories.Add("DynamicObject");
			PhysicsCollisionCategories.Add("StaticObject");
			PhysicsCollisionCategories.Add("Player");
			PhysicsCollisionCategories.Add("PlayerHand");
			PhysicsCollisionCategories.Add("PlayerSensor");
			PhysicsCollisionCategories.Add("Wall");		
			PhysicsCollisionCategories.Add("Ground");
			PhysicsCollisionCategories.Add("Ball");
			PhysicsCollisionCategories.Add("Cannon");
			PhysicsCollisionCategories.Add("Gun");
			
			
		}
		
		private function _mouseWheel(e:MouseEvent):void 
		{
			//timeScale = e.delta > 0 ? timeScale + 0.03 : timeScale - 0.03;
		}
		
		override protected function handleAddedToStage(e:Event):void 
		{
			super.handleAddedToStage(e);
			//default arrow keys + space bar jump
			
			//trace(Starling.current.stage);
			stage.frameRate = 60;
			
			setUpStarling(true);			

			StageConst.setStarlingStage(Starling.current.stage);
			
			StageConst.setFlashStage(stage);
			
			StageConst.setCoreStage(Starling.current.stage);
			
			state = new TrainMenuState();
			
			_input.keyboard.addKeyAction("p1left", UserData.getInstance().p1KeySet["leftKey"]);
			_input.keyboard.addKeyAction("p1jump", UserData.getInstance().p1KeySet["jumpKey"]);
			_input.keyboard.addKeyAction("p1right", UserData.getInstance().p1KeySet["rightKey"]);
			_input.keyboard.addKeyAction("p1down", UserData.getInstance().p1KeySet["downKey"]);
			_input.keyboard.addKeyAction("p1specialHitBall", UserData.getInstance().p1KeySet["specialHitBallKey"]);
			_input.keyboard.addKeyAction("p1generalHitBall", UserData.getInstance().p1KeySet["generalHitBallKey"]);			
			_input.keyboard.addKeyAction("p1skill1", UserData.getInstance().p1KeySet["skill1Key"]);
		
			_input.keyboard.addKeyAction("p2left", UserData.getInstance().p2KeySet["leftKey"]);
			_input.keyboard.addKeyAction("p2jump", UserData.getInstance().p2KeySet["jumpKey"]);
			_input.keyboard.addKeyAction("p2right", UserData.getInstance().p2KeySet["rightKey"]);
			_input.keyboard.addKeyAction("p2down", UserData.getInstance().p2KeySet["downKey"]);
			_input.keyboard.addKeyAction("p2specialHitBall", UserData.getInstance().p2KeySet["specialHitBallKey"]);
			_input.keyboard.addKeyAction("p2generalHitBall", UserData.getInstance().p2KeySet["generalHitBallKey"]);			
			_input.keyboard.addKeyAction("p2skill1", UserData.getInstance().p2KeySet["skill1Key"]);
			
			
			_input.keyboard.addKeyAction("pause", Keyboard.Q);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheel);
		}
		
		
		
		override protected function handleEnterFrame(e:flash.events.Event):void 
		{
			super.handleEnterFrame(e);
		}
		
		/*override protected function _context3DCreated(evt:Event):void
		{
			super._context3DCreated(evt);
			_starling.stage.addChild(new Screen());
		}*/
	}
}