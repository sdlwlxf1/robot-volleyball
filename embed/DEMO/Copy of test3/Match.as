package test2 
{
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;
	import test2.logic.Process;
	/**
	 * ...
	 * @author ...
	 */
	public class Match 
	{		
		private static const ROUND_BEGIN:uint = 1;
		
		private static const ROUND_ON:uint = 2;
		
		private static const ROUND_END:uint = 3;
		
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
			trace("begin");
			if (playerId == PLAYER_1)
			{
				_servePlayer = _player1;
			}
			else if (playerId == PLAYER_2)
			{
				_servePlayer = _player2;
			}
			trace("beginServe");
			serve();
		}
		
		private function player2Lose():void 
		{
			if (_roundProcess == ROUND_ON)
			{
				_losePlayer = _player2;
				_roundProcess = ROUND_END;
				_servePlayer = _losePlayer;
				_player1Score += 1;
				_losePlayer.canAutoMove = false;
				onLose.dispatch(PLAYER_2, _player1Score);
				if (!gameOver())
				{
					trace("onServe");
					//serve();
					//_player2.x = _player2.serveBallPosition;
					setTimeout(serve, 1000);
				}
			}
		}
		
				
		private function player1Lose():void 
		{
			if (_roundProcess == ROUND_ON)
			{
				_losePlayer = _player1;
				_roundProcess = ROUND_END;
				_servePlayer = _losePlayer;
				_player2Score += 1;
				_losePlayer.canAutoMove = false;
				onLose.dispatch(PLAYER_1, _player2Score);
				if (!gameOver())
				{
					trace("onServe");
					//serve();
					//_player1.x = _player1.serveBallPosition;
					setTimeout(serve, 1000);
				}
			}
		}
		
		private function gameOver():Boolean 
		{
			if (_player1Score == 25)
			{
				onOver.dispatch(PLAYER_1);
				_matchProcess = MATCH_OVER;
				return true;
			}
			else if (_player2Score == 25)
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
			if (_roundProcess == ROUND_BEGIN && _servePlayer == _player2)
			{
				//_ball.isStatic = false;
				_servePlayer.canServe = false;
				_servePlayer.canHit = true;
				_servePlayer.canJump = true;
 				_roundProcess = ROUND_ON;
			}
		}
		
		private function player1Hit():void 
		{
			if (_roundProcess == ROUND_BEGIN && _servePlayer == _player1)
			{
				//_ball.isStatic = false;
				_servePlayer.canServe = false;
				_servePlayer.canHit = true;
				_servePlayer.canJump = true;
				_roundProcess = ROUND_ON;
			}
		}
		
		private function serve():void
		{

			_roundProcess = ROUND_BEGIN;
			_ball.x = _servePlayer.invertedBody ? _servePlayer.x - _servePlayer.width * 1.3 : _servePlayer.x + _servePlayer.width * 1.3;
			_ball.y = _servePlayer.y - _servePlayer.height * 1.5 /* * 0.18*/;
			_servePlayer.canServe = true;
			_servePlayer.canHit = false;
			_servePlayer.canJump = false;
			_servePlayer.canAutoMove = true;
			//_ball.isStatic = true;
		}
		
	}

}