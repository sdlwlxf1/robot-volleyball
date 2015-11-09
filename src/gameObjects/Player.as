package gameObjects
{
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import citrus.core.CitrusEngine;
	import citrus.core.CitrusObject;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.view.ACitrusCamera;
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.events.AnimationEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.deg2rad;
	import assets.Assets;
	import constants.StageConst;
	import data.BallFlipData;
	import data.PlayerData;
	import factory.ParticleFactory;
	import logics.Action;
	import logics.gameLogic.Game;
	import logics.gameLogic.Match;
	import logics.gameLogic.TrainSmashBall;
	import logics.Logic;
	import logics.Process;
	import logics.State;
	import math.MathMatrix22;
	import math.MathUtils;
	import math.MathVector;
	import objectPools.PoolParticle;
	import state.IShakeState;
	import state.MatchState;
	import ui.Camera;
	import utils.EasyBox2D;
	
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	import org.osflash.signals.Signal;
	
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	/**
	 * This is a common, simple, yet solid implementation of a side-scrolling Hero.
	 * The hero can run, jump, get hurt, and kill enemies. It dispatches signals
	 * when significant events happen. The game state's logic should listen for those signals
	 * to perform game state updates (such as increment coin collections).
	 *
	 * Don't store data on the hero object that you will need between two or more levels (such
	 * as current coin count). The hero should be re-created each time a state is created or reset.
	 */
	public class Player extends DynamicObject
	{
		public var onJump:Signal;
		public var onSecondJump:Signal;
		public var onLose:Signal;
		public var onHit:Signal;
		public var onAnimationChange:Signal;
		
		private var maxVelocity:Number;
		private var velocityVec:b2Vec2;
		private var jumpHeight:Number;
		private var jumpAcceleration:Number;
		private var secondJumpHeight:Number;
		private var secondJumpAcceleration:Number;
		private var powerA:Number;
		public var powerMax:Number;
		private var serveBallVec:b2Vec2;
		private var serveBallJumpVec:b2Vec2;
		
		public var controlsEnabled:Boolean = true;
		public var inputName:Object;
		
		//击球计算相关参数
		private var ballPosition:b2Vec2 = new b2Vec2();
		private var hitAreaBodyPosition:b2Vec2 = new b2Vec2();
		private var hitBallCurAngle:Number;
		private var hitBallCurVector:MathVector = new MathVector();
		private var ballFlipDirection:b2Vec2 = new b2Vec2();
		private var ballFlipAngles:Vector.<b2Vec2>;
		private var generalFlipAngles:Vector.<b2Vec2>;
		private var jumpFlipAngles:Vector.<b2Vec2>;
		
		//手臂转动参数
		private var rightHandMaxAngle:Number;
		private var rightHandMinAngle:Number;
		
		private var rightHandAngularVelocity:Number;
		private var rightHandBeginHitAngle:Number;
		private var rightHandEndHitAngle:Number;
		private var rightHandBackAngle:Number;
		
		//击球后弹出角度参数
		private var hitBallAngleExtent:Number;
		private var hitBallBeginAngle:Number;
		private var hitBallEndAngle:Number;
		private var hitBallAngleLength:Number;
		private var hitBallAngleAccuracy:Number;
		
		//击球感应区相关参数
		private var hitAreaRadius:Number;
		private var hitAreaBodyDef:b2BodyDef = new b2BodyDef;
		private var hitAreaBody:b2Body;
		private var hitAreaShape:b2Shape;
		private var hitAreaFixtureDef:b2FixtureDef = new b2FixtureDef;
		private var hitAreaFixture:b2Fixture;
		private var hitAreaJoint:b2Joint;
		private var hitAreaJointDef:b2WeldJointDef = new b2WeldJointDef;
		private var hitAreaContactedBody:b2Body;
		private var hitAreaPosition:b2Vec2;
		
		//运动感应区相关参数
		private var moveAreaRadius:Number = 100;
		private var moveAreaBodyDef:b2BodyDef = new b2BodyDef;
		private var moveAreaBody:b2Body;
		private var moveAreaShape:b2Shape;
		private var moveAreaFixtureDef:b2FixtureDef = new b2FixtureDef;
		private var moveAreaFixture:b2Fixture;
		private var moveAreaJoint:b2Joint;
		private var moveAreaJointDef:b2WeldJointDef = new b2WeldJointDef;
		private var moveAreaContactedBody:b2Body;
		private var moveAreaPosition:b2Vec2;
		
		private var _hitBall:Ball;
		private var _opponent:Player;
		
		public var serveBallPosition:Number;
		public var distance:Number = 1;
		public var anchorPosition:b2Vec2;
		private var _playerMovingHero:Boolean;
		
		private var rightHandView:DisplayObject;
		private var rightHandBodyPosition:b2Vec2 = new b2Vec2();
		
		public var power:Number = 0;
		private var powerV:Number = 0;
		
		public var canDuck:Boolean = true;
		public var canServe:Boolean = false;
		public var canHit:Boolean = true;
		public var canAutoMove:Boolean = true;
		public var canJump:Boolean = true;
		public var canMove:Boolean = true;
		public var canAutoHit:Boolean = true;
		public var canAutoJump:Boolean = true;
		public var canAutoMoveToBall:Boolean = true;
		public var canAutoMoveToServeBallPosititon:Boolean = true;
		public var canAutoAccelate:Boolean = true;
		
		public var hand1:Hand;
		public var hand2:Hand;
		
		private var _playerData:PlayerData;
		private var autoJumpHitCount:int;
		private var autoJumpHitLimit:int = 10;
		private var _hitAreaContact:b2Contact;
		private var _playerCenter:Number;
		private var _moveAreaContact:b2Contact;
		private var _hand2Hited:Boolean;
		
		private var _moveRightCount:int = 0;
		private var _moveRightMax:int = 15;
		private var _moveRightCountEnable:Boolean;
		//private var _moveRightAcc:Boolean;
		//private var _moveLeftAcc:Boolean;
		private var _moveLeftCount:int;
		private var _moveLeftCountEnable:Boolean;
		private var _moveLeftMax:int = 15;
		private var _moveAccelation:Number = 3;
		
		private var ballFlipDatas:Vector.<BallFlipData>;
		
		private var _onGround:Boolean;
		
		private var ballFlipData:BallFlipData;
		private var autoJumpExtent:Number = 400;
		
		private var _heavySmashBallExtent:Number = 120;
		private var _heavySmashBallBool:Boolean;
		
		private var _blockBallExtent:Number = 60;
		private var _blockBallBool:Boolean;
		
		private var _ballIsLeft:Boolean;
		private var _ballIsLeftRange:Boolean;
		private var _ballIsLeftOver:Boolean;
		private var _ballIsMiddle:Boolean;
		private var _ballIsJumpMiddle:Boolean;
		private var _ballIsRight:Boolean;
		private var _ballIsRightRange:Boolean;
		private var _ballIsRightOver:Boolean;
		//private var _inScope:Boolean;
		private var _jumpHitExtent:Boolean;
		private var ballSpeed:Number;
		private var _secondJump:Boolean;
		private var _ballIsBack:Boolean;
		private var _ballIsForward:Boolean;
		private var _holdBallBool:Boolean;
		private var _throwBallBool:Boolean;
		private var _waitBallBool:Boolean;
		private var _serveOnBool:Boolean;
		
		private var _digBallDelayBool:Boolean;
		private var _saveBallDelayBool:Boolean;
		private var onTimeScaleChange:Signal;
		private var _rise:Boolean;
		

		
		
		public var serveBallRange:Point;
		
		public var particleHit1:CitrusSprite;
		public var particleHit2:CitrusSprite;
		
		public var particleHandHit1:MovieClipParticle;
		public var particleHandHit2:MovieClipParticle;
		
		public var fog1PoolParticle:PoolParticle;
		public var fog2PoolParticle:PoolParticle;
		
		public var particleFog3:MovieClipParticle;
		
		public var particleJump1:MovieClipParticle;
		
		public var particleFactory:ParticleFactory;
		
		public var match:Match;
		
		public var game:Game;
		
		public var train:TrainSmashBall;
		
		public var camTarget:Object = { x: 0, y: 0 };
		
		public var canFall:Boolean = true;
		
		/**
		 * Creates a new hero object.
		 */
		public function Player(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			super.initialize(poolObjectParams);
			onJump = new Signal();
			onSecondJump = new Signal();
			onAnimationChange = new Signal();
			onLose = new Signal();
			onHit = new Signal();
			onTimeScaleChange = new Signal();
			
		}
		
		override protected function initializeBody():void
		{
			super.initializeBody();
			if (data)
			{
				_playerData = data as PlayerData;
				
				control = _playerData.control;
				invertedViewAndBody = _playerData.invertedViewAndBody;
				velocityVec = _playerData.velocityVec;
				jumpHeight = _playerData.jumpHeight;
				jumpAcceleration = _playerData.jumpAcceleration;
				secondJumpHeight = _playerData.secondJumpHeight;
				secondJumpAcceleration = _playerData.secondJumpAcceleration;
				serveBallVec = _playerData.serveBallVec;
				serveBallJumpVec = _playerData.serveBallJumpVec;
				powerMax = _playerData.powerMax;
				powerA = _playerData.powerA;
				inputName = _playerData.inputName;
				animationName = _playerData.animationName;
			}
			else
			{
				trace("玩家" + name + "数据不存在");
				return;
			}
			
			//击球判断区域
			hitAreaRadius = height * 0.50;
			anchorPosition = new b2Vec2(_x, _y - _height / 3.5);
			hitAreaPosition = new b2Vec2(_x + _width * 0.2, _y - _height * 0.5);
			
			moveAreaRadius = height * 1.8;
			moveAreaPosition = new b2Vec2(_x, _y - _height / 2 - 0.1);
			
			//击球飞出角度力量
			ballFlipDatas = new <BallFlipData>[
			new BallFlipData( -0.35 * Math.PI, 16), 
			new BallFlipData( -0.15 * Math.PI, 16), 
			new BallFlipData(0.00 * Math.PI, 25), 
			new BallFlipData(0.18 * Math.PI, 30),
			new BallFlipData(0.3 * Math.PI, 30)
			];
			
			//翻转变量
			if (invertedViewAndBody == false)
			{
				for (var i:int = 0; i < ballFlipDatas.length; i++)
				{
					ballFlipDatas[i].invert();
				}
				MathVector.invertVector(hitAreaPosition, _x);
				
				serveBallPosition = StageConst.stageWidth - 150;
				serveBallRange = new Point(StageConst.stageWidth - 300, StageConst.stageWidth);
			}
			else if (invertedViewAndBody == true)
			{
				serveBallPosition = 150;
				serveBallRange = new Point(0, 300);
			}
			
			hitBallAngleExtent = hitBallEndAngle - hitBallBeginAngle;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			camTarget.x = x;
			camTarget.y = StageConst.stageWidth;
		}
		
		
		
		override protected function updateAnimation():void
		{
			super.updateAnimation();
			
			var prevAnimation:String = _animation;
			
			if (getStateByName("moveLeftAcc").phase == Process.BEGIN || getStateByName("moveRightAcc").phase == Process.BEGIN)
			{
				_ce.sound.playSound("boost4");
			}
			else if (getStateByName("moveLeftAcc").phase == Process.END)
			{
				
			}
			
			if (!_onGround/*getActionByName("jump").phase == Process.ON*/)
			{
				if (_rise)
				{					
					_animation = "jumpAir";
					if (!_secondJump)
					{
						_animation = "jumpAir1";
					}
				}
				else
				{					
					_animation = "fall";
				}
			}
			else
			{
				if (getStateByName("moveLeft").phase)
				{
					if (invertedViewAndBody)
					{
						if (_serveOnBool)
						{
							_animation = "serveMoveBack";
						}
						else
						{
							_animation = "moveBack";
						}
					}
					else
					{
						/*if (_serveOnBool)
						{
							_animation = "serveMoveAhead";
						}
						else
						{
							_animation = "moveAhead";
						}*/
						
						if (getStateByName("moveLeft").phase == Process.BEGIN)
						{

						}
						else if (getStateByName("moveLeft").phase == Process.END)
						{

						}
						
						if (getStateByName("moveLeftGen").phase == Process.BEGIN)
						{
							fog1PoolParticle.checkOut().play();
							setTimeout(fog1Play, 100);
						}
						else if (getStateByName("moveLeftGen").phase == Process.ON)
						{
							if (_serveOnBool)
							{
								_animation = "serveMoveAhead";
							}
							else
							{
								_animation = "moveAhead";
							}
						}
						else if (getStateByName("moveLeftGen").phase == Process.END)
						{
							fog1PoolParticle.checkOut().play();
						}
						
						
						if (getStateByName("moveLeftAcc").phase == Process.BEGIN)
						{
							fog2PoolParticle.checkOut().play();
							particleFog3.play();
							setTimeout(fog2Play, 100);
						}
						else if (getStateByName("moveLeftAcc").phase == Process.ON)
						{
							if (_serveOnBool)
							{
								_animation = "serveMoveAhead";
							}
							else
							{
								_animation = "moveAheadAcc";
							}
						}
						else if (getStateByName("moveLeftAcc").phase == Process.END)
						{
							fog2PoolParticle.checkOut().play();
						}
						
					}
				}
				else if (getStateByName("moveRight").phase)
				{
					
					if (invertedViewAndBody)
					{
						
						/*if (_serveOnBool)
						{
							_animation = "serveMoveAhead";
						}
						else
						{
							_animation = "moveAhead";
						}*/
						
						if (getStateByName("moveRight").phase == Process.BEGIN)
						{

						}
						else if (getStateByName("moveRight").phase == Process.END)
						{

						}
						
						if (getStateByName("moveRightGen").phase == Process.BEGIN)
						{
							fog1PoolParticle.checkOut().play();
							setTimeout(fog1Play, 100);
						}
						else if (getStateByName("moveRightGen").phase == Process.ON)
						{
							if (_serveOnBool)
							{
								_animation = "serveMoveAhead";
							}
							else
							{
								_animation = "moveAhead";
							}
						}
						else if (getStateByName("moveRightGen").phase == Process.END)
						{
							fog1PoolParticle.checkOut().play();
						}
						
						
						
						if (getStateByName("moveRightAcc").phase == Process.BEGIN)
						{
							fog2PoolParticle.checkOut().play();
							particleFog3.play();
							setTimeout(fog2Play, 100);
						}
						else if (getStateByName("moveRightAcc").phase == Process.ON)
						{
							if (_serveOnBool)
							{
								_animation = "serveMoveAhead";
							}
							else
							{
								_animation = "moveAheadAcc";
							}
						}
						else if (getStateByName("moveRightAcc").phase == Process.END)
						{
							fog2PoolParticle.checkOut().play();
						}
							//setParticleMoveFog1();
					}
					else
					{
						if (_serveOnBool)
						{
							_animation = "serveMoveBack";
						}
						else
						{
							_animation = "moveBack";
						}
					}
				}
				else if (getStateByName("stop").phase)
				{
					if (_serveOnBool)
					{
						_animation = "holdBall";
					}
					else
					{
						_animation = "stop";
					}
				}
			}

			
			if (getActionByName("jumpBegin").phase == Process.ON)
			{
				_animation = "jumpBegin";
			}
			
			if (getActionByName("heavySmashBall").phase == Process.ON)
			{
				_animation = "heavySmashBall";
			}
			
			if (getActionByName("blockBall").phase == Process.ON)
			{
				_animation = "blockBall";
			}
			
			if (getActionByName("digBall").phase == Process.ON)
			{
				_animation = "digBall";
			}
			
			if (getActionByName("flatSmashBall").phase == Process.ON)
			{
				_animation = "flatSmashBall";
			}
			
			if (getActionByName("batBall").phase == Process.ON)
			{
				_animation = "batBall";
			}
			
			if (getActionByName("saveBall").phase == Process.ON)
			{
				_animation = "saveBall";
			}
			
			if (getActionByName("throwBall").phase == Process.ON)
			{
				_animation = "throwBall";
			}
			
			if (getActionByName("throwBallJump").phase == Process.ON)
			{
				_animation = "throwBallJump";
			}
			
			
		
			if (prevAnimation != _animation)
			{
				getActionByName(prevAnimation).phase = Process.END;
				onAnimationChange.dispatch();
			}
				
			//***************************************************************
			//击球计算
			//***************************************************************
			if (_animation == "digBall" || _animation == "saveBall"/*getActionByName("generalHit").isDoing()*/)
			{
				if (/*getStateByName("hitAreaTouchBall").phase > 0*/hand1.getStateByName("touchBall").phase /* && !_hand2Hited*/)
				{
					
					if (_animation == "digBall")
					{
						_digBallDelayBool = true;
					}
					
					if (_animation == "saveBall")
					{
						_saveBallDelayBool = true;
					}
					
					_hitBall = hand1.ball;
					_hitBall.getActionByName("digBall_hited").phase = Process.BEGIN;
					
					getActionByName("digBall_hit").phase = Process.BEGIN;
					
					if (_hitBall.getActionByName("digBall_hited").phase == Process.BEGIN)
					{
						_ce.sound.playSound("hit2");
						_ce.sound.setVolume("hit2", (ballFlipDirection.Length() - 10) / 20);
						onHit.dispatch("digBall", _hitBall);
						
					}
					cameraChange("digBall");
					
					ballFlipData = ballFlipDatas[0];
						
					ballFlipDirection.SetV(ballFlipData.vec);
					
					if (control == "auto")
					{
						ballFlipDirection.Multiply(ballFlipData.power + power + Math.abs(_linearVelocity.x));
					}
					else
					{
						ballFlipDirection.Multiply(ballFlipData.power + power + 10/* + (_invertedViewAndBody ? _linearVelocity.x * 1.5 : -_linearVelocity.x * 1.5)*/);
					}
					_hitBall.body.SetLinearVelocity(ballFlipDirection);
						
					particleHit1.x = _hitBall.x;
					particleHit1.y = _hitBall.y;
					
					(particleHit1.view as MovieClip).rotation = ballFlipData.originalAngle - Math.PI / 4;
					
					if (_invertedViewAndBody)
					{
						
					}
					else
					{
						particleHit1.inverted = true;
					}
					
					(particleHit1.view as MovieClip).currentFrame = 0;
					(particleHit1.view as MovieClip).play();
					
					
					_hand2Hited = true;
				}
			}
			
			else if (_animation == "batBall"/*getActionByName("generalHit").isDoing()*/)
			{
				if (/*getStateByName("hitAreaTouchBall").phase > 0*/hand1.getStateByName("touchBall").phase/*  && !_hand2Hited*/)
				{
					/*(_ce.state as MatchState).shakeAnimation.lastTime = 100;
					 (_ce.state as MatchState).shakeAnimation.startShake();*/
					
					getActionByName("hitBall_hit").phase = Process.BEGIN; 
					 
					_hitBall = hand1.ball;
					
					_hitBall.getActionByName("hitBall_hited").phase = Process.BEGIN;
					
					if (_hitBall.getActionByName("hitBall_hited").phase == Process.BEGIN)
					{					
						_ce.sound.playSound("hit2");
						_ce.sound.setVolume("hit2", (ballFlipDirection.Length() - 10) / 20);
						onHit.dispatch("batBall", _hitBall);
						
					}
					cameraChange("batBall");
					
					ballFlipData = ballFlipDatas[1];
						
					ballFlipDirection.SetV(ballFlipData.vec);
					
					if (control == "auto")
					{
						ballFlipDirection.Multiply(ballFlipData.power + power + Math.abs(_linearVelocity.x));
					}
					else
					{
						ballFlipDirection.Multiply(ballFlipData.power + power + (_invertedViewAndBody ? _linearVelocity.x * 1.5 : -_linearVelocity.x * 1.5));
					}
					
					_hitBall.body.SetLinearVelocity(ballFlipDirection);

						
					particleHit1.x = _hitBall.x;
					particleHit1.y = _hitBall.y;
	
					(particleHit1.view as MovieClip).rotation = ballFlipData.originalAngle - Math.PI / 4;
			
					if (_invertedViewAndBody)
					{
					}
					else
					{
						particleHit1.inverted = true;
					}
					
					(particleHit1.view as MovieClip).currentFrame = 0;
					(particleHit1.view as MovieClip).play();
					
					
					/*hitBall.particleHit1.movieClip.rotation = ballFlipData.originalAngle;
					
					hitBall.particleHit1.play();*/
					
					_hand2Hited = true;
				}
			}
			
			else if (_animation == "flatSmashBall" /*getActionByName("jumpHit").isDoing()*/)
			{
				
				if (/*getStateByName("hitAreaTouchBall").phase > 0*/hand1.getStateByName("touchBall").phase)
				{
					
					getActionByName("flatSmashBall_hit").phase = Process.BEGIN;
					
					_hitBall = hand1.ball;
					
					_hitBall.getActionByName("flatSmashBall_hited").phase = Process.BEGIN;
					
					if (_hitBall.getActionByName("flatSmashBall_hited").phase == Process.BEGIN)
					{
						
						
						/*(_ce.state as IShakeState).shakeAnimation.lastTime = 200;
						(_ce.state as IShakeState).shakeAnimation.startShake();*/

						_ce.sound.playSound("hit3");
						_ce.sound.setVolume("hit3", (ballFlipDirection.Length() - 10) / 20);
						onHit.dispatch("flatSmashBall", _hitBall);
					}					
					cameraChange("flatSmashBall");
					
					ballFlipData = ballFlipDatas[2];
					
					ballFlipDirection.SetV(ballFlipData.vec);
					
					ballFlipDirection.Multiply(ballFlipData.power + power + Math.abs(_linearVelocity.x)/*(_invertedViewAndBody ? _linearVelocity.x * 1 : -_linearVelocity.x * 1)*/);
					
					_hitBall.body.SetLinearVelocity(ballFlipDirection);
						
					/*particleHit2.x = _hitBall.x;
					particleHit2.y = _hitBall.y;
					
					(particleHit2.view as MovieClip).currentFrame = 0;
					(particleHit2.view as MovieClip).play();*/
					
					hitBall.particleHit1.movieClip.rotation = ballFlipData.originalAngle;
					
					hitBall.particleHit1.play();
					
					_hand2Hited = true;
				}
			}
			
			else if (_animation == "heavySmashBall" /*getActionByName("jumpHit").isDoing()*/)
			{
				
				if (/*getStateByName("hitAreaTouchBall").phase > 0*/ hand1.getStateByName("touchBall").phase)
				{
					getActionByName("heavySmashBall_hit").phase = Process.BEGIN; 
					
					_hitBall = hand1.ball;
					
					_hitBall.getActionByName("heavySmashBall_hited").phase = Process.BEGIN;
					
					if (_hitBall.getActionByName("heavySmashBall_hited").phase == Process.BEGIN)
					{				
						_ce.sound.playSound("hit1");
						_ce.sound.setVolume("hit1", (ballFlipDirection.Length() - 10) / 20);
						onHit.dispatch("heavySmashBall", _hitBall);
					}
					cameraChange("heavySmashBall");
					
					ballFlipData = ballFlipDatas[3];
						
					ballFlipDirection.SetV(ballFlipData.vec);
					
					ballFlipDirection.Multiply(ballFlipData.power + power + Math.abs(_linearVelocity.x)/*(_invertedViewAndBody ? _linearVelocity.x * 1 : -_linearVelocity.x * 1)*/);
					
					_hitBall.body.SetLinearVelocity(ballFlipDirection);
						
					/*particleHit2.x = _hitBall.x;
					particleHit2.y = _hitBall.y;
					
					(particleHit2.view as MovieClip).currentFrame = 0;
					(particleHit2.view as MovieClip).play();*/
					
					hitBall.particleHit1.movieClip.rotation = ballFlipData.originalAngle;					
					hitBall.particleHit1.play();
					
				}
			}
			
			else if (_animation == "blockBall" /*getActionByName("jumpHit").isDoing()*/)
			{
				
				if (/*getStateByName("hitAreaTouchBall").phase > 0*/ hand1.getStateByName("touchBall").phase)
				{
					getActionByName("blockBall_hit").phase = Process.BEGIN; 
					
					_hitBall = hand1.ball;
					_hitBall.getActionByName("blockBall_hited").phase = Process.BEGIN;
					
					if (_hitBall.getActionByName("blockBall_hited").phase == Process.BEGIN)
					{
					
						/*(_ce.state as IShakeState).shakeAnimation.lastTime = 200;
						(_ce.state as IShakeState).shakeAnimation.startShake();*/
						
						//cameraChange("null");
						
				
						_ce.sound.playSound("hit1");
						_ce.sound.setVolume("hit1", (ballFlipDirection.Length() - 10) / 20);
						
						onHit.dispatch("blockBall", _hitBall);
						
					}
					cameraChange("blockBall");
					
					ballFlipData = ballFlipDatas[4];
						
					ballFlipDirection.SetV(ballFlipData.vec);
					
					ballFlipDirection.Multiply(ballFlipData.power + power + Math.abs(_linearVelocity.x)/*(_invertedViewAndBody ? _linearVelocity.x * 1 : -_linearVelocity.x * 1)*/);
					
					_hitBall.body.SetLinearVelocity(ballFlipDirection);
						
					/*particleHit2.x = _hitBall.x;
					particleHit2.y = _hitBall.y;
					
					(particleHit2.view as MovieClip).currentFrame = 0;
					(particleHit2.view as MovieClip).play();*/
					
					
				}
			}
		
		}
		
		private function fog1Play():void
		{
			if (animation == "moveAhead")
			{
				if (getStateByName("moveRightGen").phase || getStateByName("moveLeftGen").phase)
				{
					fog1PoolParticle.checkOut().play();
					setTimeout(fog1Play, 100);
				}
			}
		}
		
		private function fog2Play():void
		{
			if (animation == "moveAheadAcc")
			{
				if (getStateByName("moveRightAcc").phase || getStateByName("moveLeftAcc").phase)
				{
					fog2PoolParticle.checkOut().play();
					setTimeout(fog2Play, 100);
				}
			}
		}
		
		
		//***********************************************************
		//cameraChange摄像机
		//***********************************************************
		private function cameraChange(type:String):void
		{
			switch(type)
			{
				
				case "heavySmashBall":

					Camera.changeTimeScale(0.1, this, 0.05);
					Camera.changeCameraZoom(1.3, _hitBall.camTarget);
					
					setTimeout(cameraChange, 100, "null");
					
					break;
				case "digBall":
					//Camera.changeTimeScale(0.3, this, 0.05);
					
					//setTimeout(cameraChange, 100, "null");
					break;
				case "flatSmashBall":

					//Camera.changeTimeScale(0.1, this, 0.05);				
					/*Camera.changeCameraZoom(1.2, _hitBall.camTarget);		
					
					setTimeout(cameraChange, 100, "null");*/
					
					break;
				case "batBall":
					//Camera.changeTimeScale(0.3, this, 0.05);
					
					//setTimeout(cameraChange, 100, "null");
					break;
					
					
				case "null":
					//Camera.changeTimeScale(_ce.startTimeScale, this, 0.1);
					Camera.changeCameraZoom(1, _hitBall.camTarget);
					break;
			}
		}
		
		private function specialHitBall():void
		{
			getActionByName("specialHitBall").phase = Process.BEGIN;
			
			if (_onGround)
			{
				/*if (_ballIsForward)
				{
					getActionByName("digBall").phase = Process.BEGIN;
				}
				if (_ballIsBack)
				{
					getActionByName("saveBall").phase = Process.BEGIN;
				}
				*/
				if (_ce.input.isDoing(inputName["left"]))
				{
					getActionByName("saveBall").phase = Process.BEGIN;					
				}
				else
				{
					getActionByName("digBall").phase = Process.BEGIN;
				}
			}
			else
			{
				if (_blockBallBool)
				{
					getActionByName("blockBall").phase = Process.BEGIN;
				}
				else
				{
					getActionByName("heavySmashBall").phase = Process.BEGIN;
				}
			}
		}
		
		private function generalHitBall():void
		{
			getActionByName("generalHitBall").phase = Process.BEGIN;
			
			if (_onGround)
			{				
				getActionByName("batBall").phase = Process.BEGIN;
			}
			else
			{
				getActionByName("flatSmashBall").phase = Process.BEGIN;
			}
			
			
		}
		
		private function heavySmashBall():void
		{
			if (!_onGround)
			{
				if (_blockBallBool)
				{
					getActionByName("blockBall").phase = Process.BEGIN;
				}
				else
				{
					getActionByName("heavySmashBall").phase = Process.BEGIN;
				}
			}
		}
		
		private function highBall():void
		{
			if (_onGround)
			{				
				/*if (_ballIsForward)
				{
					getActionByName("digBall").phase = Process.BEGIN;
				}
				if (_ballIsBack)
				{
					getActionByName("saveBall").phase = Process.BEGIN;
				}
				*/
				if (_ce.input.isDoing(inputName["left"]))
				{
					getActionByName("saveBall").phase = Process.BEGIN;					
				}
				else
				{
					getActionByName("digBall").phase = Process.BEGIN;
				}
			}
		}
		
		private function flatSmashBall():void
		{
			if (!_onGround)
			{
				getActionByName("flatSmashBall").phase = Process.BEGIN;
			}
		}
		
		private function batBall():void
		{
			if (_onGround)
			{
				getActionByName("batBall").phase = Process.BEGIN;
			}
		}
		
		private function throwBall():void
		{
			if (_onGround)
			{
				getActionByName("throwBall").phase = Process.BEGIN;
			}
		}
		
		private function throwBallJump():void
		{
			if (_onGround)
			{
				getActionByName("throwBallJump").phase = Process.BEGIN;
			}
		}
		
		private function jumpBegin():void
		{
			if (_onGround)
			{
				getActionByName("jumpBegin").phase = Process.BEGIN;
			}

		}
		
		private function jump():void
		{
			if (_onGround)
			{
				getActionByName("jump").phase = Process.BEGIN;				
				_secondJump = true;
			}
		}
		
		private function secondJump():void
		{
			if (_secondJump && !_onGround)
			{
				getActionByName("secondJump").phase = Process.BEGIN;
				_secondJump = false;
			}
		}
		
		private function jumpAccelerate(condition:Boolean):void
		{
			if (condition)
			{
				if (!_onGround && _rise)
				{
					getActionByName("jumpAccelerate").phase = Process.BEGIN;
				}
				else
				{
					getActionByName("jumpAccelerate").phase = Process.END;
				}
			}
			else
			{
				getActionByName("jumpAccelerate").phase = Process.END;
			}
		
		}
		
		override protected function updateActions():void
		{
			super.updateActions();
	
			/*if (_ce.input.justDid(inputName["generalHitBall"]))
			{
				trace("generalHitBall");
			}
			
			if (_ce.input.justDid(inputName["specialHitBall"]))
			{
				trace("specialHitBall");
			}*/
			
			//**********************************************************
			//运动向量
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			
			//键盘控制
			if (_control == "keyboard")
			{
				if (canMove)
				{
					var moveKeyPressed:Boolean = false;
					
					if (_ce.input.justDid(inputName["right"]))
					{
						if (_moveRightCount > 0)
						{
							_moveRightAcc = true;
						}
						else
						{
							_moveRightAcc = false;
						}
						_moveRightCount = _moveRightMax;
						_moveRightCountEnable = true;
					}
					else if (_moveRightAcc && _ce.input.justEnd(inputName["right"]))
					{
						_moveRightAcc = false;
						_moveRightCountEnable = false;
					}
					
					if (_ce.input.justDid(inputName["left"]))
					{
						if (_moveLeftCount > 0)
						{
							_moveLeftAcc = true;
						}
						else
						{
							_moveLeftAcc = false;
						}
						_moveLeftCount = _moveLeftMax;
						_moveLeftCountEnable = true;
					}
					else if (_moveLeftAcc && _ce.input.justEnd(inputName["right"]))
					{
						_moveLeftAcc = false;
						_moveLeftCountEnable = false;
					}
					
					if (_ce.input.isDoing(inputName["right"]))
					{
						//velocity.Add(getSlopeBasedMoveAngle());
						
						if (_moveRightAcc)
						{
							velocity.x = velocityVec.x + _moveAccelation;
						}
						else
						{
							velocity.x = velocityVec.x;
							
						}
						moveKeyPressed = true;
					}
					
					if (_ce.input.isDoing(inputName["left"]))
					{
						//velocity.Subtract(getSlopeBasedMoveAngle());
						
						if (_moveLeftAcc)
						{
							velocity.x = -velocityVec.x - _moveAccelation;
						}
						else
						{
							velocity.x = -velocityVec.x;
						}
						moveKeyPressed = true;
					}
					
					if (_moveRightCountEnable)
					{
						_moveRightCount--;
					}
					
					if (_moveLeftCountEnable)
					{
						_moveLeftCount--;
					}
					
				}
				
				//If player just started moving the hero this tick.
				if (moveKeyPressed && !_playerMovingHero)
				{
					_playerMovingHero = true;
					_fixture.SetFriction(0); //Take away friction so he can accelerate.
				}
				//Player just stopped moving the hero this tick.
				else if (!moveKeyPressed && _playerMovingHero)
				{
					_playerMovingHero = false;
					//velocity.SetZero();
					velocity.x = 0;
					_fixture.SetFriction(_friction); //Add friction so that he stops running
				}
				
				if (canJump)
				{
					if (_ce.input.justDid(inputName["jump"]))
					{
						secondJump();
					}
					
					if (_ce.input.isDoing(inputName["jump"]))
					{
						jumpBegin();
						jumpAccelerate(true);
					}
					else if (_ce.input.justEnd(inputName["jump"]))
					{
						jumpAccelerate(false);
					}
				}
				
				if (canFall)
				{
					if (_ce.input.justDid(inputName["down"]))
					{
						velocity.y = jumpHeight - 5;
					}
				}
				
				if (canServe)
				{
					if (_holdBallBool)
					{
						//canJump = false;
						
						if (_ce.input.justDid(inputName["generalHitBall"]))
						{
							_hitBall.body.SetLinearVelocity(serveBallVec);
							throwBall();
						} else if ( _ce.input.justDid(inputName["specialHitBall"]))
						{
							_hitBall.body.SetLinearVelocity(serveBallJumpVec);
							throwBallJump();
						}
						
						if (!getStateByName("ballRise").phase)
						{
							_hitBall.x = _invertedViewAndBody ? x + width / 2 + _hitBall.width / 2  + 5: x - width / 2 - _hitBall.width / 2 - 5;
							_hitBall.y = y - height * 0.18;
							_hitBall.body.SetAngle(0);
						}
					}
					else
					{
						if (_ce.input.justDid(inputName["generalHitBall"]))
						{
							generalHitBall();
						}
						else if (_ce.input.justDid(inputName["specialHitBall"]))
						{
							specialHitBall();
						}
					}

				}
				
				if (canHit)
				{
					
					if (_ce.input.justDid(inputName["generalHitBall"]))
					{
						generalHitBall();
						power = 0;
						powerV = 0;
					}
					else if (_ce.input.justDid(inputName["specialHitBall"]))
					{
						specialHitBall();
						power = 0;
						powerV = 0;
					}
					else if (_ce.input.isDoing(inputName["generalHitBall"]) || _ce.input.isDoing(inputName["specialHitBall"]))
					{
						
						if (getActionByName("hit").phase)
						{
							if (power < powerMax)
							{
								powerV += powerA;
								power += powerV;
							}
							else
							{
								power = 0;
								powerV = 0;
									//hit();
							}
						}
					}
					/*else if (_ce.input.justDid(inputName["hit"]))
					   {
					   power = 0;
					   powerV = 0;
					   getActionByName("hitHold").phase = Process.END;
					 }*/
					
				}
				
				if (_ce.input.isDoing(inputName["skill1"]))
				{
					Camera.closeTimeScaleGate();
					//_ce.timeScale = 0.1;
					train.slowDownBool = true;
					
					//_hitBall.body.m_customGravity.y = 10;
				}			
				if(_ce.input.justEnd(inputName["skill1"]))
				{
					Camera.openTimeScaleGate();
					//_ce.timeScale = _ce.startTimeScale;
					train.slowDownBool = false;
					//_hitBall.body.m_customGravity.y = 5;
				}
			}
			
			//******************************************************************
			
			//电脑AI
			
			//******************************************************************
			
			else if (_control == "auto")
			{
				
				if (canAutoMove)
				{
					var moveAutoActived:Boolean = false;
					
					
					
					if (canAutoMoveToBall)
					{
						if (_inScope)
						{
							ballSpeed = Math.abs(_hitBall.linearVelocity.x);
							
							/*if (ballSpeed < 2)
							{
								if (_ballIsRightRange)
								{
									velocity.x = velocityVec.x + _moveAccelation;
								}
								else if(_ballIsLeftRange)
								{
									velocity.x = -velocityVec.x - _moveAccelation;
								}
								
								moveAutoActived = true;
								
							}
							else */if (ballSpeed < 6 || ballSpeed > 15)
							{
								
								if (_ballIsRightRange)
								{
									//velocity.Add(getSlopeBasedMoveAngle());
									if (_ballIsRightOver)
									{
										if (canAutoAccelate)
										{
											velocity.x = velocityVec.x + _moveAccelation;
										}
										else
										{
											velocity.x = velocityVec.x;
										}
										
									}
									else
									{
										velocity.x = velocityVec.x;
									}
									moveAutoActived = true;
								}
								else if (_ballIsLeftRange)
								{
									//velocity.Subtract(getSlopeBasedMoveAngle());
									if (_ballIsLeftOver)
									{
										if (canAutoAccelate)
										{
											velocity.x = -velocityVec.x - _moveAccelation;
										}
										else
										{
											velocity.x = -velocityVec.x;
										}
									}
									else
									{
										velocity.x = -velocityVec.x;
									}
									moveAutoActived = true;
								}
								
							}
							else
							{
								if (_invertedViewAndBody)
								{
									if (ballSpeed > 13)
									{
										velocity.x = -velocityVec.x - _moveAccelation;
									}
									else
									{
										velocity.x = -velocityVec.x;
									}
								}
								else
								{
									if (ballSpeed > 13)
									{
										velocity.x = velocityVec.x + _moveAccelation;
									}
									else
									{
										velocity.x = velocityVec.x;
									}
								}
								moveAutoActived = true;
							}
						}
					}
					
					if (canAutoMoveToServeBallPosititon)
					{
						if (!_inScope)
						{
							if (invertedViewAndBody)
							{
								if (_body.GetPosition().x > serveBallPosition / 30)
								{
									//velocity.Subtract(getSlopeBasedMoveAngle());
									velocity.x = -velocityVec.x;
									moveAutoActived = true;
								}
							}
							else
							{
								if (_body.GetPosition().x < serveBallPosition / 30)
								{
									//velocity.Add(getSlopeBasedMoveAngle());
									velocity.x = velocityVec.x;
									moveAutoActived = true;
								}
								
							}		
						}
					}
				}
				
				//If player just started moving the hero this tick.
				if (moveAutoActived && !_playerMovingHero)
				{
					_playerMovingHero = true;
					_fixture.SetFriction(0); //Take away friction so he can accelerate.
				}
				//Player just stopped moving the hero this tick.
				else if (!moveAutoActived && _playerMovingHero)
				{
					_playerMovingHero = false;
					velocity.x = 0;
					_fixture.SetFriction(_friction); //Add friction so that he stops running
				}
				
				if (canAutoHit)
				{
					if (_hitBall)
					{
						ballSpeed = Math.abs(_hitBall.linearVelocity.x);
					}
					
					if (getStateByName("hitAreaTouchBall").phase/*  == Process.BEGIN*/)
					{
						if (ballSpeed < 20)
						{
						
							if (_heavySmashBallBool)
							{
								
								heavySmashBall();

								if (Math.random() < 0.3)
								{
									batBall();
								}
								else
								{
									highBall();
								}
								
							}
							else
							{

								flatSmashBall();

								if (Math.random() < 0.3)
								{
									highBall();
								}
								else
								{
									batBall();
								}

							}
						}
					}
				}
				
				
				if (canAutoJump)
				{
					if (!_onGround)
					{
						autoJumpHitCount = 0;
					}
					if (_ballIsJumpMiddle && _jumpHitExtent)
					{
						autoJumpHitCount++;
						if (autoJumpHitCount > autoJumpHitLimit)
						{
							if (Math.random() > 0.2)
							{
								jump();
							}
							autoJumpHitCount = 0;
						}
						jumpAccelerate(true);
					}
					else
					{
						autoJumpHitCount = 0;
					}
					
					if (opponent.getActionByName("flatSmashBall").phase)
					{
						if (_hitBall.y < y - height * 2 && _hitBall.x > 200 && _hitBall.x < StageConst.stageWidth - 200)
						{
							jump();		
						}
						if (_linearVelocity.y < 0)
						{
							jumpAccelerate(true);
						}
					}
				}
				
			}
			
			
			
			
			//**********************************************
			//击球结束
			//**********************************************
			if ((view as Armature).animation.isComplete)
			{
				if (_animation == "batBall")
				{
					getActionByName("generalHitBall").phase = Process.END;
					getActionByName("batBall").phase = Process.END;
					getActionByName("hitBall_hit").phase = Process.END; 
				}
				else if (_animation == "digBall")
				{
					getActionByName("specialHitBall").phase = Process.END;
					getActionByName("digBall").phase = Process.END;
					getActionByName("digBall_hit").phase = Process.END; 
				}
				else if (_animation == "saveBall")
				{
					getActionByName("specialHitBall").phase = Process.END;
					getActionByName("saveBall").phase = Process.END;
					getActionByName("digBall_hit").phase = Process.END; 
					
				}
				else if (_animation == "heavySmashBall")
				{
					getActionByName("specialHitBall").phase = Process.END;
					getActionByName("heavySmashBall").phase = Process.END;
					getActionByName("heavySmashBall_hit").phase = Process.END; 
				}				
				else if (_animation == "blockBall")
				{
					getActionByName("specialHitBall").phase = Process.END;
					getActionByName("blockBall").phase = Process.END;
					getActionByName("blockBall_hit").phase = Process.END; 
				}
				else if (_animation == "flatSmashBall")
				{
					getActionByName("generalHitBall").phase = Process.END;
					getActionByName("flatSmashBall").phase = Process.END;
					getActionByName("flatSmashBall_hit").phase = Process.END; 
				}

				if (_animation == "jumpBegin")
				{
					getActionByName("jumpBegin").phase = Process.END;
				}
				
				if (_animation == "throwBall")
				{
					getActionByName("throwBall").phase = Process.END;
				}
				
				if (_animation == "throwBallJump")
				{
					getActionByName("throwBallJump").phase = Process.END;
				}
			}
			
			
			//**********************************************************
			//跳跃结束
			//**********************************************************
			
			//##############################################################
			//根据状态而改变的命令
					
			
			
			if (_animation == "heavySmashBall" && _onGround)
			{
				//getActionByName("specialHitBall").phase = Process.END;
				getActionByName("heavySmashBall").phase = Process.END;
				//getActionByName("digBall").phase = Process.BEGIN;
			}
			
			if (_animation == "blockBall" && _onGround)
			{
				//getActionByName("specialHitBall").phase = Process.END;
				getActionByName("blockBall").phase = Process.END;
				//getActionByName("digBall").phase = Process.BEGIN;
			}
			
			if (_animation == "flatSmashBall" && _onGround)
			{
				//getActionByName("generalHitBall").phase = Process.END;
				getActionByName("flatSmashBall").phase = Process.END;
				//getActionByName("batBall").phase = Process.BEGIN;
			}
			
			if (_animation == "batBall" && !_onGround)
			{
				//getActionByName("generalHitBall").phase = Process.END;
				getActionByName("batBall").phase = Process.END;
				getActionByName("flatSmashBall").phase = Process.BEGIN;
			}
			
			if (_animation == "digBall" && !_onGround)
			{
				//getActionByName("specialHitBall").phase = Process.END;
				getActionByName("digBall").phase = Process.END;
				
				
				
				if (_blockBallBool)
				{
					getActionByName("blockBall").phase = Process.BEGIN;
				}
				else
				{
					getActionByName("heavySmashBall").phase = Process.BEGIN;
				}
			}
			
			if (_animation == "saveBall" && !_onGround)
			{
				//getActionByName("generalHitBall").phase = Process.END;
				getActionByName("saveBall").phase = Process.END;
		
				if (_blockBallBool)
				{
					getActionByName("blockBall").phase = Process.BEGIN;
				}
				else
				{
					getActionByName("heavySmashBall").phase = Process.BEGIN;
				}
			}
			
			if (_animation == "digBall" && _ce.input.isDoing(inputName["left"]) && !_digBallDelayBool)
			{
				if (_control == "keyboard")
				{
					//trace("动作转换");
				}
				getActionByName("digBall").phase = Process.END;
				getActionByName("saveBall").phase = Process.BEGIN;
			}
			
			if (_animation == "saveBall" && _ce.input.isDoing(inputName["right"]) && !_saveBallDelayBool)
			{
				if (_control == "keyboard")
				{
					//trace("动作转换");
				}
				getActionByName("saveBall").phase = Process.END;
				getActionByName("digBall").phase = Process.BEGIN;
			}
			
			if (_animation == "throwBall" && !_onGround)
			{
				getActionByName("throwBall").phase = Process.END;
			}
			
			if (_animation == "throwBallJump" && !_onGround)
			{
				getActionByName("throwBallJump").phase = Process.END;
			}
			
			
			if (/*_onGround && */!_rise)
			{				
				getActionByName("jump").phase = Process.END;				
				getActionByName("secondJump").phase = Process.END;
			}
			
			
			
			if (getActionByName("digBall").phase == Process.END)
			{
				_digBallDelayBool = false;
			}
			
			if (getActionByName("saveBall").phase == Process.END)
			{
				_saveBallDelayBool = false;
			}
			
			/*if (match.serveProcess == Match.SERVE_END)
			{
				getActionByName("serve").phase = Process.END;
			}*/
			
			//##############################################################
			
			//*******************************************************
			//Action执行****************************************************
			//*******************************************************
			
			
			
			//#######################################################
			//trace(getActionByName("jump").phase);
			
			if (getActionByName("jumpBegin").phase == Process.BEGIN)
			{
				//setTimeout(jump, 1000);
				jump();
			}
			
			if (getActionByName("jump").phase == Process.BEGIN)
			{
				velocity.y = -jumpHeight;
				onJump.dispatch();
			}
			
			if (getActionByName("secondJump").phase == Process.BEGIN)
			{
				velocity.y = -secondJumpHeight;
				onSecondJump.dispatch();
				particleJump1.play();
			}

			if (getActionByName("jumpAccelerate").phase == Process.ON)
			{
				//velocity.y -= jumpAcceleration;
				_body.m_customGravity.y = 10;
			}
			else
			{
				_body.m_customGravity.y = 18;
			}
			
			
			
			//update physics with new velocity
			_body.SetLinearVelocity(velocity);

			
			//trace(getActionByName("heavySmashBall").phase);
			
			
			if (getStateByName("inScope").phase == Process.END)
			{
				Camera.openTimeScaleGate();
			}
			
			/*if (_inScope)
			{
				if (getActionByName("heavySmashBall").phase == Process.ON)
				{
					
				}			
				if (getActionByName("flatSmashBall").phase == Process.ON)
				{
					cameraChange("flatSmashBall");
				}
			}
			
			
			
			if (getActionByName("batBall").phase == Process.BEGIN)
			{
				//cameraChange("batBall");
			}
			if (getActionByName("digBall").phase == Process.BEGIN)
			{
				//cameraChange("digBall");
			}*/
			
			/*if (getActionByName("heavySmashBall").phase == Process.END 
			|| getActionByName("flatSmashBall").phase == Process.END
			|| getActionByName("batBall").phase == Process.END
			|| getActionByName("digBall").phase == Process.END)
			{
				cameraChange("null");
			}*/
			
			if (getActionByName("generalHitBall").phase == Process.BEGIN || getActionByName("specialHitBall").phase == Process.BEGIN)
			{
				
				if (_onGround)
				{
					//setTimeout(particleHandHit1.play, 200);
				}
				else
				{
					setTimeout(particleHandHit1.play, 300);
					//setTimeout(particleHandHit2.play, 200);
				}
			}
			
			if (getStateByName("loseBall").phase == Process.BEGIN)
			{
				onLose.dispatch();
			}
		}
		
		private var _drop:Boolean = false;
		private var _moveLeft:Boolean = false;
		private var _moveRight:Boolean = false;
		private var _moveLeftGen:Boolean = false;
		private var _moveRightGen:Boolean = false;
		private var _moveLeftAcc:Boolean = false;
		private var _moveRightAcc:Boolean = false;
		
		private var _stop:Boolean = false;
		 
		private var _inScope:Boolean = false;
		
		override protected function updateStates():void
		{
			super.updateStates();
			
			_walkingSpeed = walkingSpeed;
			//Logic.stateCondition(getStateByName("rise"), );
			
			_rise = false;
			
			if (_linearVelocity.y < 0)
			{
				_rise = true;
			}
			
			_drop = _linearVelocity.y > 0 ? true:false;
			_moveLeft = _walkingSpeed < -acceleration ? true:false;
			_moveRight = _walkingSpeed > acceleration ? true:false;
			
			_moveLeftGen = _walkingSpeed < -acceleration && _walkingSpeed >= -velocityVec.x ? true:false;
			_moveRightGen = _walkingSpeed > acceleration && _walkingSpeed <= velocityVec.x ? true:false;
			
			_moveLeftAcc = _walkingSpeed < -velocityVec.x;
			_moveRightAcc = _walkingSpeed > velocityVec.x;
			
			_stop = _walkingSpeed > -acceleration && _walkingSpeed < acceleration;
			
			
			/*Logic.stateCondition(getStateByName("drop"), _linearVelocity.y > 0);
			Logic.stateCondition(getStateByName("moveLeft"), _walkingSpeed < -acceleration);
			Logic.stateCondition(getStateByName("moveRight"), _walkingSpeed > acceleration);
			
			Logic.stateCondition(getStateByName("moveLeftGen"), _walkingSpeed < -acceleration && _walkingSpeed >= -velocityVec.x);
			Logic.stateCondition(getStateByName("moveRightGen"), _walkingSpeed > acceleration && _walkingSpeed <= velocityVec.x);
			
			Logic.stateCondition(getStateByName("moveLeftAcc"), _walkingSpeed < -velocityVec.x);
			Logic.stateCondition(getStateByName("moveRightAcc"), _walkingSpeed > velocityVec.x);
			
			Logic.stateCondition(getStateByName("stop"), _walkingSpeed > -acceleration && _walkingSpeed < acceleration);*/
		
			var _playerCenter:int = _invertedBody ? x + 10 : x - 10;
			
			if (_hitBall)
			{
				_inScope = false;
				
				if (_invertedViewAndBody ? _hitBall.x < StageConst.stageWidth * 0.5 : _hitBall.x > StageConst.stageWidth * 0.5)
					_inScope = true;
				
				_heavySmashBallBool = false;
				_ballIsLeft = false;
				_ballIsLeftRange = false;
				_ballIsLeftOver = false;
				
				_ballIsRight = false;
				_ballIsRightRange = false;
				_ballIsRightOver = false;
				
				_ballIsMiddle = false;
				_ballIsJumpMiddle = false;
				
				_ballIsBack = false;
				_ballIsForward = false;
				
				
				_holdBallBool = false;
				_throwBallBool = false;
				_waitBallBool = false;
				_serveOnBool = false;
				
				_blockBallBool = false;
				
				
				if (_inScope)
				{
					if (_hitBall.x < StageConst.stageWidth / 2 + _heavySmashBallExtent && _hitBall.x > StageConst.stageWidth / 2 - _heavySmashBallExtent)
					{
						_heavySmashBallBool = true;
					}
					
					if (_hitBall.x <= _playerCenter)
					{
						_ballIsLeft = true;
						
						if (_invertedViewAndBody)
						{
							_ballIsBack = true;
						}
						else
						{
							_ballIsForward = true;
						}
						
						if (_hitBall.x <= _playerCenter - 20)
						{
							_ballIsLeftRange = true;
							
							if (_hitBall.x <= _playerCenter - 80)
							{
								_ballIsLeftOver = true;
							}
						}
						else
						{
							_ballIsMiddle = true;
						}
						
						if (_hitBall.x > _playerCenter - 35)
						{
							_ballIsJumpMiddle = true;
						}
					}
					else
					{
						_ballIsRight = true;
						
						if (_invertedViewAndBody)
						{							
							_ballIsForward = true;
						}
						else
						{
							_ballIsBack = true;
						}
						
						if (_hitBall.x > _playerCenter + 20)
						{
							_ballIsRightRange = true;
							
							if (_hitBall.x > _playerCenter + 80)
							{
								_ballIsRightOver = true;
							}
						}
						else
						{
							_ballIsMiddle = true;
						}
						
						if (_hitBall.x <= _playerCenter + 35)
						{
							_ballIsJumpMiddle = true;
						}
					}
					
					
					
					if (match)
					{
					
						if (match.serveProcess == Match.SERVE_ON)
						{
							_serveOnBool = true;
							if (_hitBall.y > y - height * 0.2)
							{
								_holdBallBool = true;
							}
							else if (_hitBall.y > y - height * 0.6)
							{
								_throwBallBool = true;
							}
							else
							{
								_waitBallBool = true;
							}
						}
					}
				}
				else
				{
					_ballIsForward = true;
				}
				
				
				if (x > StageConst.stageWidth / 2 - _blockBallExtent && x < StageConst.stageWidth / 2 + _blockBallExtent)
				{
					_blockBallBool = true;
				}
				
				
				
				Logic.stateCondition(getStateByName("ballOnGround"), _hitBall.getStateByName("touchGround").phase > 0);
				Logic.stateCondition(getStateByName("loseBall"), _hitBall.getStateByName("inLoseExtent").phase > 0 && _inScope);
				
				Logic.stateCondition(getStateByName("ballRise"), _hitBall.getStateByName("rise").phase > 0);
								
				Logic.stateCondition(getStateByName("holdBallExtent"), _hitBall.body.GetPosition().y > _body.GetPosition().y - _height * 0.3 /*&& _hitBall.body.GetPosition().y < _body.GetPosition().y*/);
				Logic.stateCondition(getStateByName("throwBallExtent"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.3 && _hitBall.body.GetPosition().y > _body.GetPosition().y - _height * 0.8);
				Logic.stateCondition(getStateByName("waitBallExtent"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.8);
				
				
				_jumpHitExtent = false;
				if (_hitBall.y < y - height * 1.5 && _hitBall.y > 70)
				{
					_jumpHitExtent = true;
				}
				
			}
			
			if (!getStateByName("hitAreaTouchBall").phase)
			{
				_hand2Hited = false;
			}
		}
		
		override public function destroy():void
		{
			_box2D.world.DestroyJoint(hitAreaJoint);
			_box2D.world.DestroyBody(hitAreaBody);
			_box2D.world.DestroyBody(moveAreaBody);
			_box2D.world.DestroyJoint(moveAreaJoint);
			super.destroy();
		}
		
		override protected function createShape():void
		{
			super.createShape();
			
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.3);
			hitAreaShape = EasyBox2D.createCircleShape(hitAreaRadius);
			moveAreaShape = EasyBox2D.createCircleShape(moveAreaRadius);
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			hitAreaBodyDef = EasyBox2D.defineBody(hitAreaBodyDef, hitAreaPosition, 0, 2, this);
			moveAreaBodyDef = EasyBox2D.defineBody(moveAreaBodyDef, moveAreaPosition, 0, 2, this);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
			_body.m_customGravity = new b2Vec2(0, 20);
			
			//setTimeScale(1);
	
			hitAreaBody = EasyBox2D.createBody(_box2D.world, hitAreaBodyDef);
			hitAreaBody.beginContactHanlder = hitAreaBeginContactHanlder;
			hitAreaBody.endContactHanlder = hitAreaEndContactHanlder;
			
			moveAreaBody = EasyBox2D.createBody(_box2D.world, moveAreaBodyDef);
			moveAreaBody.beginContactHanlder = moveAreaBeginContactHanlder;
			moveAreaBody.endContactHanlder = moveAreaEndContactHanlder;
		}
		
		override protected function beginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			super.beginContactHanlder(selfBody, contactedBody);
			
			if (contactedBody.GetUserData() is Ground)
			{
				_onGround = true;
			}
		}
		
		override protected function endContactHandlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			super.endContactHandlder(selfBody, contactedBody);
			
			if (contactedBody.GetUserData() is Ground)
			{
				_onGround = false;
			}
		}
		
		private var _moveAreaTouchBall:Boolean = false;
		private function moveAreaBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			moveAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				_moveAreaTouchBall = true;
			}
		}
		
		private function moveAreaEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			moveAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				_moveAreaTouchBall = false;
			}
		}
		
		private var _hitAreaTouchBall:Boolean = false;
		private function hitAreaBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			
			hitAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				_hitAreaTouchBall = true;
			}
		}
		
		private function hitAreaEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			hitAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				_hitAreaTouchBall = false;
			}
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			if (_collider is Wall)
			{
				//getStateByName("touchWall").phase = Process.BEGIN;
			}
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
			if (_collider is Wall)
			{
				//getStateByName("touchWall").phase = Process.END;
			}
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.restitution = 0;
			hitAreaFixtureDef = EasyBox2D.defineFixture(hitAreaFixtureDef, hitAreaShape, 0.01, 0.2, 0.0, PhysicsCollisionCategories.Get("PlayerSensor"), PhysicsCollisionCategories.Get("Ball"), true);
			moveAreaFixtureDef = EasyBox2D.defineFixture(moveAreaFixtureDef, moveAreaShape, 0.01, 0.2, 0.0, PhysicsCollisionCategories.Get("PlayerSensor"), PhysicsCollisionCategories.Get("Ball"), true);
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			hitAreaFixture = EasyBox2D.createFixture(hitAreaBody, hitAreaFixtureDef);
			moveAreaFixture = EasyBox2D.createFixture(moveAreaBody, moveAreaFixtureDef)
		}
		
		override protected function defineJoint():void
		{
			super.defineJoint();
			hitAreaJointDef = EasyBox2D.defineWeldJoint(hitAreaJointDef, _body, hitAreaBody, anchorPosition);
			moveAreaJointDef = EasyBox2D.defineWeldJoint(moveAreaJointDef, _body, moveAreaBody, anchorPosition);
		}
		
		override protected function createJoint():void
		{
			super.createJoint();
			hitAreaJoint = EasyBox2D.createJoint(_box2D.world, hitAreaJointDef);
			moveAreaJoint = EasyBox2D.createJoint(_box2D.world, moveAreaJointDef);
		}
		
		/**
		 * Returns the absolute walking speed, taking moving platforms into account.
		 * Isn't super performance-light, so use sparingly.
		 */
		public function get walkingSpeed():Number
		{
			var groundVelocityX:Number = 0;
			for each (var groundContact:b2Fixture in _groundContacts)
			{
				groundVelocityX += groundContact.GetBody().GetLinearVelocity().x;
			}
			
			return _body.GetLinearVelocity().x - groundVelocityX;
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			super.handlePreSolve(contact, oldManifold);
		}
		
		public function get opponent():Player
		{
			return _opponent;
		}
		
		public function set opponent(value:Player):void
		{
			_opponent = value;
		}
		
		public function get hitBall():Ball
		{
			return _hitBall;
		}
		
		public function set hitBall(value:Ball):void
		{
			_hitBall = value;
		}
		
		public function get onGround():Boolean 
		{
			return _onGround;
		}
	}
}