package test2.logic.gameLogic 
{
	import citrus.core.CitrusEngine;
	import citrus.objects.platformer.box2d.Platform;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;
	import test2.gameObjects.Ball;
	import test2.gameObjects.Player;
	import test2.logic.Process;
	import test2.math.MathUtils;
	/**
	 * ...
	 * @author ...
	 */
	public class Match 
	{	
		public static const SERVE_BEGIN:uint = 1;
		
		public static const SERVE_ON:uint = 2;
		
		public static const SERVE_END:uint = 3;
		
		public static const ROUND_BEGIN:uint = 1;
		
		public static const ROUND_ON:uint = 2;
		
		public static const ROUND_END:uint = 3;
		
		public static const MATCH_START:uint = 1;
		
		public static const MATCH_ON:uint = 2;
		
		public static const MATCH_OVER:uint = 3;
		
		public static const PLAYER_1:uint = 1;
		public static const PLAYER_2:uint = 2;
		
		private var _player1:Player;
		private var _player2:Player;
		private var _ball:Ball;
		private var _servePlayer:Player;
		private var _losePlayer:Player;
		
		private var _player1Score:Number = 0;
		private var _player2Score:Number = 0;
		
		private var _roundProcess:uint;
		private var _serveProcess:uint;
		private var _matchProcess:uint;
		
		public var onBegin:Signal;
		public var onLose:Signal;
		public var onOver:Signal;
		
		public function Match(player1:Player, player2:Player, ball:Ball) 
		{
			_player1 = player1;
			_player2 = player2;
			_ball = ball;
			onLose = new Signal();
			onOver = new Signal();
			onBegin = new Signal();
			_player1.onHit.add(player1Hit);
			_player2.onHit.add(player2Hit);
			_player1.onLose.add(player1Lose);
			_player2.onLose.add(player2Lose);
			
			onBegin.add(matchBegin);
		}
		
		private function matchBegin(playerId:uint):void 
		{
			_player1Score = 0;			
			_player2Score = 0;
			
			if (playerId == PLAYER_1)
			{
				_servePlayer = _player1;
			}
			else if (playerId == PLAYER_2)
			{
				_servePlayer = _player2;
			}
			serve();
		}
		
		private function player2Lose():void 
		{
			var lose:Boolean = false;
			if (_roundProcess == ROUND_ON)
			{			
				_roundProcess = ROUND_END;
				lose = true;
				
			}
			
			if (_serveProcess == SERVE_ON)
			{
				_serveProcess = SERVE_END;
				_player1.canServe = false;
				_player1.canHit = true;
				_player1.canJump = true;
				
				_player2.canServe = false;
				_player2.canHit = true;
				_player2.canJump = true;
				lose = true;
			}
			
			if (lose)
			{
				_losePlayer = _player2;
				_servePlayer = _losePlayer;
				_player1Score += 1;
				_losePlayer.canAutoMoveToBall = false;
				_losePlayer.canAutoMoveToServeBallPosititon = true;
				_player1.canAutoMoveToServeBallPosititon = true;
				
				onLose.dispatch(PLAYER_2, _player1Score);
				if (!gameOver())
				{
					//trace("onServe");
					//serve();
					//_player2.x = _player2.serveBallPosition;
					setTimeout(serve, 1000);
				}
			}
		}
		
				
		private function player1Lose():void 
		{
			var lose:Boolean = false;
			if (_roundProcess == ROUND_ON)
			{		
				_roundProcess = ROUND_END;				
				lose = true;
			}
			
			if (_serveProcess == SERVE_ON)
			{
				_serveProcess = SERVE_END;				
				_player1.canServe = false;
				_player1.canHit = true;
				_player1.canJump = true;
				
				_player2.canServe = false;
				_player2.canHit = true;
				_player2.canJump = true;
				
				
				lose = true;
			}
			
			if (lose)
			{
				_losePlayer = _player1;
				_servePlayer = _losePlayer;
				_player2Score += 1;
				_losePlayer.canAutoMoveToBall = false;
				_losePlayer.canAutoMoveToServeBallPosititon = true;
				_player2.canAutoMoveToServeBallPosititon = true;
				
				onLose.dispatch(PLAYER_1, _player2Score);
				if (!gameOver())
				{
					//trace("onServe");
					//serve();
					//_player1.x = _player1.serveBallPosition;
					setTimeout(serve, 1000);
				}
			}
		}
		
		private function gameOver():Boolean 
		{
			if (_player1Score == 1)
			{
				onOver.dispatch(PLAYER_1);
				_matchProcess = MATCH_OVER;
				return true;
			}
			else if (_player2Score == 1)
			{
				onOver.dispatch(PLAYER_2);
				_matchProcess = MATCH_OVER;
				return true
			}
			else
			{
				return false;
			}
			
		}

		
		private function player2Hit():void 
		{
			if (_serveProcess == SERVE_ON)
			{
				//_ball.isStatic = false;				
				
 				_roundProcess = ROUND_ON;
				
				_serveProcess = SERVE_END;				
				(CitrusEngine.getInstance().state.getObjectByName("serveBlockRight") as Platform).body.SetActive(false);
				_player2.canServe = false;
				_player2.canHit = true;
				_player2.canJump = true;
				_player2.canAutoMoveToServeBallPosititon = false;
				
				_player1.canServe = false;
				_player1.canHit = true;
				_player1.canJump = true;		
				_player1.canAutoMoveToServeBallPosititon = false;
			}
		}
		
		private function player1Hit():void 
		{
			if (_serveProcess == SERVE_ON)
			{
				//_ball.isStatic = false;
				
				_roundProcess = ROUND_ON;
				
				_serveProcess = SERVE_END;
				(CitrusEngine.getInstance().state.getObjectByName("serveBlockLeft") as Platform).body.SetActive(false);
				_player1.canServe = false;
				_player1.canHit = true;
				_player1.canJump = true;
				_player1.canAutoMoveToServeBallPosititon = false;
				
				_player2.canServe = false;
				_player2.canHit = true;
				_player2.canJump = true;				
				_player2.canAutoMoveToServeBallPosititon = false;
			}
		}
		
		private function serve():void
		{
			_servePlayer.x = _servePlayer.serveBallPosition;
			
			_serveProcess = SERVE_ON;
			_roundProcess = ROUND_BEGIN;
			_ball.x = _servePlayer.invertedViewAndBody ? _servePlayer.x + _servePlayer.width * 1 : _servePlayer.x - _servePlayer.width * 1;
			_ball.y = _servePlayer.y - _servePlayer.height * 1.5 /* * 0.18*/;
			
			_servePlayer.canServe = true;
			_servePlayer.canHit = false;
			//_servePlayer.canJump = false;
			_servePlayer.canAutoMoveToBall = true;
			//_ball.isStatic = true;
		}
		
		public function update():void
		{
			if (_serveProcess == SERVE_ON)
			{
				if (_servePlayer == _player1)
				{
					(CitrusEngine.getInstance().state.getObjectByName("serveBlockLeft") as Platform).body.SetActive(true);
				}
				else
				{
					(CitrusEngine.getInstance().state.getObjectByName("serveBlockLeft") as Platform).body.SetActive(false);
				}
				
				if (_servePlayer == _player2)
				{
					(CitrusEngine.getInstance().state.getObjectByName("serveBlockRight") as Platform).body.SetActive(true);
				}
				else
				{
					(CitrusEngine.getInstance().state.getObjectByName("serveBlockRight") as Platform).body.SetActive(false);
				}
				
			}
		}
		
		public function get roundProcess():uint 
		{
			return _roundProcess;
		}
		
		public function get serveProcess():uint 
		{
			return _serveProcess;
		}
		
		public function get matchProcess():uint 
		{
			return _matchProcess;
		}
		
		public function get player1Score():Number 
		{
			return _player1Score;
		}
		
		public function get player2Score():Number 
		{
			return _player2Score;
		}
		
		public function get ball():Ball 
		{
			return _ball;
		}
		
		public function set ball(value:Ball):void 
		{
			_ball = value;
		}
		
		public function get player1():Player 
		{
			return _player1;
		}
		
		public function set player1(value:Player):void 
		{
			_player1 = value;
		}
		
		public function get player2():Player 
		{
			return _player2;
		}
		
		public function set player2(value:Player):void 
		{
			_player2 = value;
		}
		
	}

}