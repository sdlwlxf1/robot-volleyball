package logics.gameLogic 
{
	import citrus.core.CitrusEngine;
	import org.osflash.signals.Signal;
	import constants.StageConst;
	import gameObjects.Ball;
	import gameObjects.Player;
	import state.MatchState;
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class Game 
	{
		
		public static var gameWidth:int;
		public static var gameHeight:int;
		public static var gameMiddle:int;
		
		private var _player1:Player;
		private var _player2:Player;
		private var _ball:Ball;		
		private var _player1MatchScore:int = 0;
		private var _player2MatchScore:int = 0;
		
		
		private var _singleTotalPoint:int = 6;
		private var _doubleTotalPoint:int = 10;		
		
		private var _matchNum:int = 3;	
		private var _curMatchId:int = 0;
		
		
		private var _match:Match;
		private var gameOver:Boolean = false;

		
		
		public var onMatchBegin:Signal;

		public var onOver:Signal;

		
		public function Game() 
		{			
			onMatchBegin = new Signal();
			onOver = new Signal();
			
			gameWidth = StageConst.stageWidth;
			gameHeight = StageConst.stageHeight;
			gameMiddle = StageConst.stageWidth / 2;
		}
		
		public function setCharacter(player1:Player, player2:Player, ball:Ball):void
		{
			_player1 = player1;
			_player2 = player2;
			_ball = ball;
			
			_player1.game = this;
			_player2.game = this;
			_player1.opponent = _player2;
			_player2.opponent = _player1;
		}
		
		public function gameBegin():void
		{
			_curMatchId = 0;
			_player1MatchScore = 0;
			_player2MatchScore = 0;
			gameOver = false;
			matchBegin();
		}
		
		public function matchBegin():void
		{
			if (_curMatchId < _matchNum && gameOver == false)
			{
				_curMatchId++;
				
				match = new Match(_player1, _player2, _ball);
				_player1.match = _match;
				_player2.match = _match;
				_player1.opponent = _player2;
				_player2.opponent = _player1;
				
				if (ScreenController.gameMode == 1)
				{
					match.totalPoint = _singleTotalPoint;
				}
				else if (ScreenController.gameMode == 2)
				{
					match.totalPoint = _doubleTotalPoint;
				}
				
				_match.onOver.add(matchOver);
				
				(CitrusEngine.getInstance().state as MatchState).matchBegin();
				
				//onMatchBegin.dispatch();
			}
		}
		
		private function matchOver(playerID:uint):void 
		{
			if (playerID == Match.PLAYER_1)
			{
				_player1MatchScore++;
			}
			else if(playerID == Match.PLAYER_2)
			{
				_player2MatchScore++;
			}
			
			checkMatchScore();
		}
		
		private function checkMatchScore():void 
		{
			if (_player1MatchScore > _matchNum / 2)
			{
				onOver.dispatch(Match.PLAYER_1);
				gameOver = true;
			}
			else if (_player2MatchScore > _matchNum / 2)
			{
				onOver.dispatch(Match.PLAYER_2);
				gameOver = true;
			}
		}
		
		public function get match():Match 
		{
			return _match;
		}
		
		public function set match(value:Match):void 
		{
			_match = value;
		}
		
	}

}