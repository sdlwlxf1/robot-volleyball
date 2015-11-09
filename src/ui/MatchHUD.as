/**
 *
 * Hungry Hero Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2012 Hemanth Sharma (www.hsharma.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package ui {

	import flash.utils.setTimeout;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.Assets;
	import assets.Fonts;
	import customObjects.Font;
	import gameObjects.Player;
	import logics.gameLogic.Match;
	import ui.customTween.InOutTweens;
	import ui.customTween.InScale;
	import ui.customTween.OutFade;
	
	/**
	 * This class handles the Heads Up Display for the game.
	 *  
	 * @author hsharma
	 * 
	 */
	public class MatchHUD extends Sprite
	{
		private var _player1Scores:TextField;
		private var _player2Scores:TextField;
		private var _matchMessage:Sprite;
		private var _pauseButton:PauseButton;
		private var _accumulator1:Accumulator;
		private var _accumulator2:Accumulator;
		private var _colon:TextField;
		private var _added:Boolean = false;
		private var inOutTweens:InOutTweens;
		private var _matchText:TextField;
		private var fontMessage:Font;
		private var fontMessage1:Font;
		private var _winMessage:Image;
		private var _loseMessage:Image;
		private var _player1WinMessage:Image;
		private var _player2WinMessage:Image;
		private var _matchPointMessage:Image;
		private var _matchWinMessage:Image;
		private var _matchLoseMessage:Image;
		
		public function MatchHUD()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			fontMessage = Fonts.getFont("britannic");
			
			_player1Scores = new TextField(80, 80, "0", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_player1Scores.x = (stage.stageWidth - _player1Scores.width) / 2 - 70;
			_player1Scores.y = 0;
			addChild(_player1Scores);
			
			_colon = new TextField(80, 80, "VS", fontMessage.fontName, fontMessage.fontSize * 0.8, fontMessage.fontColor);
			_colon.x = (stage.stageWidth - _colon.width) / 2;
			_colon.y = 0;
			addChild(_colon);
			
			_player2Scores = new TextField(80, 80, "0", fontMessage.fontName, fontMessage.fontSize, fontMessage.fontColor);
			_player2Scores.x = (stage.stageWidth - _player2Scores.width) / 2 + 70;
			_player2Scores.y = 0;
			addChild(_player2Scores);	
			
			_accumulator1 = new Accumulator();
			//addChild(_accumulator1);
			_accumulator2 = new Accumulator();
			_accumulator1.x = 50;
			_accumulator1.y = 400;
			_accumulator2.x = stage.stageWidth - 50;
			_accumulator2.y = 400;
			//addChild(_accumulator2);
			
			fontMessage1 = Fonts.getFont("black1");
			
			_matchMessage = new Sprite();
			//_matchText = new TextField(200, 100, "", fontMessage1.fontName, 40, fontMessage1.fontColor);
			_winMessage = new Image(Assets.getTexture("winMessage"));
			_loseMessage = new Image(Assets.getTexture("loseMessage"));
			_player1WinMessage = new Image(Assets.getTexture("player1Win"));
			_player2WinMessage = new Image(Assets.getTexture("player2Win"));
			_matchPointMessage = new Image(Assets.getTexture("matchPoint"));
			_matchWinMessage = new Image(Assets.getTexture("matchWin"));
			_matchLoseMessage = new Image(Assets.getTexture("matchLose"));
			
			_winMessage.alpha = 0;
			_loseMessage.alpha = 0;
			_player1WinMessage.alpha = 0;
			_player2WinMessage.alpha = 0;
			
			_winMessage.pivotX = _winMessage.width >> 1;
			_winMessage.pivotY = _winMessage.height >> 1;
			
			_loseMessage.pivotX = _loseMessage.width >> 1;
			_loseMessage.pivotY = _loseMessage.height >> 1;
			
			_player1WinMessage.pivotX = _player1WinMessage.width >> 1;
			_player1WinMessage.pivotY = _player1WinMessage.height >> 1;
			
			_player2WinMessage.pivotX = _player2WinMessage.width >> 1;
			_player2WinMessage.pivotY = _player2WinMessage.height >> 1;
			
			_matchMessage.addChild(_winMessage);
			_matchMessage.addChild(_loseMessage);
			_matchMessage.addChild(_player1WinMessage);
			_matchMessage.addChild(_player2WinMessage);
			//_matchMessage.addChild(_matchText);
			//_matchMessage.pivotX = _matchMessage.width >> 1;
			//_matchMessage.pivotY = _matchMessage.height >> 1;
			_matchMessage.x = stage.stageWidth >> 1;
			_matchMessage.y = stage.stageHeight >> 1;
			addChild(_matchMessage);
			
			inOutTweens = new InOutTweens(_matchMessage, InScale, OutFade);
			//inOutTweens.inOnComplete = messageInOnComplete;
			inOutTweens.outOnComplete = messageOutOnComplete;
			_added = true;
		}
		
		public function setMatchPoint(playerID:uint):void
		{
			if (playerID == Match.PLAYER_1)
			{
				_matchPointMessage.x = _player1Scores.x - _matchPointMessage.width + 10;
				_matchPointMessage.y = _player1Scores.y + _player1Scores.height / 2 - _matchPointMessage.height / 2;
				addChild(_matchPointMessage);
			}
			else if(playerID == Match.PLAYER_2)
			{
				_matchPointMessage.x = _player2Scores.x + _player2Scores.width - 10;
				_matchPointMessage.y = _player2Scores.y + _player2Scores.height / 2 - _matchPointMessage.height / 2;
				addChild(_matchPointMessage);
			}
			else if (playerID == 3)
			{
				removeChild(_matchPointMessage);
			}
		}
		
		
		public function setMatchWinOrLose(playerID:uint):void
		{
			if (playerID == Match.PLAYER_1)
			{
				_matchWinMessage.x = _player1Scores.x - _matchWinMessage.width + 10;
				_matchWinMessage.y = _player1Scores.y + _player1Scores.height / 2 - _matchWinMessage.height / 2;
				
				_matchLoseMessage.x = _player2Scores.x + _player2Scores.width - 10;
				_matchLoseMessage.y = _player2Scores.y + _player2Scores.height / 2 - _matchLoseMessage.height / 2;
				
				addChild(_matchWinMessage);
				addChild(_matchLoseMessage);
			}
			else if(playerID == Match.PLAYER_2)
			{
				_matchLoseMessage.x = _player1Scores.x - _matchLoseMessage.width + 10;
				_matchLoseMessage.y = _player1Scores.y + _player1Scores.height / 2 - _matchLoseMessage.height / 2;
				
				_matchWinMessage.x = _player2Scores.x + _player2Scores.width - 10;
				_matchWinMessage.y = _player2Scores.y + _player2Scores.height / 2 - _matchWinMessage.height / 2;
				
				addChild(_matchWinMessage);
				addChild(_matchLoseMessage);
			}
			else if (playerID == 3)
			{
				removeChild(_matchWinMessage);
				removeChild(_matchLoseMessage);
			}
		}
		
		public function setPlayer1Score(value:int):void
		{
			if (_added)
			{
				_player1Scores.text = String(value);
			}
		}
		
		public function setPlayer2Score(value:int):void
		{
			if (_added)
			{
				_player2Scores.text = String(value);
			}
		}
		
		public function update(player1:Player, player2:Player):void
		{
			if (_added)
			{
				_accumulator1.update(player1.power, player1.powerMax);
				_accumulator2.update(player2.power, player2.powerMax);
			}
		}
		
		public function setMessage(value:String = null):void
		{
			if (_added)
			{
				if (value != null)
				{
					_matchMessage.alpha = 1;
					//_matchText.text = value;
					if (value == "你赢了")
					{
						_winMessage.alpha = 1;
					}
					else if (value == "你输了")
					{
						_loseMessage.alpha = 1;
					}
					else if (value == "player1Win")
					{
						_player1WinMessage.alpha = 1;
					}
					else if (value == "player2Win")
					{
						_player2WinMessage.alpha = 1;
					}
					inOutTweens.startIn();
				}
				else
				{
					
					inOutTweens.startOut();
				}
			}
		}
		
		private function messageOutOnComplete():void 
		{
			_winMessage.alpha = 0;
			_loseMessage.alpha = 0;
			_player1WinMessage.alpha = 0;
			_player2WinMessage.alpha = 0;
		}
	}
}