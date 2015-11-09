package test2
{
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.platformer.box2d.Cannon;
	import citrus.objects.platformer.box2d.Crate;
	import citrus.objects.platformer.box2d.Hills;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.objects.platformer.box2d.MovingPlatform;
	import citrus.objects.platformer.box2d.RevolvingPlatform;
	import citrus.objects.platformer.box2d.Reward;
	import citrus.objects.platformer.box2d.RewardBox;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.objects.platformer.box2d.Teleporter;
	import citrus.objects.platformer.box2d.Treadmill;
	import citrus.view.spriteview.SpriteDebugArt;
	import citrus.view.starlingview.StarlingSpriteDebugArt;
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.Color;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.assets.ParticleAssets;
	import test2.assets.Sounds;
	import test2.customObjects.Font;
	import test2.logic.Process;
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import flash.display.Bitmap;
	
	/**
	 * @author Aymeric
	 */
	public class StarlingDemoGameState extends StarlingState
	{		
		private var _ce:CitrusEngine;
		
		private var _factory:StarlingFactory;
		private var _armature:Armature;
		private var _player1Scores:TextField;
		private var _player2Scores:TextField;
		private var _colon:TextField;
		
		public function StarlingDemoGameState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();			
			_ce = CitrusEngine.getInstance();
			
			//图片数据处理
			_factory = new StarlingFactory();
			_factory.parseData(Assets.getSWF("Robot"));
			_factory.addEventListener(Event.COMPLETE, _textureCompleteHandler);
			
			//初始化box2D
			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			
			//墙壁
			add(new Ground("floor", { x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth, view:SpriteDebugArt } ));
			add(new Wall("right", {x:0 - 10, y:stage.stageHeight / 2, height:stage.stageHeight, view:SpriteDebugArt}));
			add(new Wall("left", { x:stage.stageWidth +10, y:stage.stageHeight / 2, height:stage.stageHeight, view:SpriteDebugArt } ));
			add(new Wall("net", { x:stage.stageWidth * 0.5, y:stage.stageHeight, height:450, view:SpriteDebugArt } ));
			
			var ball:Ball = new Ball("ball", { radius:20, view:Assets.getTexture("Ball"), viewAutoSize:true } );
			add(ball);
			//view.getArt(ball)
			//trace(view.getArt(ball).width);
			
			//_ce.input.addController(new VirtualJoystick("joy"));
			var fontMessage:Font = Fonts.getFont("ScoreValue");
			
			_player1Scores = new TextField(80, 80, "0", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_player1Scores.x = (stage.stageWidth - _player1Scores.width) / 2 - 60;
			_player1Scores.y = 0;
			addChild(_player1Scores);
			
			_colon = new TextField(80, 80, "VS", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_colon.x = (stage.stageWidth - _colon.width) / 2;
			_colon.y = 0;
			addChild(_colon);
			
			_player2Scores = new TextField(80, 80, "0", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_player2Scores.x = (stage.stageWidth - _player2Scores.width) / 2 + 60;
			_player2Scores.y = 0;
			addChild(_player2Scores);
			
			
			//_player1Scores.visible = false;
		
		}
		
		
		private function _textureCompleteHandler(e:Event):void 
		{
			_factory.removeEventListener(Event.COMPLETE, _textureCompleteHandler);

			_armature = _factory.buildArmature("robot");

			(_armature.display as Sprite).scaleY = 0.5;
			// the character is build on the left
			(_armature.display as Sprite).scaleX = 0.5;
			//_armature.animation.timeScale = 0.5;
			
			var _armature2:Armature = _factory.buildArmature("robot");

			(_armature2.display as Sprite).scaleY = 0.5;
			// the character is build on the left
			(_armature2.display as Sprite).scaleX = 0.5;
			//_armature.animation.timeScale = 0.5;

			
			//初始化主角
			var robot:Player = new Player("robot左", {x:250, y:480, width:(_armature.display as Sprite).width - 60, height:(_armature.display as Sprite).height/* - 20*/, offsetY:-10, view:_armature, registration:"topLeft", invertedBody:false, control:"keyboard1"});
			robot.animationName = { "walk":"run", "jump":"float", "idle":"stop", "hurt":"pushUp", "duck":"oneLegStand", "runMode":"run2", "hit":"hit", "jumpHit":"jumpHit", "ready":"ready", "squatHit":"squatHit", "squat":"squat", "readyThrow":"readyThrow", "throw":"throw", "backThrow":"backThrow", "waitHit":"waitHit" };
			add(robot);
			
			var robot2:Player = new Player("robot右", {x:750, y:480, width:(_armature2.display as Sprite).width - 60, height:(_armature2.display as Sprite).height/*  - 20*/, offsetY:-10, view:_armature2, registration:"topLeft", invertedBody:true, control:"auto"});
			robot2.animationName = { "walk":"run", "jump":"float", "idle":"stop", "hurt":"pushUp", "duck":"oneLegStand", "runMode":"run2" , "hit":"hit", "jumpHit":"jumpHit", "ready":"ready", "squatHit":"squatHit" , "squat":"squat", "readyThrow":"readyThrow", "throw":"throw", "backThrow":"backThrow", "waitHit":"waitHit" };
			add(robot2);

			robot.opponent = robot2;
			robot2.opponent = robot;
			robot.onLose.add(robot1Lose);
			robot2.onLose.add(robot2Lose);
			robot.hitBall = getObjectByName("ball") as Ball;
			robot2.hitBall = getObjectByName("ball") as Ball;
			robot.getStateByName("matchBegin").phase = Process.BEGIN;
			//robot.getStateByName("youTurn").phase = Process.BEGIN;
			//robot2.getStateByName("youTurn").phase = Process.END;
		
		}
		
		private function robot2Lose():void 
		{
			var i:int = int(_player1Scores.text);
			_player1Scores.text = String(++i);
		}
		
		private function robot1Lose():void 
		{
			var i:int = int(_player2Scores.text);
			_player2Scores.text = String(++i);
		}
		
		
		
		private function heroHurt():void
		{
			_ce.sound.playSound("Hurt", 1, 0);
		}
		
		private function heroAttack():void
		{
			_ce.sound.playSound("Kill", 1, 0);
		}
	
	}
}
