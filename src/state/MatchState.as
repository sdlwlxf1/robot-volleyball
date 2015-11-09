package state
{
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.core.CitrusObject;
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.math.MathVector;
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
	import citrus.view.ACitrusCamera;
	import citrus.view.spriteview.SpriteDebugArt;
	import citrus.view.starlingview.StarlingArt;
	import citrus.view.starlingview.StarlingSpriteDebugArt;
	import citrus.view.starlingview.StarlingView;
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
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
	import customObjects.Font;
	import data.MapData;
	import data.PlayerData;
	import data.UserData;
	import factory.PlayerFactory;
	import gameObjects.Ball;
	import gameObjects.Ground;
	import gameObjects.Player;
	import gameObjects.ViewObject;
	import gameObjects.VirtualNet;
	import gameObjects.Wall;
	import logics.gameLogic.Game;
	import logics.gameLogic.LevelController;
	import logics.gameLogic.Match;
	import logics.gameLogic.ScreenController;
	import logics.Process;
	import gameObjects.StaticObject;
	import ui.Accumulator;
	import ui.Camera;
	import ui.GameOverBoard;
	import ui.MatchHUD;
	import ui.PauseButton;
	import ui.RewardBoard;
	import ui.screen.GameOverScreen;
	import ui.screen.GameWinScreen;
	import ui.screen.MatchScreen;
	import ui.SimpleWindows;
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
	public class MatchState extends StarlingState implements IShakeState
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
		
		
		private var ballMovieClip:MovieClip;
		private var _background:CitrusSprite;
		private var _overSkyImage:Image;
		private var updateDelayCount:int = 0;
		private var updateDelayMax:int = 1;
		private var game:Game;
		private var ballImage:Image;
		private var _hud:MatchHUD;
		


		
		public function MatchState()
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
			if (ScreenController.gameMode == 1)
			{
				mapData = LevelController.getInstance().getCurLevelData().mapData;
			}
			else if((ScreenController.gameMode == 2))
			{
				mapData = ScreenController.getInstance().mapData;
			}
			
			var image:Image = new Image(Assets.getTexture(mapData.path));
			image.width = stage.stageWidth;
			image.height = stage.stageHeight;
			
			_background = new CitrusSprite("backGround", {view:image} );
			add(_background);
			
			
			
			if (mapData.id < 2)
			{			
				if (!_ce.sound.soundIsPlaying("background1"))
				{
					_ce.sound.playSound("background1");
				}
			}
			else
			{
				if (!_ce.sound.soundIsPlaying("background2"))
				{
					_ce.sound.playSound("background2");
				}
			}
			
			//屏幕震动动画
			_shakeAnimation = new ShakeAnimation(this, -1.2, 6);
			
			//网
			var netView:Image = new Image(Assets.getTexture(mapData.netpath));
			netView.scaleY = stage.stageHeight / 2.4 / netView.height;
			netView.scaleX = netView.scaleY;
			
			//墙壁
			add(new Ground("ground", { x: stage.stageWidth / 2, y: stage.stageHeight, width: stage.stageWidth, height: 40,  view: SpriteDebugArt } ));
			
			//左墙
			add(new Platform("rightWall", { x: 0 - 10, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt } ));
			
			//右墙
			add(new Platform("leftWall", { x: stage.stageWidth + 10, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt } ));
			
			
			
			//发球虚拟障碍
			add(new Platform("serveBlockLeft", { x: 320, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt } ));
			add(new Platform("serveBlockRight", {x: stage.stageWidth - 320, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			
			//虚拟网
			add(new VirtualNet("virtualNet", {x: stage.stageWidth * 0.5, y: stage.stageHeight / 2, height: stage.stageHeight * 2, view: SpriteDebugArt}));
			
			
			game = new Game();
			
			
			//************************************************************
			
			
			ballMovieClip = new MovieClip(Assets.getMainAtlas().getTextures("ball_"), 30);
			ballMovieClip.blendMode = BlendMode.SCREEN;
			ballMovieClip.scaleX = stage.stageWidth * 0.7 / 1000;
			ballMovieClip.scaleY = stage.stageWidth * 0.7 / 1000;
			//ballMovieClip.pivotX = ballMovieClip.width >> 1;
			//ballMovieClip.pivotY = ballMovieClip.height >> 1;
			
			ballImage = new Image(Assets.getTexture("ball"));
			
			ballImage.scaleX = stage.stageWidth * 0.35 / 1000;
			ballImage.scaleY = stage.stageWidth * 0.35 / 1000;
			
	
			
			//**********************************************
			
			//玩家初始化
			var playerFactory:PlayerFactory = new PlayerFactory();
			
			playerData1 = ScreenController.getInstance().playerData1;
			playerData2 = ScreenController.getInstance().playerData2;
			
			var factoryName:String = Assets.getXML("Armature").@factoryName;			
			player2 = playerFactory.createPlayer(playerData2, ArmatureFactory.getStarlingFactory(factoryName));
			
			//网
			add(new Platform("net", { x: stage.stageWidth * 0.5, y: stage.stageHeight - netView.height / 2 + 15, offsetY: -15 ,width: 10 ,height: netView.height, view: netView } ));
			
			player1 = playerFactory.createPlayer(playerData1, ArmatureFactory.getStarlingFactory(factoryName));

			
			//***********************************************
			
			
			
			//*******************************************
			
			//粒子初始化
			
			//*******************************************
			var fall1:MovieClip = new MovieClip(Assets.getMainAtlas().getTextures("fall1_"), 10);
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
			
			
			//摄像机初始化
			view.camera.setUp(player1.camTarget, new Rectangle(0, 0, 800, 500), new Point(.25, .25));
			
			view.camera.allowZoom = true;

			
			//游戏比赛界面（HUD）
			matchScreen = new MatchScreen();
			stage.addChildAt(matchScreen, 1);
			
			_hud = matchScreen.hud;
			
			_overSkyImage = new Image(Assets.getTexture("overSky"));
			_overSkyImage.pivotX = _overSkyImage.width >> 1;
			_hud.addChild(_overSkyImage);
			
			
			gameStart();
			
			
		}
		
		private function gameStart():void 
		{
			game.setCharacter(player1, player2, ball);
			//game.onBegin.add(gameBegin);
			game.gameBegin();
			//game.onMatchBegin.add(onMatchBegin);
			game.onOver.add(onGameOver);
		}
		
		
		
		//比赛开始
		public function matchBegin():void
		{		
			match = game.match;
			
			match.onLose.add(onMatchLose);
			match.onOver.add(onMatchOver);
			match.onMatchPoint.add(onMatchPoint);
			match.onServe.add(onMatchServe);	
			
			(_particleFireworks.view as PDParticleSystem).stop();
			
			_hud.setMessage();
			
			match.onBegin.dispatch(Match.PLAYER_1);
			
			_hud.setPlayer1Score(match.player1Score);
			
			_hud.setPlayer2Score(match.player2Score);
			
			_hud.setMatchPoint(3);
			_hud.setMatchWinOrLose(3);
		}
		
		private function onMatchServe(servePlayer:Player):void 
		{
			//创建小球
			if (ball)
			{
				ball.destroy();
			}
			ball = new Ball("ball", { radius: (ballImage.height + 12) / 2, view:ballImage} );
			add(ball);
			//********************************************************
			
			match.ball = ball;
			player1.hitBall = ball;
			player2.hitBall = ball;
			
			ball.linearVelocity.SetZero();
			ball.x = servePlayer.invertedViewAndBody ? servePlayer.x + servePlayer.width * 0.8 : servePlayer.x - servePlayer.width * 0.8;
			ball.y = servePlayer.y - servePlayer.height * 1.5 /* * 0.18*/;
		}
		
		private function onGameOver(playerId:uint):void 
		{
			var fireworks:Boolean = false;
			
			if (playerId == Match.PLAYER_1)
			{
				if (ScreenController.gameMode == 1)
				{
					_hud.setMessage("你赢了");
					fireworks = true;
					setTimeout(winReward, 4000);
				}
				else if (ScreenController.gameMode == 2)
				{
					_hud.setMessage("player1Win");
					fireworks = true;
					setTimeout(winReward, 4000);
				}
				
				
				
			}
			else if (playerId == Match.PLAYER_2)
			{
				if (ScreenController.gameMode == 1)
				{
					_hud.setMessage("你输了");
					setTimeout(loseReTry, 4000);
				}
				else if (ScreenController.gameMode == 2)
				{
					_hud.setMessage("player2Win");
					fireworks = true;
					setTimeout(winReward, 4000);
				}
				
				
			}
			
			if (fireworks)
			{
				setTimeout(houl, 500);
				
				function houl():void
				{
					_ce.sound.playSound("win2");
					_ce.sound.setVolume("win2", 2);
				}
				
				_particleFireworksSystem = ((view.getArt(_particleFireworks) as StarlingArt).content as PDParticleSystem);
				
				_particleFireworksSystem.start();
				_particleFireworksSystem.emitterX = stage.stageWidth >> 1;
				_particleFireworksSystem.emitterY = 0/*stage.stageHeight >> 1*/;
			}
		}
		
		
		//赛点
		private function onMatchPoint(playerID:uint):void 
		{
			trace("赛点");
			_hud.setMatchPoint(playerID);
		}
	
		//比赛回合结束
		private function onMatchLose(playerId:uint, value:Number):void
		{
			
			
			_hud.setMatchPoint(3);
			_hud.setMatchWinOrLose(3);
			if (playerId == Match.PLAYER_1)
			{
				_hud.setPlayer2Score(value);
			}
			else if (playerId == Match.PLAYER_2)
			{
				_hud.setPlayer1Score(value);
			}
			
			Camera.openTimeScaleGate();
			
			Camera.changeTimeScale(0.2, null, 0.3);
			
			setTimeout(matchLoseTime, 1000);
		}
		
		private function matchLoseTime():void 
		{
			Camera.changeTimeScale(1, null, 0.1);
			if (ball)
			{
				ball.destroy();
			}
		}
		
		
		//比赛结束
		private function onMatchOver(playerId:uint):void
		{
			_hud.setMatchWinOrLose(playerId);
			
			Camera.openTimeScaleGate();
			
			Camera.changeTimeScale(0.2, null, 0.3);
			
			setTimeout(celebrate, 800, playerId);
		}
		
		private function celebrate(playerId:uint):void 
		{
			if (playerId == Match.PLAYER_1)
			{
				Camera.changeCameraZoom(2, player1.camTarget, 0.015);
			}
			else if (playerId == Match.PLAYER_2)
			{
				Camera.changeCameraZoom(2, player2.camTarget, 0.015);
			}
			setTimeout(nextMatch, 3000);
		}
		
		private function nextMatch():void 
		{
			Camera.changeCameraZoom(1, null, 0.05);
			Camera.changeTimeScale(1, null, 0.1);
			game.matchBegin();
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
			else if (ScreenController.gameMode == 2)
			{
				var simpleWindows:SimpleWindows = new SimpleWindows();
				matchScreen.addChild(simpleWindows);
				simpleWindows.setText("要再来一局吗？");
				simpleWindows.OKSignal.add(anotherGameOK);
				//simpleWindows.cancelSignal.add(buyCancel);	
			}
		}
		
		private function anotherGameOK():void 
		{
			gameStart();
		}
		
		
		
		private function rewardBoardOver():void 
		{
			
			var gameOverBoard:GameOverBoard = new GameOverBoard();
			matchScreen.addChild(gameOverBoard);
			gameOverBoard.replaySignal.add(anotherGameOK);
			gameOverBoard.nextSignal.add(nextGame);
			//simpleWindows.cancelSignal.add(buyCancel);			
		}
		
		private function nextGame():void 
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
			
			if (match)
			{
				match.update();
			}
			
			
			_particleFireSystem = ((view.getArt(_particleFire) as StarlingArt).content as PDParticleSystem);
			_particleHeroairSystem = ((view.getArt(_particleHeroair) as StarlingArt).content as PDParticleSystem);
			//_particleSmoke1System = ((view.getArt(_particleSmoke1) as StarlingArt).content as PDParticleSystem);
			//_particleSmoke2System = ((view.getArt(_particleSmoke2) as StarlingArt).content as PDParticleSystem);
			
			
			_particleFireSystem.start();
			_particleFireSystem.emitterX = ball.x;
			_particleFireSystem.emitterY = ball.y;
			
			_particleFireSystem.emitAngle = ball.linearAngle.GetAngle();
			_particleFireSystem.speed = ball.linearAngle.Length() * 15;
			
			if (ball.linearAngle.Length() > 16)
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
			
			if (ball.linearAngle.Length() > 16)
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
			
			if (ball.y - view.camera.camPos.y < 0)
			{
				_overSkyImage.y = 0;
				_overSkyImage.x = ball.x;
				_overSkyImage.alpha = 0.8;
			}
			else
			{			
				_overSkyImage.y = -_overSkyImage.height;
				_overSkyImage.alpha = 0;
			}
			
			
			
			/*if (player1.getStateByName("moveAreaTouchBall").isEnding() && player2.getStateByName("moveAreaTouchBall").isEnding())
			{
				Camera.changeMotion(1, 0.05);
				view.camera.setZoom(1);
			}*/
			
			//trace(player1.getStateByName("moveAreaTouchBall"));
			
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
					
			if (_ce.sound.soundIsPlaying("background1"))
			{
				_ce.sound.stopSound("background1");
			}
			
			if (_ce.sound.soundIsPlaying("background2"))
			{
				_ce.sound.stopSound("background2");
			}
						
		}
		
		
	
	}
}
