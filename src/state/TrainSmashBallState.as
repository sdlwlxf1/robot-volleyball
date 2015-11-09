package state
{
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.core.CitrusObject;
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.math.MathVector;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.CitrusSprite;
	import citrus.view.ACitrusCamera;
	import citrus.view.spriteview.SpriteDebugArt;
	import citrus.view.starlingview.StarlingArt;
	import citrus.view.starlingview.StarlingSpriteDebugArt;
	import citrus.view.starlingview.StarlingView;
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	import factory.ParticleFactory;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.particles.ParticleSystem;
	import starling.extensions.particles.PDParticleSystem;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.Color;
	import assets.ArmatureFactory;
	import assets.Assets;
	import assets.Fonts;
	import assets.Particles;
	import assets.Sounds;
	import constants.ScreenConst;
	import constants.StageConst;
	import customObjects.Font;
	import data.ArmatureData;
	import data.BallFlipData;
	import data.CannonData;
	import data.MapData;
	import data.PlayerData;
	import data.UserData;
	import factory.BallFactory;
	import factory.CannonFactory;
	import factory.PlayerFactory;
	import gameObjects.Ball;
	import gameObjects.Cannon;
	import gameObjects.Ground;
	import gameObjects.Player;
	import gameObjects.ViewObject;
	import gameObjects.VirtualNet;
	import gameObjects.Wall;
	import logics.gameLogic.Game;
	import logics.gameLogic.LevelController;
	import logics.gameLogic.Match;
	import logics.gameLogic.ScreenController;
	import logics.gameLogic.TrainLevelController;
	import logics.gameLogic.TrainScreenController;
	import logics.gameLogic.TrainSmashBall;
	import logics.Process;
	import gameObjects.StaticObject;
	import ui.Accumulator;
	import ui.Camera;
	import ui.GameOverBoard;
	import ui.PauseButton;
	import ui.RewardBoard;
	import ui.screen.GameOverScreen;
	import ui.screen.GameWinScreen;
	import ui.screen.MatchScreen;
	import ui.screen.TrainSmashBallScreen;
	import ui.SimpleWindows;
	import ui.TrainSmashBallHUD;
	import utils.ShakeAnimation;
	
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
	public class TrainSmashBallState extends StarlingState implements IShakeState
	{
		
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
		private var _pauseButton:PauseButton;
		private var _startButton:Button;
		private var match:Match;
		private var ball:Ball;
		private var hand1:ViewObject;
		private var hand2:ViewObject;
		private var hand3:ViewObject;
		private var hand4:ViewObject;
		private var _backButton:Button;
		private var _trainSmashBallScreen:TrainSmashBallScreen;
		
		public var playerData1:PlayerData;
		public var playerData2:PlayerData;
		public var mapData:MapData;
		
		private var _shakeAnimation:ShakeAnimation;
		private var _particleFire:CitrusSprite;

		private var _particleHeroair:CitrusSprite;
		private var _particleFireSystem:PDParticleSystem;
		private var _particleHeroairSystem:PDParticleSystem;
		private var _particleSmoke1:CitrusSprite;
		private var _particleSmoke1System:PDParticleSystem;
		private var _particleSmoke2:CitrusSprite;
		private var _particleSmoke2System:PDParticleSystem;
		private var _particleHit1:CitrusSprite;
		private var _particleHandHit1:CitrusSprite;
		private var _particleHit2:CitrusSprite;
		private var _particleHandHit2:CitrusSprite;
		private var _particleFall1:CitrusSprite;
		private var _particleFireworks:CitrusSprite;
		private var _particleFireworksSystem:PDParticleSystem;
		
		
		private var ballMovieClip:MovieClip;
		private var _background:CitrusSprite;
		private var _overSkyImage:Image;
		private var updateDelayCount:int = 0;
		private var updateDelayMax:int = 1;
		private var game:Game;
		private var ballImage:Image;
		private var _hud:TrainSmashBallHUD;
		
		
		public var trainSmashBall:TrainSmashBall;
		
		
		private var cannon:Cannon;
		private var ballFactory:BallFactory;
		private var overlay:CitrusSprite;
		private var overlayQuadBlue:Quad;
		private var overlayQuadYellow:Quad;
		


		
		public function TrainSmashBallState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();		
			
			//初始化box2D
			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			
			
			
			//**********************************************
			//地图初始化

			mapData = TrainLevelController.getInstance().getCurLevelData().mapData;
			
			var image:Image = new Image(Assets.getTexture(mapData.path));
			image.width = stage.stageWidth;
			image.height = stage.stageHeight;
			
			_background = new CitrusSprite("backGround", {view:image} );
			add(_background);
			
			
			/*if (!_ce.sound.soundIsPlaying("background1"))
			{*/
			//_ce.sound.playSound("background1");
			/*}*/

			
			//屏幕震动动画
			_shakeAnimation = new ShakeAnimation((view as StarlingView).viewRoot, -1.2, 6);
			
			//网
			var netView:Image = new Image(Assets.getTexture(mapData.netpath));
			netView.scaleY = stage.stageHeight / 2.35 / netView.height;
			netView.scaleX = netView.scaleY;
			
			//墙壁
			add(new Ground("ground", { x: stage.stageWidth / 2, y: stage.stageHeight, width: stage.stageWidth, height: 40,  view: SpriteDebugArt } ));
			
			//左墙
			add(new Platform("rightWall", { x: 0 - 10, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt } ));
			
			//右墙
			add(new Platform("leftWall", { x: stage.stageWidth + 10, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt } ));
			
			
			
			//发球虚拟障碍
			//add(new Platform("serveBlockLeft", { x: 320, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt } ));
			//add(new Platform("serveBlockRight", {x: stage.stageWidth - 320, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			
			//虚拟网
			add(new VirtualNet("virtualNet", {x: stage.stageWidth * 0.5, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			
			
			
			
			//game = new Game();
			trainSmashBall = new TrainSmashBall();
			
			//************************************************************
			
			//**********************************************
			
			//玩家初始化
			var playerFactory:PlayerFactory = new PlayerFactory();
			
			playerData1 = TrainScreenController.getInstance().playerData1;
			
			var factoryName:String = Assets.getXML("Armature").@factoryName;			
			
			//网
			add(new Platform("net", {x: StageConst.stageWidth * 0.5, y: StageConst.stageHeight - netView.height / 2 + 15, offsetY: -15 ,width: 10 ,height: netView.height, view: netView } ));
			
			player1 = playerFactory.createPlayer(playerData1, ArmatureFactory.getStarlingFactory(factoryName));
			
			var cannonData:CannonData = TrainLevelController.getInstance().getCurLevelData().cannonData;
	
			var cannonFactory:CannonFactory = new CannonFactory();
			
			
			cannon = cannonFactory.createCannon(cannonData, ArmatureFactory.getStarlingFactory(factoryName));
			cannon.train = trainSmashBall;
			
			
			
			
			_particleFireworks = new CitrusSprite("particleFireworks", { view:Particles.getParticle("fireworks") } );
			add(_particleFireworks);
			//***********************************************
			
			// the overlay will be above everything thanks to the grou property
			/*overlay = new CitrusSprite("overlay", {parallaxX:0,parallaxY:0, group:1});
			overlayQuadBlue = new Quad(stage.stageWidth*2, stage.stageHeight*2, 0xff0000);
			overlayQuadYellow = new Quad(stage.stageWidth * 2, stage.stageHeight * 2, 0xFFFF00);
			overlayQuadBlue.blendMode = BlendMode.ADD;
			overlayQuadYellow.blendMode = BlendMode.ADD;
			add(overlay);
			
			overlay.view = overlayQuadBlue;*/

			
			
			//摄像机初始化
			view.camera.setUp(player1.camTarget,new Rectangle(0, 0, 800, 500), new Point(.25, .25));
			
			view.camera.allowZoom = true;
			
			//游戏比赛界面（HUD）
			trainSmashBallScreen = new TrainSmashBallScreen();
			trainSmashBallScreen.trainSmashBallState = this;
			addChildAt(trainSmashBallScreen, 1);
			
			_hud = trainSmashBallScreen.hud;
			_hud.lifeBar.init(trainSmashBall.life);
		
			trainSmashBall.hud = _hud;
			_hud.timeCountBoard.onComplete.add(trainSmashBall.timeCountOnComplete);
			
			trainStart();	
			
			
			
		}
		
		private function trainStart():void 
		{
			
			trainSmashBall.setCharacter(player1, cannon);
			trainSmashBall.onBegin.add(trainBegin);
			trainSmashBall.onPass.add(trainPass);
			trainSmashBall.onOver.add(trainOver);
			removeAllBall();
			
			setTimeout(trainSmashBall.trainBegin, 2000);
		}
		
		
		
		
		public function removeAllBall():void
		{
			var balls:Vector.<CitrusObject> = getObjectsByType(Ball);
			for each(var citrusObject:CitrusObject in balls)
			{
				remove(citrusObject);
			}
			
			var particles:Vector.<CitrusObject> = getObjectsByName(ParticleFactory.EXPLODE_1);
			for each(citrusObject in particles)
			{
				remove(citrusObject);
			}
			
			particles = getObjectsByName(ParticleFactory.EXPLODE_1);
			for each(citrusObject in particles)
			{
				remove(citrusObject);
			}
			
			particles = getObjectsByName(ParticleFactory.EXPLODE_2);
			for each(citrusObject in particles)
			{
				remove(citrusObject);
			}
			
			particles = getObjectsByName(ParticleFactory.HIT_1);
			for each(citrusObject in particles)
			{
				remove(citrusObject);
			}
			
			particles = getObjectsByName(ParticleFactory.FALL_1);
			for each(citrusObject in particles)
			{
				remove(citrusObject);
			}
			
			particles = getObjectsByName(Particles.FIRE);
			for each(citrusObject in particles)
			{
				remove(citrusObject);
			}
		}
		
		
		private function trainBegin():void 
		{
			(_particleFireworks.view as PDParticleSystem).stop();
		}
		
		
		private function trainPass():void 
		{
			_hud.setCelebrateImage(trainSmashBallScreen.trainPassBoardAdd);

			setTimeout(houl, 700);
			
			function houl():void
			{
				_ce.sound.playSound("win2");
				
				_particleFireworksSystem = ((view.getArt(_particleFireworks) as StarlingArt).content as PDParticleSystem);
			
				_particleFireworksSystem.start();
				_particleFireworksSystem.emitterX = stage.stageWidth >> 1;
				_particleFireworksSystem.emitterY = 0/*stage.stageHeight >> 1*/;
			}		

		}
		
		private function trainOver():void 
		{
			trainSmashBallScreen.trainOverBoardAdd();
		}
		
		private function loseReTry():void 
		{						
			if (ScreenController.gameMode == 1)
			{
				
				//LevelController.getInstance().goToLevel(0);
				var gameOverScreen:GameOverScreen = new GameOverScreen();
				trainSmashBallScreen.addChild(gameOverScreen);
			}
			
		}
		
		public function anotherGame():void 
		{	
			cannon.isFiring = false;
			trainStart();
		}
		
		
		
		override public function update(timeDelta:Number):void
		{
			
			super.update(timeDelta);
			
			_trainSmashBallScreen.update();
			
			trainSmashBall.update();
			
		}
		
		public function set trainSmashBallScreen(value:TrainSmashBallScreen):void 
		{
			_trainSmashBallScreen = value;
			_hud = _trainSmashBallScreen.hud;
		}
		
		public function get trainSmashBallScreen():TrainSmashBallScreen 
		{
			return _trainSmashBallScreen;
		}
		
		public function get shakeAnimation():ShakeAnimation 
		{
			return _shakeAnimation;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			trainSmashBallScreen.destroy();
					
			if (_ce.sound.soundIsPlaying("background1"))
			{
				_ce.sound.stopSound("background1");
			}
						
		}
		
		
	
	}
}
