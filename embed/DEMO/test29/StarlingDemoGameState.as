package test29
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
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.particles.PDParticleSystem;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.Color;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.assets.Particles;
	import test2.assets.Sounds;
	import test2.customObjects.Font;
	import test2.logic.Process;
	import test2.ui.PauseButton;
	
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
		private var accumulator1:Accumulator;
		private var accumulator2:Accumulator;
		private var player1:Player;
		private var player2:Player;
		private var _armatureComplete:Boolean = false;
		private var _matchMessage:TextField;
		private var _pauseButton:PauseButton;
		private var _startButton:Button;
		private var match:Match;
		private var ball:Ball;
		
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
			_factory.addEventListener(flash.events.Event.COMPLETE, _textureCompleteHandler);
			
			//初始化box2D
			var box2D:Box2D = new Box2D("box2D");
			//box2D.visible = true;
			add(box2D);
			
			//墙壁
			add(new Ground("floor", {x: stage.stageWidth / 2, y: stage.stageHeight, width: stage.stageWidth, view: SpriteDebugArt}));
			add(new Wall("right", {x: 0 - 10, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			add(new Wall("left", {x: stage.stageWidth + 10, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			add(new Wall("net", {x: stage.stageWidth * 0.5, y: stage.stageHeight, height: 450, view: SpriteDebugArt}));
			
			
			var fontMessage:Font = Fonts.getFont("Arial");
			
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
			
			_matchMessage = new TextField(200, 100, "", fontMessage.fontName, 40, fontMessage.fontColor);
			_matchMessage.x = (stage.stageWidth - _matchMessage.width) / 2;
			_matchMessage.y = (stage.stageHeight - _matchMessage.height) / 2;
			addChild(_matchMessage);
			
			// Pause button.
			_pauseButton = new PauseButton();
			_pauseButton.x = _pauseButton.width * 2;
			_pauseButton.y = _pauseButton.height * 0.5;
			_pauseButton.addEventListener(Event.TRIGGERED, onPauseButtonClick);
			addChild(_pauseButton);
			
			// Start button.
			_startButton = new Button(Assets.getAtlas("Game").getTexture("startButton"));
			_startButton.fontColor = 0xffffff;
			_startButton.x = stage.stageWidth / 2 - _startButton.width / 2;
			_startButton.y = stage.stageHeight / 2 - _startButton.height / 2;
			_startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
			addChild(_startButton);
		
			//_player1Scores.visible = false;
		
		}
		
		private function onPauseButtonClick(e:Event):void
		{
			_ce.playing = _ce.playing ? false : true;
		}
		
		private function onStartButtonClick(e:Event):void
		{
			if (match)
			{
				match.onBegin.dispatch(Match.PLAYER_1);
				_startButton.removeEventListener(Event.TRIGGERED, onStartButtonClick);
				removeChild(_startButton);
				//remove(player1);
				//remove(player2);
			}
		}
		
		private function _textureCompleteHandler(e:flash.events.Event):void
		{
			_armatureComplete = true;
			
			_factory.removeEventListener(flash.events.Event.COMPLETE, _textureCompleteHandler);
			
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
			player1 = new Player("robot左", {x: 250, y: 480, width: (_armature.display as Sprite).width - 105, height: (_armature.display as Sprite).height, offsetY: -10, view: _armature, registration: "topLeft", invertedBody: false, control: "keyboard"});
			player1.animationName = {"walk": "run", "jump": "float", "idle": "stop", "hurt": "pushUp", "duck": "oneLegStand", "runMode": "run2", "hit": "hit", "jumpHit": "jumpHit", "ready": "ready", "squatHit": "squatHit", "squat": "squat", "readyThrow": "readyThrow", "throw": "throw", "backThrow": "backThrow", "waitHit": "waitHit"};
			player1.inputName = {"down": "s", "right": "d", "left": "a", "jump": "w", "hit": "q"};
			//inputName = { "down":"s", "right":"d", "left":"a", "down":"s", "hit":"space" };
			add(player1);
			
			player2 = new Player("robot右", {x: 750, y: 480, width: (_armature2.display as Sprite).width - 105, height: (_armature2.display as Sprite).height, offsetY: -10, view: _armature2, registration: "topLeft", invertedBody: true, control: "keyboard"});		
			player2.inputName = {"down": "down", "right": "right", "left": "left", "jump": "up", "hit": "m"};
			player2.animationName = {"walk": "run", "jump": "float", "idle": "stop", "hurt": "pushUp", "duck": "oneLegStand", "runMode": "run2", "hit": "hit", "jumpHit": "jumpHit", "ready": "ready", "squatHit": "squatHit", "squat": "squat", "readyThrow": "readyThrow", "throw": "throw", "backThrow": "backThrow", "waitHit": "waitHit"};
			add(player2);
			
			ball = new Ball("ball", { radius: 20, view:/*SpriteDebugArt*/ Assets.getTexture("Ball"), viewAutoSize: true } );
			add(ball);
			//view.getArt(ball)
			//trace(view.getArt(ball).width);
			
			//_ce.input.addController(new VirtualJoystick("joy"));
			
			player1.hitBall = ball;
			player2.hitBall = ball;
			
			match = new Match(player1, player2, ball);
			
			match.onLose.add(onLose);
			match.onOver.add(onOver);
			
			accumulator1 = new Accumulator();
			addChild(accumulator1);
			accumulator2 = new Accumulator();
			accumulator1.x = 50;
			accumulator1.y = 400;
			accumulator2.x = _ce.stage.stageWidth - 50;
			accumulator2.y = 400;
			addChild(accumulator2);
		
		}
		
		private function onOver(playerId:uint):void
		{
			if (playerId == Match.PLAYER_1)
			{
				_matchMessage.text = "player2 win";
			}
			else if (playerId == Match.PLAYER_2)
			{
				_matchMessage.text = "player1 win";
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			if (_armatureComplete == true)
			{
				accumulator1.update(player1.power, player1.powerMax);
				accumulator2.update(player2.power, player2.powerMax);
			}
		}
		
		private function onLose(playerId:uint, value:Number):void
		{
			if (playerId == Match.PLAYER_1)
			{
				_player2Scores.text = String(value);
			}
			else if (playerId == Match.PLAYER_2)
			{
				_player1Scores.text = String(value);
			}
		}
	
	}
}
