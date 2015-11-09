package logics.gameLogic
{
	import citrus.core.CitrusEngine;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;
	import constants.StageConst;
	import data.BallFlipData;
	import factory.BallFactory;
	import gameObjects.Ball;
	import gameObjects.Cannon;
	import gameObjects.Player;
	import starling.display.Sprite;
	import state.MatchState;
	import state.TrainSmashBallState;
	import ui.TrainSmashBallHUD;
	
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class TrainSmashBall
	{
		
		public static var gameWidth:int;
		public static var gameHeight:int;
		public static var gameMiddle:int;
		
		private var _score:Number = 0;
		
		private var _life:Number = 6;
		
		public var serveBallCountMax:Number = 50;
		
		private var _hitBallCount:Number = 0;
		
		//private var _conSmashBall
		
		private var _groupCount:int = 1;
			
		public var groupCountMax:int = 6;
		
		private var _smashBallCount:Number = 0;
		
		private var _flatSmashBallCount:Number = 0;
		
		private var _heavySmashBallCount:Number = 0;
		
		private var _serveBallCount:Number = 0;
		
		
		private var _cannon:Cannon;
		private var _player1:Player;
		private var _ball:Ball;
		
		
		
		private var _ballFlipData:BallFlipData;
		
		private var _multiNum:Number = 1;
		
		
		
		public var slowDownBool:Boolean = false;
		
		public var onBegin:Signal;
		
		public var onServe:Signal;
		
		public var onOver:Signal;
		
		public var onHit:Signal;
		
		public var onPass:Signal;
		
		public var hud:TrainSmashBallHUD;
		
		
		static public const TRAIN_BEGIN:int = 1;
		static public const TRAIN_READY:int = 2;
		static public const TRAIN_ON:int = 3;
		static public const TRAIN_OVER:int = 4;
		static public const TRAIN_STOP:int = 5;
		
		
		public var topCountMaxTime:Number = 3000;
		
		private var _trainProcess:int;
		
		public function TrainSmashBall()
		{
			onBegin = new Signal();
			onOver = new Signal();
			onServe = new Signal();
			onHit = new Signal();
			onPass = new Signal();
			
			gameWidth = StageConst.stageWidth;
			gameHeight = StageConst.stageHeight;
			gameMiddle = StageConst.stageWidth / 2;
		
		}
		
		
		public function trainBegin():void
		{
			onBegin.dispatch();
			_trainProcess = TRAIN_BEGIN;
			score = 0;
			life = 6;
			groupCount = 1;
		}
		
		private function resetData():void
		{		
			hitBallCount = 0;
			smashBallCount = 0;		
			flatSmashBallCount = 0;		
			heavySmashBallCount = 0;
			serveBallCount = 0;
		}
		
		private function groupBegin(theGroupCount:int):void
		{
			_trainProcess = TRAIN_READY;
			initGroup(theGroupCount);
			resetData();			
			groupReady(theGroupCount);					
		}
		
		private function groupReady(theGroupCount:int):void 
		{
			(CitrusEngine.getInstance().state as TrainSmashBallState).removeAllBall();
			
			hud.setGroupReady(theGroupCount, groupReadyEnd);
		}
		
		private function groupReadyEnd():void 
		{			
			trainOn();
		}
		
		
		private function trainOn():void
		{
			_trainProcess = TRAIN_ON;
			_cannon.isFiring = true;
		}
		
		
		private function trainStop():void
		{
			_trainProcess = TRAIN_STOP;
			_cannon.isFiring = false;
		}
		
		private function trainPass():void
		{
			_trainProcess = TRAIN_OVER;
			onPass.dispatch();
		}
		
		private function trainOver():void
		{
			_trainProcess = TRAIN_OVER;
			onOver.dispatch();
		}
		
		
		private function initGroup(theGroupCount:int):void 
		{
			serveBallCountMax = 60;
			
			switch(theGroupCount)
			{
				case 1:
					_cannon.fireRate = 1500;
					break;
				case 2:
					_cannon.fireRate = 1200;
					break;
				case 3:
					_cannon.fireRate = 1000;
					break;
				case 4:
					_cannon.fireRate = 800;
					//serveBallCountMax = 60;
					break;
				case 5:
					_cannon.fireRate = 600;
					//serveBallCountMax = 80;
					break;
				case 6:
					_cannon.fireRate = 450;
					//serveBallCountMax = 100;
					break;
			}
		}
		
		public function setCharacter(player1:Player, cannon:Cannon):void
		{
			_player1 = player1;
			_player1.train = this;
			
			_cannon = cannon;
			_cannon.train = this;
			
			_player1.onHit.add(player1Hit);
			_cannon.onFire.add(fireBall);
			_cannon.onServe.add(serveBall);
			
			_ballFlipData = new BallFlipData();
		}
		
		private function fireBall():void
		{
			if (_serveBallCount < serveBallCountMax)
			{
				_ballFlipData.init(-(Math.random() * 22 + 14) / 100 * Math.PI, Math.random() * 5 + 25);
				_ballFlipData.invert();
				
				_cannon.fire(TrainLevelController.getInstance().getCurLevelData().mapData.ballType /*Math.random() * 4 + 1*/, _ballFlipData);
			}		
		}
		
		private function ballOnGround(theBall:Ball):void
		{
			theBall.explode();
			if (theBall.x > StageConst.stageWidth >> 1)
			{
				var i:int;
				if (!slowDownBool)
				{
					if (theBall.blockAddScore)
					{
						i = 10 * _multiNum * 2;
					}
					else
					{
						i = 10 * _multiNum;
					}										
				}
				else
				{
					i = 0;
				}
				score += i;
				if (i == 10)
				{
					hud.setAddScoreHitGround(i, theBall.x, theBall.y - 50);
				}
				else if(i > 10)
				{
					hud.setAddScoreHitGround(i, theBall.x, theBall.y - 50, true);
				}
			}
			
			checkTrainProcess(theBall);			
		}
		
		private function checkTrainProcess(theBall:Ball):void 
		{
			if (theBall.countId >= serveBallCountMax)
			{
				_cannon.isFiring = false;
				setTimeout(function():void { groupCount++; }, 2000);								
			}
		}
		
		
		private function serveBall(theBall:Ball):void
		{
			theBall.onTouchGround.add(ballOnGround);
			theBall.onLose.add(ballOnLoseGround);			
			serveBallCount++;			
			theBall.countId = _serveBallCount;
		}
		
		public function ballOnLoseGround():void
		{
			life--;
			
			smashBallCount = 0;		
		}
		
		
		
		private function player1Hit(hitType:String, hitBall:Ball):void
		{
			hitBallCount++;
			
			switch (hitType)
			{
				case "digBall": 
					smashBallCount = 0;
					//score += 50;
					break;
				case "batBall": 
					smashBallCount = 0;
					//score += 50;
					break;
				case "flatSmashBall": 
					flatSmashBallCount++;
					smashBallCount++;
					//score += 100;
					break;
				case "heavySmashBall": 
					heavySmashBallCount++;
					smashBallCount++;
					//score += 100;
					checkBallHeight(hitBall);
					checkBlockAir(hitBall);
					break;
				case "blockBall": 
					smashBallCount++;
					//score += 150;
					checkBallHeight(hitBall);
					checkBlockAir(hitBall);
					
					break;
			}
			
			/*switch (hitBall.ballType)
			{
				case BallFactory.BALL_RED:
					
					life++;
					break;
			}*/
			
			
			
			onHit.dispatch();
		}
		
		private function checkBlockAir(hitBall:Ball):void
		{
			if (hitBall.rise)
			{
				hud.setBlockAir(hitBall.x, hitBall.y);
				
				hitBall.fireParticleOpen = true;
				
				hitBall.explodeParticleEnable = true;
				
				hitBall.blockAddScore = true;
			}
		}
		
		private function checkBallHeight(hitBall:Ball):void
		{
			if (hitBall.y < StageConst.stageHeight * 0.2/* && !slowDownBool*/)
			{
				hud.setTopSkySmash(hitBall.y, topCountMaxTime/* / CitrusEngine.getInstance().timeScale*/);
				_multiNum = 2;
				hud.openMultiScore(2);
				hitBall.fireParticleOpen = true;
				hitBall.explodeParticleEnable = true;
			}
		}
		
		public function timeCountOnComplete():void
		{
			_multiNum = 1;
			hud.closeMultiScore();
		}
		
		
		public function get hitBallCount():Number
		{
			return _hitBallCount;
		}
		
		public function set life(value:Number):void
		{
			if (_trainProcess != TRAIN_OVER)
			{
				if (value <= hud.lifeBar.lifeMax && value >= 0)
				{
					_life = value;
					hud.lifeBar.life = _life;
				}
				
				if (_life == 0)
				{
					trainStop();
					trainOver();
				}
			}
		}
	
		public function get life():Number
		{
			return _life;
		}
		
		public function get score():Number
		{
			return _score;
		}
		
		public function set score(value:Number):void
		{
			/*if (_trainProcess != TRAIN_OVER)
			{*/

				_score = value;
				
				if (value == 0)
				{
					hud.setScore(_score, true);
				}
				else
				{					
					hud.setScore(_score);
				}
			/*}*/
		}
		
		//private function 
		
		public function get smashBallCount():Number
		{
			return _smashBallCount;
		}
		
		public function set smashBallCount(value:Number):void
		{
			/*if (_trainProcess != TRAIN_OVER)
			{*/
				_smashBallCount = value;
				
				if (_smashBallCount > 1)
				{
					hud.setSmashCount(_smashBallCount);
					
					var i:int;

					if (!slowDownBool)
					{
						i = (_smashBallCount - 1) * _multiNum
					}
					else
					{
						i = 0;
					}
					
					hud.setAddScoreSmashBall(i);
					
					score += i;
					
					if ((_smashBallCount - 1) % 5 == 0)
					{
						hud.setAddLife();
						life++;
					}
				}
			/*}*/
		}
		
		public function get heavySmashBallCount():Number
		{
			return _heavySmashBallCount;
		}
		
		public function set heavySmashBallCount(value:Number):void
		{
			_heavySmashBallCount = value;
		}
		
		public function get flatSmashBallCount():Number
		{
			return _flatSmashBallCount;
		}
		
		public function set flatSmashBallCount(value:Number):void
		{
			_flatSmashBallCount = value;
		}
		
		public function get serveBallCount():Number
		{
			return _serveBallCount;
		}
		
		public function set serveBallCount(value:Number):void
		{
			/*if (_trainProcess != TRAIN_OVER)
			{*/
				_serveBallCount = value;
				hud.setServeBallCount(_serveBallCount, serveBallCountMax);
			/*}*/
		}
		
		public function set hitBallCount(value:Number):void 
		{
			_hitBallCount = value;
		}
		
		public function get groupCount():int 
		{
			return _groupCount;
		}
		
		public function set groupCount(value:int):void 
		{
			if (_trainProcess != TRAIN_OVER)
			{
				if (value > groupCountMax)
				{
					trainPass();
				}
				else
				{
					_groupCount = value;
					hud.setGroupCount(_groupCount);
					groupBegin(_groupCount);
				}
			}
			
		}
		
		public function get trainProcess():int 
		{
			return _trainProcess;
		}
		
		public function update():void
		{
			/*if (CitrusEngine.getInstance().input.justDid("p1skill1"))
			{
				hud.stopScoreCount();
			}
			else if (CitrusEngine.getInstance().input.justEnd("p1skill1"))
			{
				hud.startScoreCount();
			}*/
		}
		
		
	
	}

}