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

	import aze.motion.easing.Cubic;
	import aze.motion.eaze;
	import aze.motion.EazeTween;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.FragmentFilterMode;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import assets.Assets;
	import assets.Fonts;
	import constants.StageConst;
	import customObjects.Font;
	import gameObjects.Player;
	import logics.gameLogic.Match;
	import objectPools.PoolTextField;
	import ui.customTween.InOutTweens;
	import ui.customTween.InScale;
	import ui.customTween.OutFade;
	import utils.ShakeAnimation;
	
	/**
	 * This class handles the Heads Up Display for the game.
	 *  
	 * @author hsharma
	 * 
	 */
	public class TrainSmashBallHUD extends Sprite
	{

		static public const TEXT_ADD_SCORE_SMASH_BALL:uint = 1;
		static public const TEXT_ADD_SCORE_HIT_GROUND:uint = 2;
		
		
		private var _smashCountText:TextField;
		private var _addScoreSmashBallText:TextField;
		private var _matchMessage:Sprite;
		private var _pauseButton:PauseButton;
		private var _accumulator1:Accumulator;
		private var _accumulator2:Accumulator;
		private var _colon:TextField;
		private var _added:Boolean = false;
		private var inOutTweens:InOutTweens;
		private var _matchText:TextField;
		private var fontMessage1:Font;
		private var fontMessage11:Font;
		private var _winMessage:Image;
		private var _loseMessage:Image;
		private var _player1WinMessage:Image;
		private var _player2WinMessage:Image;
		private var _matchPointMessage:Image;
		private var _matchWinMessage:Image;
		private var _matchLoseMessage:Image;
		private var _lifeBar:LifeBar;
		private var _smashCountImage:Image;
		private var fontMessage2:Font;
		private var _smashCountTextX:Number;
		private var _smashCountTextY:Number;
		private var _addScoreSmashBallTextX:Number;
		private var _addScoreSmashBallTextY:Number;
		private var _addScoreSmashBallImage:Image;
		private var fontMessage3:Font;
		
		private var _scoreText:TextField;
		private var _score:Number = 0;		
		private var _newScore:Number = 0;
		
		private var timeRate:Number = 50;
		private var _addScoreTimer:Timer;
		private var _scoreImage:Image;
		private var _topSkySmashMessage:Image;
		private var _serveBallCountText:TextField;
		private var _overSkyImage:Image;
		private var _poolTextField:PoolTextField;
		private var _addScoreHitGroundText:TextField;
		private var fontMessage4:Font;
		private var _smashCountBoard:Sprite;
		private var _line:Quad;
		private var blur:BlurFilter;
		private var dropShadow:BlurFilter;
		private var glow:BlurFilter;
		private var _scoreMultiNum:Number = 1;
		private var _scoreTextShakeAnimation:ShakeAnimation;
		private var _topSkySmashBoard:Sprite;
		private var _line1:Quad;
		private var _topSkySmashImage:Image;
		private var _addScoreTopSkyImage:Image;
		private var _timeCountBoard:TimeCountBoard;
		private var _doubleMultiImage:Image;
		private var _blockAirImage:Image;
		private var _groupCount:Image;
		private var _groupCountText:TextField;
		private var _groupReadyImage:Image;
		private var _groupReadySprite:Sprite;
		private var _groupReady1:Image;
		private var _groupReady2:Image;
		private var _groupReady3:Image;
		private var _groupReadyGo:Image;
		private var _groupReadyCountText:TextField;
		private var _addScoreTimerEnable:Boolean = true;
		private var _addLifeImage:Image;
		private var _celebrateImage:Image;
		
		public function TrainSmashBallHUD()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		public function setCelebrateImage(endFunction:Function):void
		{
			eaze(_celebrateImage).to(0, { scaleX:0.1, scaleY:0.1 } ).to(0.5, {  scaleX:1, scaleY:1, alpha:1 } ).delay(2).to(0, { alpha:0 } ).onComplete(endFunction);
		}
		
		public function setBlockAir(x:Number, y:Number):void
		{
			_blockAirImage.x = x + 50;
			_blockAirImage.y = y - 20;
			
			
			eaze(_blockAirImage).to(0.1, { scaleX:1.5, scaleY:1.5, alpha:1 } ).easing(Cubic.easeOut).to(0.1, { scaleX:1, scaleY:1, alpha:1 } ).easing(Cubic.easeIn).delay(0.5).to(0, {alpha:0});
		}
		
		public function setGroupCount(groupCount:int):void
		{
			_groupCountText.text = String(groupCount);
		}
		
		public function setGroupReady(groupCount:int, readyEndFunction:Function):void
		{
			_groupReadyCountText.text = String(groupCount);
		
			eaze(_groupReadySprite).to(0, {scaleX:2, scaleY:2}).to(0.2, { scaleX:1, scaleY:1, alpha:1 } ).delay(1.5).to(0, {alpha:0})
			.chain(_groupReady3).to(0, {scaleX:2, scaleY:2}).to(0.3, {  scaleX:1, scaleY:1, alpha:1 } ).delay(0.7).to(0, { alpha:0 } )
			.chain(_groupReady2).to(0, {scaleX:2, scaleY:2}).to(0.3, {  scaleX:1, scaleY:1, alpha:1 } ).delay(0.7).to(0, { alpha:0 } )
			.chain(_groupReady1).to(0, {scaleX:2, scaleY:2}).to(0.3, {  scaleX:1, scaleY:1, alpha:1 } ).delay(0.7).to(0, { alpha:0 } )
			.chain(_groupReadyGo).to(0, {scaleX:2, scaleY:2}).to(0.3, { scaleX:1, scaleY:1, alpha:1 } ).delay(0.7).to(0, { alpha:0 } ).onComplete(readyEndFunction);
			
		}
		
		public function pauseReadyWait(pauseReadyEndFunction:Function):void
		{
			eaze(_groupReady3).to(0, {scaleX:2, scaleY:2}).to(0.3, {  scaleX:1, scaleY:1, alpha:1 } ).delay(0.7).to(0, { alpha:0 } )
			.chain(_groupReady2).to(0, {scaleX:2, scaleY:2}).to(0.3, {  scaleX:1, scaleY:1, alpha:1 } ).delay(0.7).to(0, { alpha:0 } )
			.chain(_groupReady1).to(0, {scaleX:2, scaleY:2}).to(0.3, {  scaleX:1, scaleY:1, alpha:1 } ).delay(0.7).to(0, { alpha:0 } )
			.chain(_groupReadyGo).to(0, {scaleX:2, scaleY:2}).to(0.3, { scaleX:1, scaleY:1, alpha:1 } ).delay(0.7).to(0, { alpha:0 } ).onComplete(pauseReadyEndFunction);
		}
		
		public function setSmashCount(count:Number):void
		{
			_smashCountText.text = String(count - 1);

			eaze(_smashCountBoard).to(0.8, { x:StageConst.stageWidth - _smashCountBoard.width + 1, alpha:1 } ).easing(Cubic.easeIn).delay(3).to(0.8, { x:StageConst.stageWidth, alpha:0 } ).easing(Cubic.easeOut);
			
			eaze(_smashCountText).to(0.1, { scaleX:1.2, scaleY:1.5, alpha:0 } ).easing(Cubic.easeOut).to(0.1, { scaleX:1, scaleY:1, alpha:1 } ).easing(Cubic.easeIn);
		}
		
		public function setAddLife():void
		{
			eaze(_addLifeImage).to(0, {scaleX:3, scaleY:3}).to(0.8, {  scaleX:1, scaleY:1, alpha:1 } ).delay(2).to(0, { alpha:0 } )
		}
		
		
		public function setTopSkySmash(height:Number, maxTime:Number = 3000):void
		{
			_topSkySmashBoard.y = height;
			
			_timeCountBoard.setTimerCount(maxTime);

			eaze(_topSkySmashBoard).to(0.2, { x:0, alpha:1 } ).easing(Cubic.easeIn).chain(_topSkySmashImage).to(0.1, { y:_line1.y - _topSkySmashImage.height / 2 - 5, alpha:1 } ).delay(1).to(0.1, { y:_line1.y - _topSkySmashImage.height / 2 - 15, alpha:0 } ).chain(_topSkySmashBoard).to(0.2, { x: -_addScoreTopSkyImage.x -_addScoreTopSkyImage.width / 2 } ).easing(Cubic.easeOut);
			eaze(_timeCountBoard).delay(1.2).onComplete(_timeCountBoard.timerStart);	
		}
		
		private function timeCountOnComplete():void 
		{
			eaze(_topSkySmashBoard).delay(0.5).to(0.2, { x: -_topSkySmashBoard.width } ).easing(Cubic.easeOut);
		}
		
		public function setServeBallCount(count:int, max:int):void
		{
			_serveBallCountText.text = String(count) + "/" + String(max);
		}	
		
		public function setAddScoreSmashBall(count:Number):void
		{
			_addScoreSmashBallText.text = "+" + String(count);
			eaze(_addScoreSmashBallText).to(0.1, { scaleX:1.2, scaleY:1.5, alpha:0 } ).easing(Cubic.easeOut).to(0.1, { scaleX:1, scaleY:1, alpha:1 } ).easing(Cubic.easeIn);
		}
		
		/*private function smashBallBoardGetIn(object1:Object):void 
		{
			
		}
		
		private function smashBallBoardGetOut(object1:Object):void 
		{
			eaze(object1).
		}*/
		
		
		
		
		public function setAddScoreHitGround(count:Number, x:Number, y:Number, red:Boolean = false):void
		{
			_addScoreHitGroundText = setTextMessage(TEXT_ADD_SCORE_HIT_GROUND, "+" + String(count), x, y);
			if (red)
			{
				_addScoreHitGroundText.color = 0xff0000;
			}
			addScoreHitGroundGetIn(_addScoreHitGroundText);
		}
		
		private function addScoreHitGroundGetIn(target:Object):void 
		{
			eaze(target).to(0.3, { y:_addScoreHitGroundText.y - 60, alpha:1 } ).easing(Cubic.easeIn).delay(0.5).onComplete(addScoreHitGroundGetOut, target);
		}
		
		private function addScoreHitGroundGetOut(target:Object):void 
		{
			eaze(target).to(0.3, { scaleX: 2, scaleY:2,/*y:_addScoreHitGroundText.y - 120*/ alpha:0 } ).easing(Cubic.easeOut).onComplete(_poolTextField.checkIn, target);
		}
		
		public function setScore(score:Number, resetBool:Boolean = false):void
		{
			if (_addScoreTimerEnable)
			{
				_newScore = score;
				
				if (resetBool)
				{
					_score = _newScore;
					_scoreText.text = String(_score);
				}
				else
				{
					
					_addScoreTimer.start();			
				}
			}
			else
			{
				_scoreTextShakeAnimation.startShake();
			}
		}
		
		public function openMultiScore(multiNum:Number):void
		{
			_scoreMultiNum = multiNum;
			//_scoreTextShakeAnimation.startShake();
			//_scoreText.color = 0XFA6003;
			//_scoreText.filter = glow;
			//eaze(_scoreText).to(0.3, { scaleX:1.5, scaleY:1.5} ).easing(Cubic.easeOut);
		}
		
		public function closeMultiScore():void
		{
			_scoreMultiNum = 1;
			//_scoreText.color = Color.WHITE;
			//_scoreTextShakeAnimation.stopShake();
			//_scoreText.filter = null;
			//eaze(_scoreText).to(0.3, { scaleX:1, scaleY:1} ).easing(Cubic.easeOut);
		}
		
		
		/**
		 * On added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			fontMessage1 = Fonts.getFont("britannic");
			
			fontMessage2 = Fonts.getFont("magneto");			
			
			fontMessage3 = Fonts.getFont("vrinda");
			
			fontMessage4 = Fonts.getFont("harlowSolidItalic");

			_lifeBar = new LifeBar();
			_lifeBar.x = 30;
			_lifeBar.y = 10;
			addChild(_lifeBar);
			
			
			
			//***********************************************************************
			//##########################################################
			//***********************************************************************
			_smashCountBoard = new Sprite();
			
			_smashCountBoard.x = StageConst.stageWidth;
			_smashCountBoard.y = StageConst.stageHeight * 0.15;
			
			_smashCountBoard.alpha = 0;
			
			addChild(_smashCountBoard);
			
			_line = new Quad(140, 2, 0xffffff);
			_line.x = 0;
			_line.y = 0 + 30;
			_smashCountBoard.addChild(_line);
			
			
			
			_smashCountImage = new Image(Assets.getTexture("smashCount"));
			_smashCountImage.pivotX = _smashCountImage.width >> 1;
			_smashCountImage.pivotY = _smashCountImage.height >> 1;
			_smashCountImage.x = 80;
			_smashCountImage.y = _line.y - _smashCountImage.height / 2 - 3;
			_smashCountBoard.addChild(_smashCountImage);
			
			
			_smashCountText = new TextField(70, 50, "0", fontMessage2.fontName, fontMessage2.fontSize, fontMessage2.fontColor);	
			_smashCountText.hAlign = HAlign.CENTER;
			_smashCountText.vAlign = VAlign.CENTER;
			_smashCountText.pivotX = _smashCountText.width >> 1;
			_smashCountText.pivotY = _smashCountText.height >> 1;		
			_smashCountText.x = _smashCountImage.x - _smashCountImage.width / 2 - 25;
			_smashCountText.y = _smashCountImage.y;
			_smashCountBoard.addChild(_smashCountText);
	
			_addScoreSmashBallImage = new Image(Assets.getTexture("addScore"));
			_addScoreSmashBallImage.pivotX = _addScoreSmashBallImage.width >> 1;
			_addScoreSmashBallImage.pivotY = _addScoreSmashBallImage.height >> 1;
			_addScoreSmashBallImage.x = 110;
			_addScoreSmashBallImage.y = _line.y + _addScoreSmashBallImage.height / 2 + 3;
			_smashCountBoard.addChild(_addScoreSmashBallImage);
			
			
			_addScoreSmashBallText = new TextField(70, 50, "", fontMessage4.fontName, fontMessage4.fontSize, fontMessage4.fontColor);			
			_addScoreSmashBallText.pivotX = _addScoreSmashBallText.width >> 1;
			_addScoreSmashBallText.pivotY = _addScoreSmashBallText.height >> 1;
			_addScoreSmashBallText.hAlign = HAlign.CENTER;
			_addScoreSmashBallText.vAlign = VAlign.CENTER;	
			_addScoreSmashBallText.x = _addScoreSmashBallImage.x - _addScoreSmashBallImage.width / 2 - 25;
			_addScoreSmashBallText.y = _addScoreSmashBallImage.y + 2;			
			_smashCountBoard.addChild(_addScoreSmashBallText);
			
			_addLifeImage = new Image(Assets.getTexture("lifeOn"));
			_addLifeImage.pivotX = _addLifeImage.width >> 1;
			_addLifeImage.pivotY = _addLifeImage.height >> 1;
			_addLifeImage.x = 120;
			_addLifeImage.y = _smashCountImage.y + 2;
			_addLifeImage.alpha = 0;
			_smashCountBoard.addChild(_addLifeImage);
			
			
			
			//***********************************************************************
			//##########################################################
			//***********************************************************************
			
			_topSkySmashBoard = new Sprite();
			
			_topSkySmashBoard.x = -_topSkySmashBoard.width;
			_topSkySmashBoard.y = StageConst.stageHeight * 0.1;
			
			_topSkySmashBoard.alpha = 0;
			
			addChild(_topSkySmashBoard);
			
			
			_line1 = new Quad(140, 2, 0xffffff);
			_line1.x = 0;
			_line1.y = 0 + 30;
			_topSkySmashBoard.addChild(_line1);
			
			
			_topSkySmashBoard.pivotY = _line1.y;
			
			_topSkySmashImage = new Image(Assets.getTexture("topSkySmash"));
			_topSkySmashImage.pivotX = _topSkySmashImage.width >> 1;
			_topSkySmashImage.pivotY = _topSkySmashImage.height >> 1;
			_topSkySmashImage.x = 75;
			_topSkySmashImage.y = _line1.y - _topSkySmashImage.height / 2 - 3;
			_topSkySmashBoard.addChild(_topSkySmashImage);
			
			_addScoreTopSkyImage = new Image(Assets.getTexture("addScore"));
			_addScoreTopSkyImage.pivotX = _addScoreTopSkyImage.width >> 1;
			_addScoreTopSkyImage.pivotY = _addScoreTopSkyImage.height >> 1;
			_addScoreTopSkyImage.x = 30;
			_addScoreTopSkyImage.y = _line1.y + _addScoreTopSkyImage.height / 2 + 3;
			_topSkySmashBoard.addChild(_addScoreTopSkyImage);
			
			_doubleMultiImage = new Image(Assets.getTexture("doubleMulti"));
			_doubleMultiImage.pivotX = _doubleMultiImage.width >> 1;
			_doubleMultiImage.pivotY = _doubleMultiImage.height >> 1;
			_doubleMultiImage.x = _addScoreTopSkyImage.x + _addScoreTopSkyImage.width / 2 + 15;
			_doubleMultiImage.y = _line1.y + _doubleMultiImage.height / 2 + 4;
			_topSkySmashBoard.addChild(_doubleMultiImage);
			
			_timeCountBoard = new TimeCountBoard();
			_timeCountBoard.onComplete.add(timeCountOnComplete);
			_timeCountBoard.x = _doubleMultiImage.x + _doubleMultiImage.width / 2 + 25;
			_timeCountBoard.y = _addScoreTopSkyImage.y + 1;
			_topSkySmashBoard.addChild(_timeCountBoard);
			
			
			//***********************************************************************
			//##########################################################
			//***********************************************************************
			
			
			blur = new BlurFilter();
			dropShadow = BlurFilter.createDropShadow();
			glow = BlurFilter.createGlow(0XFFFA37, 1, 1);
			
			_scoreText = new TextField(150, 60, "0", fontMessage3.fontName, fontMessage3.fontSize, fontMessage3.fontColor);
			_scoreText.pivotX = _scoreText.width;
			_scoreText.pivotY = 0;
			_scoreText.hAlign = HAlign.RIGHT;
			_scoreText.vAlign = VAlign.TOP;
			_scoreText.x = StageConst.stageWidth * 0.86/*0.68*/;
			_scoreText.y = 0;
			addChild(_scoreText);
			
			_addScoreTimer = new Timer(timeRate);
			_addScoreTimer.addEventListener(TimerEvent.TIMER, addScoreTimerEventListener);
			_addScoreTimer.start();
			

			_scoreTextShakeAnimation = new ShakeAnimation(_scoreText, 500, 2);
			
			_scoreImage = new Image(Assets.getTexture("addScore"));
			_scoreImage.x = StageConst.stageWidth - _scoreText.width - _scoreImage.width + 80;
			_scoreImage.y = 1;
			//addChild(_scoreImage);
			
			
			_serveBallCountText = new TextField(100, 60, "0/", fontMessage3.fontName, fontMessage3.fontSize, fontMessage3.fontColor);
			_serveBallCountText.hAlign = HAlign.RIGHT;
			_serveBallCountText.vAlign = VAlign.TOP;
			_serveBallCountText.x = StageConst.stageWidth * 0.6/*0.27*/;
			_serveBallCountText.y = 0;
			addChild(_serveBallCountText);
			
			
			_accumulator1 = new Accumulator(50, 300);
			_accumulator1.width = 15;
			_accumulator1.height = 40;
			_accumulator1.x = StageConst.stageWidth * 0.95;
			_accumulator1.y = StageConst.stageHeight * 0.8;
			addChild(_accumulator1);
			
			_blockAirImage = new Image(Assets.getTexture("blockAir"));
			_blockAirImage.pivotX = _blockAirImage.width >> 1;
			_blockAirImage.pivotY = _blockAirImage.height >> 1;
			_blockAirImage.alpha = 0;
			addChild(_blockAirImage);
				
			
			_groupCount = new Image(Assets.getTexture("groupCount"));
			_groupCount.pivotX = _groupCount.width >> 1;
			//_groupCount.pivotY = _groupCount.height >> 1;
			
			_groupCount.x = StageConst.stageWidth >> 1;
			_groupCount.y = 0;
			
			addChild(_groupCount);
			
			_groupCountText = new TextField(100, 60, "", fontMessage3.fontName, fontMessage3.fontSize, fontMessage3.fontColor);
			_groupCountText.hAlign = HAlign.CENTER;
			_groupCountText.vAlign = VAlign.TOP;
			_groupCountText.pivotX = _groupCountText.width >> 1;
			//_groupCountText.pivotY = _groupCountText.height >> 1;
			_groupCountText.x = StageConst.stageWidth >> 1;
			_groupCountText.y = 0;
			addChild(_groupCountText);
			
			
			_groupReadySprite = new Sprite();
			_groupReadySprite.alpha = 0;
			addChild(_groupReadySprite);
			_groupReadySprite.x = StageConst.stageWidth >> 1;
			_groupReadySprite.y = StageConst.stageHeight >> 1;
			
			var fontStyle3:Font = Fonts.getFont("huawenxingkai");
			
			_groupReadyCountText = new TextField(100, 60, "", fontStyle3.fontName, fontStyle3.fontSize, fontStyle3.fontColor);
			_groupReadyCountText.hAlign = HAlign.CENTER;
			_groupReadyCountText.vAlign = VAlign.TOP;
			_groupReadyCountText.pivotX = _groupReadyCountText.width >> 1;
			_groupReadyCountText.pivotY = _groupReadyCountText.height >> 1;
			_groupReadyCountText.x = -86;
			_groupReadyCountText.y = 12;
			_groupReadySprite.addChild(_groupReadyCountText);
			
			_groupReadyImage = new Image(Assets.getTexture("groupReady"));
			_groupReadyImage.pivotX = _groupReadyImage.width >> 1;
			_groupReadyImage.pivotY = _groupReadyImage.height >> 1;		
			_groupReadySprite.addChild(_groupReadyImage);
			
			
			
			_groupReady1 = initGroupReadyNum(Assets.getTexture("groupReady1"));
			_groupReady2 = initGroupReadyNum(Assets.getTexture("groupReady2"));
			_groupReady3 = initGroupReadyNum(Assets.getTexture("groupReady3"));
			_groupReadyGo = initGroupReadyNum(Assets.getTexture("groupReadyGo"));
		
			
			_poolTextField = new PoolTextField(createTextField, cleanTextField, 3, 50);
			
			
			_celebrateImage = new Image(Assets.getTexture("celebrateImage"));
			_celebrateImage.pivotX = _celebrateImage.width >> 1;
			_celebrateImage.pivotY = _celebrateImage.height >> 1;
			_celebrateImage.x = StageConst.stageWidth >> 1;
			_celebrateImage.y = StageConst.stageHeight >> 1;
			_celebrateImage.alpha = 0;
			addChild(_celebrateImage);
			
			
			_added = true;
		}
	
		
		private function initGroupReadyNum(texture:Texture):Image		
		{
			var image:Image = new Image(texture);
			image.pivotX = image.width >> 1;
			image.pivotY = image.height >> 1;
			image.alpha = 0;
			image.x = StageConst.stageWidth >> 1;
			image.y = StageConst.stageHeight >> 1;
			addChild(image);
			return image;
		}

		private function cleanTextField(textField:TextField):void 
		{
			textField.removeFromParent();
			EazeTween.killTweensOf(textField);
		}
		
		private function createTextField():TextField 
		{
			var textField:TextField = new TextField(100, 80, "");
			return textField;
		}
		
		public function setTextMessage(type:uint, value:String, x:Number = 0, y:Number = 0):TextField
		{
			var textField:TextField = _poolTextField.checkOut();
			
			switch(type)
			{
				case TEXT_ADD_SCORE_SMASH_BALL:					
					
					break;
					
				case TEXT_ADD_SCORE_HIT_GROUND:					
					textField.width = 100;
					textField.height = 60;
					textField.text = "";
					textField.fontName = fontMessage4.fontName;
					textField.fontSize = fontMessage4.fontSize;
					textField.color = /*0XEDF823*/fontMessage4.fontColor;
					textField.scaleX = 1;
					textField.scaleY = 1;
					textField.pivotX = textField.width >> 1;
					textField.pivotY = textField.height >> 1;
					textField.hAlign = HAlign.CENTER;
					textField.vAlign = VAlign.CENTER;
					
					textField.alpha = 0;
					
					
					textField.x = x;
					textField.y = y;
		
					textField.text = value;
					
					addChild(textField);
					break;
			}
			
			return textField;
		}
		
		
		
		private function addScoreTimerEventListener(e:TimerEvent):void 
		{
			if (_score >= _newScore)
			{
				_score = _newScore;
				_addScoreTimer.stop();
			}
			else
			{				
				if (_scoreMultiNum != 1)
				{
					_score += 2;					
				}
				else
				{
					_score += 2 * _scoreMultiNum;
				}
				_scoreText.text = String(_score);
			}
		}
		
		public function stopScoreCount():void
		{
			_score = _newScore;
			_addScoreTimer.stop();
			_addScoreTimerEnable = false;
		}
		
		public function startScoreCount():void
		{
			_addScoreTimerEnable = true;
		}
		
		public function update():void
		{
			//_accumulator1.update(
		}
		
		public function get lifeBar():LifeBar 
		{
			return _lifeBar;
		}
		
		public function get accumulator1():Accumulator 
		{
			return _accumulator1;
		}
		
		public function get timeCountBoard():TimeCountBoard 
		{
			return _timeCountBoard;
		}
		
		public function get newScore():Number 
		{
			return _newScore;
		}
	}
}