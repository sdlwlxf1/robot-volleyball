package test2.state
{
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.CitrusSprite;
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
	import citrus.view.starlingview.StarlingArt;
	import citrus.view.starlingview.StarlingSpriteDebugArt;
	import citrus.view.starlingview.StarlingView;
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	import flash.events.MouseEvent;
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
	import test2.assets.ArmatureFactory;
	import test2.assets.Assets;
	import test2.assets.Fonts;
	import test2.assets.Particles;
	import test2.assets.Sounds;
	import test2.constants.ScreenConst;
	import test2.customObjects.Font;
	import test2.data.MapData;
	import test2.data.PlayerData;
	import test2.data.UserData;
	import test2.factory.PlayerFactory;
	import test2.gameObjects.Ball;
	import test2.gameObjects.Ground;
	import test2.gameObjects.Player;
	import test2.gameObjects.ViewObject;
	import test2.gameObjects.VirtualNet;
	import test2.gameObjects.Wall;
	import test2.logic.gameLogic.LevelController;
	import test2.logic.gameLogic.Match;
	import test2.logic.gameLogic.ScreenController;
	import test2.logic.Process;
	import test2.gameObjects.StaticObject;
	import test2.ui.Accumulator;
	import test2.ui.HUD;
	import test2.ui.PauseButton;
	import test2.ui.RewardBoard;
	import test2.ui.screen.GameOverScreen;
	import test2.ui.screen.GameWinScreen;
	import test2.ui.screen.MatchScreen;
	import test2.utils.ShakeAnimation;
	
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
	public class MatchState extends StarlingState
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
		private var _matchMessage:TextField;
		private var _pauseButton:PauseButton;
		private var _startButton:Button;
		private var match:Match;
		private var ball:Ball;
		private var hand1:ViewObject;
		private var hand2:ViewObject;
		private var hand3:ViewObject;
		private var hand4:ViewObject;
		private var _backButton:Button;
		private var _hud:HUD;
		private var _matchScreen:MatchScreen;
		
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

		
		public function MatchState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();		
			
			//初始化box2D
			var box2D:Box2D = new Box2D("box2D");
			//box2D.visible = true;
			add(box2D);
			
			if (ScreenController.gameMode == 1)
			{
				mapData = LevelController.getInstance().getCurLevelData().mapData;
			}
			else if((ScreenController.gameMode == 2))
			{
				mapData = ScreenController.getInstance().mapData;
			}
			
			var image:Image = new Image(Assets.getTexture(mapData.path));
			addChildAt(image, 0);
			image.width = stage.stageWidth;
			image.height = stage.stageHeight;
			
			
			_shakeAnimation = new ShakeAnimation(this, -1, 5);
			
			var netView:Image = new Image(Assets.getTexture(mapData.netpath));
			//netView.height = stage.stageHeight * 0.375;
			
			//墙壁
			add(new Ground("ground", {x: stage.stageWidth / 2, y: stage.stageHeight, width: stage.stageWidth, view: SpriteDebugArt}));
			add(new Platform("right", {x: 0 - 10, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			add(new Platform("left", {x: stage.stageWidth + 10, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			add(new Platform("net", { x: stage.stageWidth * 0.5, y: stage.stageHeight - netView.height / 2, width: 10 ,height: netView.height, view: netView } ));

			add(new Platform("serveBlockLeft", { x: 350, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt } ));
			add(new Platform("serveBlockRight", {x: stage.stageWidth - 350, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			
			add(new VirtualNet("virtualNet", {x: stage.stageWidth * 0.5, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			
			var playerFactory:PlayerFactory = new PlayerFactory();
			
			playerData1 = ScreenController.getInstance().playerData1;
			playerData2 = ScreenController.getInstance().playerData2;
			
			var factoryName:String = Assets.getXML("Armature").@factoryName;
			player1 = playerFactory.createPlayer(playerData1, ArmatureFactory.getStarlingFactory(factoryName));
			player2 = playerFactory.createPlayer(playerData2, ArmatureFactory.getStarlingFactory(factoryName));
			
			
			var ballMovieClip:MovieClip = new MovieClip(Assets.getMainAtlas().getTextures("ball_"), 30);
			ballMovieClip.blendMode = BlendMode.SCREEN;
			ballMovieClip.scaleX = 0.6;
			ballMovieClip.scaleY = 0.6;
			//ballMovieClip.pivotX = ballMovieClip.width >> 1;
			//ballMovieClip.pivotY = ballMovieClip.height >> 1;

			ball = new Ball("ball", { radius: ballMovieClip.height / 4, view:ballMovieClip} );
			add(ball);
	
			
			var fall1:MovieClip = new MovieClip(Assets.getMainAtlas().getTextures("fall1_"), 20);
			fall1.blendMode = BlendMode.SCREEN;
			fall1.pivotX = fall1.width >> 1;
			fall1.pivotY = fall1.height >> 1;
			fall1.loop = false;

			_particleFall1 = new CitrusSprite("particleFall1", { x:500, y:500, view:fall1 } );
			add(_particleFall1);
			
			_particleFire = new CitrusSprite("particleFire", {view:Particles.getParticle("fire")});
			add(_particleFire);
			
			_particleHeroair = new CitrusSprite("particleHeroair", { view:Particles.getParticle("heroair") } );
			add(_particleHeroair);
			
			_particleSmoke1 = new CitrusSprite("particleHeroair", { view:Particles.getParticle("smoke") } );
			add(_particleSmoke1);
			
			_particleSmoke2 = new CitrusSprite("particleHeroair", { view:Particles.getParticle("smoke") } );
			add(_particleSmoke2);
			
			_particleFireworks = new CitrusSprite("particleFireworks", { view:Particles.getParticle("fireworks") } );
			add(_particleFireworks);
			
			player1.hitBall = ball;
			player2.hitBall = ball;
			
			match = new Match(player1, player2, ball);
			
			player1.match = match;
			player2.match = match;
			
			match.onLose.add(onLose);
			match.onOver.add(onOver);
		
			matchScreen = new MatchScreen();
			stage.addChildAt(matchScreen, 1);
			
			_hud = matchScreen.hud;
			
			matchStart();
		}
		
		
		//比赛开始
		public function matchStart():void
		{
			match.onBegin.dispatch(Match.PLAYER_1);
		}
		
		//比赛回合结束
		private function onLose(playerId:uint, value:Number):void
		{
			if (playerId == Match.PLAYER_1)
			{
				_hud.setPlayer2Score(value);
			}
			else if (playerId == Match.PLAYER_2)
			{
				_hud.setPlayer1Score(value);
			}
		}
		//比赛结束
		private function onOver(playerId:uint):void
		{
			var fireworks:Boolean = false;
			
			if (playerId == Match.PLAYER_1)
			{
				if (ScreenController.gameMode == 1)
				{
					_hud.setMessage("你赢了");
					fireworks = true;
				}
				else if (ScreenController.gameMode == 2)
				{
					_hud.setMessage("player1Win");
					fireworks = true;
				}
				
				setTimeout(winReward, 3000);
				
			}
			else if (playerId == Match.PLAYER_2)
			{
				if (ScreenController.gameMode == 1)
				{
					_hud.setMessage("你输了");
				}
				else if (ScreenController.gameMode == 2)
				{
					_hud.setMessage("player2Win");
					fireworks = true;
				}
				
				setTimeout(loseReTry, 3000);
			}
			
			if (fireworks)
			{
				_particleFireworksSystem = ((view.getArt(_particleFireworks) as StarlingArt).content as PDParticleSystem);
				
				_particleFireworksSystem.start();
				_particleFireworksSystem.emitterX = stage.stageWidth >> 1;
				_particleFireworksSystem.emitterY = 0/*stage.stageHeight >> 1*/;
			}
		}
		
		private function loseReTry():void 
		{						
			if (ScreenController.gameMode == 1)
			{
				
				//LevelController.getInstance().goToLevel(0);
				var gameOverScreen:GameOverScreen = new GameOverScreen();
				matchScreen.addChild(gameOverScreen);
			}
			
		}
		
		private function winReward():void 
		{							
			if (ScreenController.gameMode == 1)
			{
				var rewardBoard:RewardBoard = new RewardBoard(LevelController.getInstance().getCurLevelData().rewardData);
				matchScreen.addChild(rewardBoard);
				
				rewardBoard.onOver.add(rewardBoardOver);
			}
		}
		
		private function rewardBoardOver():void 
		{
			if (LevelController.getInstance().curLevelID == LevelController.getInstance().endLevelID)
			{
				LevelController.getInstance().goToLevel(0);
				var gameWinScreen:GameWinScreen = new GameWinScreen();
				matchScreen.addChild(gameWinScreen);
			}
			else
			{
				LevelController.getInstance().goToNextLevel();
				ScreenController.getInstance().dispatchSignal(ScreenConst.MATCH_SCREEN, ScreenConst.REWARD_OVER, stage);
			}
			
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			_hud.update(player1, player2);
			
			match.update();
			
			_particleFireSystem = ((view.getArt(_particleFire) as StarlingArt).content as PDParticleSystem);
			_particleHeroairSystem = ((view.getArt(_particleHeroair) as StarlingArt).content as PDParticleSystem);
			//_particleSmoke1System = ((view.getArt(_particleSmoke1) as StarlingArt).content as PDParticleSystem);
			//_particleSmoke2System = ((view.getArt(_particleSmoke2) as StarlingArt).content as PDParticleSystem);
			
			
			_particleFireSystem.start();
			_particleFireSystem.emitterX = ball.x;
			_particleFireSystem.emitterY = ball.y;
			
			_particleFireSystem.emitAngle = ball.linearAngle.GetAngle();
			_particleFireSystem.speed = ball.linearAngle.Length() * 15;
			
			if (ball.linearAngle.Length() > 20)
			{
				_particleFireSystem.start();
			//fireParticle.maxNumParticles = int(_linearAngle.Length() * 20);
			}
			else
			{
				_particleFireSystem.stop();
			}
			
			
			_particleHeroairSystem.start();
			_particleHeroairSystem.emitterX = ball.x;
			_particleHeroairSystem.emitterY = ball.y;
			
			_particleHeroairSystem.emitAngle = ball.linearAngle.GetAngle();
			_particleHeroairSystem.speed = ball.linearAngle.Length() * 15;
			
			if (ball.linearAngle.Length() > 20)
			{
				_particleHeroairSystem.start();
			//fireParticle.maxNumParticles = int(_linearAngle.Length() * 20);
			}
			else
			{
				_particleHeroairSystem.stop();
			}
			
			/*_particleSmoke1System.start();
			_particleSmoke1System.emitterX = player1.x;
			_particleSmoke1System.emitterY = player1.y + player1.height / 2 - 10;*/
			
			//_particleSmoke1System.emitAngle = ball.linearAngle.GetAngle();
			//_particleSmoke1System.speed = ball.linearAngle.Length() * 15;
			
			/*_particleSmoke2System.start();
			_particleSmoke2System.emitterX = player2.x;
			_particleSmoke2System.emitterY = player2.y + player2.height / 2 - 10;*/
			
			//_particleSmoke2System.emitAngle = ball.linearAngle.GetAngle();
			//_particleSmoke2System.speed = ball.linearAngle.Length() * 15;
			
		}
		
		public function set matchScreen(value:MatchScreen):void 
		{
			_matchScreen = value;
			_hud = _matchScreen.hud;
		}
		
		public function get matchScreen():MatchScreen 
		{
			return _matchScreen;
		}
		
		public function get shakeAnimation():ShakeAnimation 
		{
			return _shakeAnimation;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			matchScreen.destroy();
		}
		
		
	
	}
}
