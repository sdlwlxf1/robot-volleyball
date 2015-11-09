package test2.gameObjects
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
	import test2.assets.Assets;
	import test2.data.BallFlipData;
	import test2.data.PlayerData;
	import test2.logic.Action;
	import test2.logic.gameLogic.Match;
	import test2.logic.Logic;
	import test2.logic.Process;
	import test2.logic.State;
	import test2.math.MathMatrix22;
	import test2.math.MathUtils;
	import test2.math.MathVector;
	import test2.state.MatchState;
	import test2.utils.EasyBox2D;
	
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
		public var onLose:Signal;
		public var onHit:Signal;
		public var onAnimationChange:Signal;
		
		private var maxVelocity:Number
		private var velocityVec:b2Vec2
		private var jumpHeight:Number;
		private var jumpAcceleration:Number;
		private var powerA:Number;
		public var powerMax:Number;
		private var serveBallVec:b2Vec2;
		
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
		
		public var hand1:Hand;
		public var hand2:Hand;

		
		private var _playerData:PlayerData;
		private var autoJumpHitCount:int;
		private var autoJumpHitLimit:int = 20;
		private var _hitAreaContact:b2Contact;
		private var _playerCenter:Number;
		private var _moveAreaContact:b2Contact;
		private var _hand2Hited:Boolean;
		
		
		private var _moveRightCount:int = 0;
		private var _moveRightMax:int = 15;
		private var _moveRightCountEnable:Boolean;
		private var _moveRightAcc:Boolean;
		private var _moveLeftAcc:Boolean;
		private var _moveLeftCount:int;
		private var _moveLeftCountEnable:Boolean;
		private var _moveLeftMax:int = 15;
		
		private var ballFlipDatas:Vector.<BallFlipData>;
		
		
		private var ballFlipData:BallFlipData;
		
		public var serveBallRange:Point;
		
		
		public var particleHit1:CitrusSprite;
		public var particleHit2:CitrusSprite;
		public var particleHandHit1:CitrusSprite;
		public var particleHandHit2:CitrusSprite;
		
		public var match:Match;


		
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
			onAnimationChange = new Signal();
			onLose = new Signal();
			onHit = new Signal();
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
				serveBallVec = _playerData.serveBallVec;
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
			
			
			
			
			hitAreaRadius = height * 0.55;
			anchorPosition = new b2Vec2(_x, _y - _height / 3.5);
			hitAreaPosition = new b2Vec2(_x + _width * 0.1, _y - _height * 0.48);
			
			moveAreaRadius = height * 1.5;
			moveAreaPosition = new b2Vec2(_x, _y - _height / 2 - 0.1);
			
			ballFlipDatas = new <BallFlipData>[		
			new BallFlipData(-0.35 * Math.PI, 19),
			new BallFlipData(-0.15 * Math.PI, 19),
			new BallFlipData(0.00 * Math.PI, 22),
			new BallFlipData(0.17 * Math.PI, 30)
			];
			
			if (invertedViewAndBody == false)
			{
				for (var i:int = 0; i < ballFlipDatas.length; i++ )
				{
					ballFlipDatas[i].invert();
				}			
				MathVector.invertVector(hitAreaPosition, _x);
				
				serveBallPosition = Starling.current.stage.stageWidth - 200;				
				serveBallRange = new Point(Starling.current.stage.stageWidth - 300, Starling.current.stage.stageWidth);
			}
			else if (invertedViewAndBody == true)
			{							
				serveBallPosition = 200;				
				serveBallRange = new Point(0, 300);
			}
			
			hitBallAngleExtent = hitBallEndAngle - hitBallBeginAngle;
		}
		
		override public function update(timeDelta:Number):void
		{
			
			/*hitAreaBodyPosition.Set(_body.GetPosition().x, _body.GetPosition().y - _height / 2);	
			hitAreaBody.SetPosition(hitAreaBodyPosition);
			
			moveAreaBody.SetPosition(hitAreaBodyPosition);*/
			
			super.update(timeDelta);
		}
		
		override protected function createShape():void
		{
			super.createShape();
			
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.3);
			
			hitAreaShape = EasyBox2D.createCircleShape(hitAreaRadius);
			
			moveAreaShape = EasyBox2D.createCircleShape(moveAreaRadius);
		}
		
		override protected function updateAnimation():void
		{
			super.updateAnimation();
			
			var prevAnimation:String = _animation;
		
			/*if (getStateByName("moveAreaTouchBall").phase == Process.ON && match.roundProcess == Match.ROUND_ON)
			{
				if (!getStateByName("touchGround").phase)
				{
					if (getStateByName("rise").phase)
					{
						if (invertedViewAndBody)
						{
							if (getStateByName("moveLeft").phase)
							{
								_animation = "jumpReadyHit_b";					
							}
							else if (getStateByName("moveRight").phase)
							{					
								_animation = "jumpReadyHit_f";
							}
						}
						else
						{
							if (getStateByName("moveLeft").phase)
							{
								_animation = "jumpReadyHit_f";
							}
							else if (getStateByName("moveRight").phase)
							{
								_animation = "jumpReadyHit_b";
								
							}
						}
					}
					else
					{
						if (invertedViewAndBody)
						{
							if (getStateByName("moveLeft").phase)
							{
								_animation = "downReadyHit_b";
							}
							else if (getStateByName("moveRight").phase)
							{
								
								_animation = "downReadyHit_f";
							}
						}
						else
						{
							if (getStateByName("moveLeft").phase)
							{
								_animation = "downReadyHit_f";
							}
							else if (getStateByName("moveRight").phase)
							{
								_animation = "downReadyHit_b";
								
							}
						}
					}
				}
				else
				{
					if (getStateByName("moveLeft").phase)
					{
						if (invertedViewAndBody)
						{
							_animation = "backwardReadyHit";
						}
						else
						{
							_animation = "moveReadyHit";
							
						}
					}
					else if (getStateByName("moveRight").phase)
					{
						if (invertedViewAndBody)
						{
							_animation = "moveReadyHit";
						}
						else
						{
							_animation = "backwardReadyHit";
							
						}
					}
					else if (getStateByName("stop").phase)
					{
						
						_animation = "stopReadyHit";
					}
				}
			}
			else */
			if (!getStateByName("touchGround").phase)
			{
				if (getStateByName("rise").phase)
				{
					if (invertedViewAndBody)
					{
						if (getStateByName("moveLeft").phase)
						{
							_animation = "jump_b";
						}
						else if (getStateByName("moveRight").phase)
						{
							
							_animation = "jump_f";
						}
					}
					else
					{
						if (getStateByName("moveLeft").phase)
						{
							_animation = "jump_f";
						}
						else if (getStateByName("moveRight").phase)
						{
							_animation = "jump_b";
							
						}
					}
				}
				else
				{
					if (invertedViewAndBody)
					{
						if (getStateByName("moveLeft").phase)
						{
							_animation = "down_b";
						}
						else if (getStateByName("moveRight").phase)
						{
							
							_animation = "down_f";
						}
					}
					else
					{
						if (getStateByName("moveLeft").phase)
						{
							_animation = "down_f";
						}
						else if (getStateByName("moveRight").phase)
						{
							_animation = "down_b";
							
						}
					}
				}
			}
			else
			{
				if (getStateByName("moveLeft").phase)
				{
					if (invertedViewAndBody)
					{
						_animation = "backward";
					}
					else
					{
						_animation = "move";
						
					}
				}
				else if (getStateByName("moveRight").phase)
				{
					if (invertedViewAndBody)
					{
						_animation = "move";
					}
					else
					{
						_animation = "backward";
						
					}
				}
				else if (getStateByName("stop").phase)
				{
					_animation = "stop";
				}
			}
			
			if (canServe)
			{
				/*if (getActionByName("serve").isDoing())
				{
					_animation = animationName["throw"];
				}
				else if (getStateByName("waitBallExtent").phase > 0)
				{
					_animation = animationName["waitHit"];
				}
				else if (!getStateByName("ballRise").phase && getStateByName("throwBallExtent").phase)
				{
					_animation = animationName["backThrow"];
				}
				else if (getActionByName("takeBall").isDoing())
				{
					_animation = animationName["readyThrow"];
				}*/
			}
			
			
			/*if (getActionByName("hitHold").phase == Process.ON)
			{
				
				if (getStateByName("moveLeft").phase)
				{
					if (invertedViewAndBody)
					{
						_animation = "Hit_g_Hold_back";
					}
					else
					{
						_animation = "Hit_g_Hold_move";						
					}
				}
				else if (getStateByName("moveRight").phase)
				{
					if (invertedViewAndBody)
					{
						_animation = "Hit_g_Hold_move";	
					}
					else
					{
						_animation = "Hit_g_Hold_back";
						
					}
				}
				else if (getStateByName("stop").phase)
				{
					
					_animation = "Hit_g_Hold_stop";
				}
			}*/
			
			
			if (getActionByName("hit_right").isDoing())
			{
				if (getStateByName("touchGround").isDoing())
				{
					_animation = "hit_right_ground";
				}
				else
				{
					_animation = "hit_right_sky";
				}
			}
			
			if (getActionByName("hit_left").isDoing())
			{
				if (getStateByName("touchGround").isDoing())
				{
					_animation = "hit_left_ground";
				}
				else
				{
					_animation = "hit_left_sky";
				}
			}
		
			if (prevAnimation != _animation)
				onAnimationChange.dispatch();
		
		}
		
		private function hitLeft():void
		{
			getActionByName("hit_left").phase = Process.BEGIN;
		}
		
		private function hitRight():void
		{
			getActionByName("hit_right").phase = Process.BEGIN;
		}
		
		private function jump():void
		{
			getActionByName("jump").phase = Process.BEGIN;
		}
		
		override protected function updateActions():void
		{
			super.updateActions();
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
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
							velocity.x = velocityVec.x + 3;
						}
						else 
						{
							velocity.x = velocityVec.x
						}
						moveKeyPressed = true;
					}
					if (_ce.input.isDoing(inputName["left"]))
					{
						//velocity.Subtract(getSlopeBasedMoveAngle());
						if (_moveLeftAcc)
						{
							velocity.x = -velocityVec.x - 3;
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
					if (getStateByName("touchGround").phase && _ce.input.isDoing(inputName["jump"]))
					{
						
						jump();
					}
					
					if (_ce.input.isDoing(inputName["jump"]) && !getStateByName("touchGround").phase && velocity.y < 0)
					{
						velocity.y -= jumpAcceleration;
					}
				}
				
				if (canServe)
				{
					if (getStateByName("takeBallExtent").phase)
					{
						canJump = false;
						
						if (_ce.input.justDid(inputName["hitRight"]) || _ce.input.justDid(inputName["hitLeft"]))
						{
							_hitBall.body.SetLinearVelocity(serveBallVec);
							getActionByName("takeBall").phase = Process.END;
							getActionByName("serve").phase = Process.BEGIN;
						}
						
						if (!getStateByName("ballRise").phase)
						{
							getActionByName("takeBall").phase = Process.BEGIN;
							_hitBall.x = _invertedViewAndBody ? x + width : x - width;
							_hitBall.y = y - height * 0.18;
							_hitBall.body.SetAngle(0);
						}
					}
					else
					{
						canJump = true;
						if (_ce.input.justDid(inputName["hitRight"]))
						{
							hitRight();
						}
						else if (_ce.input.justDid(inputName["hitLeft"]))
						{
							hitLeft();
						}
					}
					if ((!_ce.input.isDoing(inputName["hitRight"])) && (!_ce.input.isDoing(inputName["hitLeft"])))
					{
						getActionByName("serve").phase = Process.END;
					}
				}
				
				if (canHit)
				{
					
					if (_ce.input.justDid(inputName["hitRight"]))
					{
						hitRight();
						power = 0;
						powerV = 0;
					}
					else if (_ce.input.justDid(inputName["hitLeft"]))
					{
						hitLeft();
						power = 0;
						powerV = 0;
					}
					else if (_ce.input.isDoing(inputName["hitRight"]) || _ce.input.isDoing(inputName["hitLeft"]))
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
			}
			else if (_control == "auto")
			{
				if (canAutoMove)
				{
					var moveAutoActived:Boolean = false;

					if(canAutoMoveToServeBallPosititon)
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
					
					if (canAutoMoveToBall)
					{
						if (getStateByName("inScope").phase)
						{
							if (getStateByName("ballIsRightRange").phase)
							{
								//velocity.Add(getSlopeBasedMoveAngle());
								if (getStateByName("ballIsRightOver").phase)
								{
									velocity.x = velocityVec.x + 3;
								}
								else
								{
									velocity.x = velocityVec.x;
								}
								moveAutoActived = true;
							}
							
							if (getStateByName("ballIsLeftRange").phase)
							{
								//velocity.Subtract(getSlopeBasedMoveAngle());
								if (getStateByName("ballIsLeftOver").phase)
								{
									velocity.x = -velocityVec.x - 3;
								}
								else
								{
									velocity.x = -velocityVec.x;
								}
								moveAutoActived = true;
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
					velocity.SetZero();
					_fixture.SetFriction(_friction); //Add friction so that he stops running
				}
				
				if (canAutoHit)
				{
					if (getStateByName("hitAreaTouchBall").phase/* == Process.BEGIN*/)
					{
						hitRight();
					}
				}

				if (canAutoJump)
				{
					if (getStateByName("ballIsMiddle").phase == Process.ON)
					{
						autoJumpHitCount++;
						if (autoJumpHitCount > autoJumpHitLimit)
						{
							if (getStateByName("jumpHitExtent").phase)
							{
								jump();
							}
							autoJumpHitCount = 0;
						}
					}
					else
					{
						autoJumpHitCount = 0;
					}
				}
				
			}
			
			if (getActionByName("jump").phase == Process.BEGIN)
			{
				velocity.y = -jumpHeight;
				onJump.dispatch();
			}
			
			if (getStateByName("touchGround").phase)
			{
				getActionByName("jump").phase = Process.END;
			}
			
			//update physics with new velocity
			_body.SetLinearVelocity(velocity);
			
			
			
			
			
			if (getActionByName("hit_left").phase == Process.BEGIN)
			{
				if (getStateByName("touchGround").phase)
				{
					getActionByName("hit_left_ground").phase = Process.BEGIN;
				}
				else
				{
					getActionByName("hit_left_sky").phase = Process.BEGIN;
				}
			}
			
			if (getActionByName("hit_right").phase == Process.BEGIN)
			{
				if (getStateByName("touchGround").phase)
				{
					getActionByName("hit_right_ground").phase = Process.BEGIN;
				}
				else
				{
					getActionByName("hit_right_sky").phase = Process.BEGIN;
				}
			}
			
			if ((view as Armature).animation.isComplete)
			{
				if (_animation == "hit_left_ground")
				{
					getActionByName("hit_left").phase = Process.END;
					getActionByName("hit_left_ground").phase = Process.END;
				}
				else if (_animation == "hit_left_sky")
				{
					getActionByName("hit_left").phase = Process.END;
					getActionByName("hit_left_sky").phase = Process.END;
				}
				
				if (_animation == "hit_right_ground")
				{
					getActionByName("hit_right").phase = Process.END;
					getActionByName("hit_right_ground").phase = Process.END;
				}
				else if (_animation == "hit_right_sky")
				{
					getActionByName("hit_right").phase = Process.END;
					getActionByName("hit_right_sky").phase = Process.END;
				}
			}
			
			if (_animation == "hit_left_sky" && getStateByName("touchGround").isDoing())
			{
				getActionByName("hit_left").phase = Process.END;
				getActionByName("hit_left_sky").phase = Process.END;
			}
			
			if (_animation == "hit_right_sky" && getStateByName("touchGround").isDoing())
			{
				getActionByName("hit_right").phase = Process.END;
				getActionByName("hit_right_sky").phase = Process.END;
			}
	
			if (_animation == "hit_right_ground"/*getActionByName("generalHit").isDoing()*/)
			{				
				if (hand2.getStateByName("touchBall").phase/* && !_hand2Hited*/)
				{		
					ballFlipData = ballFlipDatas[0];
					
					ballFlipDirection.SetV(ballFlipData.vec);
					
					ballFlipDirection.Multiply(ballFlipData.power + power + (_invertedViewAndBody?_linearVelocity.x * 1.5:-_linearVelocity.x * 1.5));
			
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
					
					
					
					onHit.dispatch();
					_hand2Hited = true;
				}
			}
			
			else if (_animation == "hit_right_sky"/*getActionByName("jumpHit").isDoing()*/)
			{
				
				if (hand1.getStateByName("touchBall").phase)
				{
					
					(_ce.state as MatchState).shakeAnimation.lastTime = 200;
					(_ce.state as MatchState).shakeAnimation.startShake();
					
					ballFlipData = ballFlipDatas[2];
					
					ballFlipDirection.SetV(ballFlipData.vec);
					
					ballFlipDirection.Multiply(ballFlipData.power + power + (_invertedViewAndBody?_linearVelocity.x * 1.5:-_linearVelocity.x * 1.5));
			
					_hitBall.body.SetLinearVelocity(ballFlipDirection);
					
					particleHit2.x = _hitBall.x;
					particleHit2.y = _hitBall.y;
				
					(particleHit2.view as MovieClip).currentFrame = 0;
					(particleHit2.view as MovieClip).play();
					
					
					
					onHit.dispatch();
					_hand2Hited = true;
					
					
					onHit.dispatch();
				}
			}			
			else if (_animation == "hit_left_ground"/*getActionByName("generalHit").isDoing()*/)
			{				
				if (hand1.getStateByName("touchBall").phase/* && !_hand2Hited*/)
				{					
					/*(_ce.state as MatchState).shakeAnimation.lastTime = 100;
					(_ce.state as MatchState).shakeAnimation.startShake();*/
					
					ballFlipData = ballFlipDatas[1];
					
					ballFlipDirection.SetV(ballFlipData.vec);
					
					ballFlipDirection.Multiply(ballFlipData.power + power + (_invertedViewAndBody?_linearVelocity.x * 1.5:-_linearVelocity.x * 1.5));
			
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
					
					
					
					onHit.dispatch();
					_hand2Hited = true;
					
					
					
					onHit.dispatch();
					_hand2Hited = true;
				}
			}
			else if (_animation == "hit_left_sky"/*getActionByName("jumpHit").isDoing()*/)
			{
				
				if (hand1.getStateByName("touchBall").phase)
				{
					
					(_ce.state as MatchState).shakeAnimation.lastTime = 200;
					(_ce.state as MatchState).shakeAnimation.startShake();
					
					ballFlipData = ballFlipDatas[3];
					
					ballFlipDirection.SetV(ballFlipData.vec);
					
					ballFlipDirection.Multiply(ballFlipData.power + power + (_invertedViewAndBody?_linearVelocity.x * 1.5:-_linearVelocity.x * 1.5));
			
					_hitBall.body.SetLinearVelocity(ballFlipDirection);
					
					particleHit2.x = _hitBall.x;
					particleHit2.y = _hitBall.y;
				
					(particleHit2.view as MovieClip).currentFrame = 0;
					(particleHit2.view as MovieClip).play();
					
					
					onHit.dispatch();
				}
			}
			
			if (getActionByName("hit_right").phase == Process.BEGIN || getActionByName("hit_left").phase == Process.BEGIN)
			{
			
				if (getStateByName("touchGround").phase)
				{
					setTimeout( setParticleHandHit1, 200);
				}
				else 
				{
					setTimeout( setParticleHandHit1, 100);
					setTimeout( setParticleHandHit2, 200);
				}
				
				
				function setParticleHandHit1():void
				{
					particleHandHit1.y = y - height / 2 - 10;
					
					if (_invertedViewAndBody)
					{
						particleHandHit1.x = x + width / 2 + 10;
						(particleHandHit1.view as MovieClip).scaleX = 1;
					}
					else
					{
						particleHandHit1.x = x - width / 2 + 10;
						(particleHandHit1.view as MovieClip).scaleX = -1;
					}
					(particleHandHit1.view as MovieClip).currentFrame = 0;
					(particleHandHit1.view as MovieClip).play();
				}
				
				function setParticleHandHit2():void
				{
					particleHandHit2.y = y - height / 2 - 10;
					
					if (_invertedViewAndBody)
					{
						particleHandHit2.x = x + width / 2 + 10;
						(particleHandHit2.view as MovieClip).scaleX = 1;
					}
					else
					{
						particleHandHit2.x = x - width / 2 + 10;
						(particleHandHit2.view as MovieClip).scaleX = -1;
					}
					(particleHandHit2.view as MovieClip).currentFrame = 0;
					(particleHandHit2.view as MovieClip).play();
				}
			}
			
			
			if (getStateByName("loseBall").phase == Process.BEGIN)
			{
				onLose.dispatch();
			}
		}

		
		override protected function updateStates():void
		{
			super.updateStates();
			
			_walkingSpeed = walkingSpeed;
			Logic.stateCondition(getStateByName("rise"), _linearVelocity.y < 0);
			Logic.stateCondition(getStateByName("drop"), _linearVelocity.y > 0);
			Logic.stateCondition(getStateByName("moveLeft"), _walkingSpeed < -acceleration);
			Logic.stateCondition(getStateByName("moveRight"), _walkingSpeed > acceleration);
			Logic.stateCondition(getStateByName("stop"), _walkingSpeed > -acceleration && _walkingSpeed < acceleration);
			
			_playerCenter = _invertedBody?x + 10:x - 10;
			
			
			if (_hitBall)
			{
				Logic.stateCondition(getStateByName("inScope"), _invertedViewAndBody ? _hitBall.body.GetPosition().x < Starling.current.stage.stageWidth * 0.5 / 30 : _hitBall.body.GetPosition().x > Starling.current.stage.stageWidth * 0.5 / 30);
				
				getStateByName("ballIsLeft").phase = Process.END;
				getStateByName("ballIsLeftRange").phase = Process.END;
				getStateByName("ballIsLeftOver").phase = Process.END;			
				
				
				getStateByName("ballIsRight").phase = Process.END;
				getStateByName("ballIsRightRange").phase = Process.END;
				getStateByName("ballIsRightOver").phase = Process.END;
				
				getStateByName("ballIsMiddle").phase = Process.END;
				
				if (getStateByName("inScope").phase)
				{
					if (_hitBall.x <= _playerCenter)
					{
						getStateByName("ballIsLeft").phase = Process.BEGIN;
						
						if (_hitBall.x <= _playerCenter - 20)
						{
							getStateByName("ballIsLeftRange").phase = Process.BEGIN;
							
							if (_hitBall.x <= _playerCenter - 200)
							{
								getStateByName("ballIsLeftOver").phase = Process.BEGIN;
							}
						}
						else
						{
							
							getStateByName("ballIsMiddle").phase = Process.BEGIN;
						}
					}
					else
					{
						
						getStateByName("ballIsRight").phase = Process.BEGIN;
						
						if (_hitBall.x > _playerCenter + 20)
						{
							getStateByName("ballIsRightRange").phase = Process.BEGIN;
							
							if (_hitBall.x > _playerCenter + 200)
							{
								getStateByName("ballIsRightOver").phase = Process.BEGIN;
							}
						}
						else
						{
							getStateByName("ballIsMiddle").phase = Process.BEGIN;
						}
					}
				}
				
				Logic.stateCondition(getStateByName("ballOnGround"), _hitBall.getStateByName("touchGround").phase > 0);
				Logic.stateCondition(getStateByName("loseBall"), _hitBall.getStateByName("inLoseExtent").phase > 0 && getStateByName("inScope").phase > 0);
				
				Logic.stateCondition(getStateByName("ballRise"), _hitBall.getStateByName("rise").phase > 0);
				Logic.stateCondition(getStateByName("takeBallExtent"), _hitBall.body.GetPosition().y > _body.GetPosition().y - _height * 0.3 && _hitBall.body.GetPosition().y < _body.GetPosition().y);
				Logic.stateCondition(getStateByName("throwBallExtent"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.3 && _hitBall.body.GetPosition().y > _body.GetPosition().y - _height * 0.8);
				Logic.stateCondition(getStateByName("waitBallExtent"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.8);
				
				Logic.stateCondition(getStateByName("jumpHitExtent"), _hitBall.body.GetPosition().y > _body.GetPosition().y - jumpHeight && _hitBall.body.GetPosition().y < _body.GetPosition().y - _height);
					//Logic.stateCondition(getStateByName("takeBallExtentX"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.8);
			}
			
			if (y > Starling.current.stage.stageHeight * 0.8)
			{
				getStateByName("touchGround").phase = Process.BEGIN;
			}
			else
			{
				getStateByName("touchGround").phase = Process.END;
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
				getStateByName("touchGround").phase = Process.BEGIN;
			}
		}
		
		override protected function endContactHandlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			super.endContactHandlder(selfBody, contactedBody);
			
			if (contactedBody.GetUserData() is Ground)
			{
				getStateByName("touchGround").phase = Process.END;
			}
		}
		
		private function moveAreaBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			moveAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("moveAreaTouchBall").phase = Process.BEGIN;
			}
		}
		
		private function moveAreaEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			moveAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("moveAreaTouchBall").phase = Process.END;
			}
		}
		
		private function hitAreaBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			
			hitAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("hitAreaTouchBall").phase = Process.BEGIN;
			}
		}
		
		private function hitAreaEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			hitAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("hitAreaTouchBall").phase = Process.END;
			}
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			if (_collider is Wall)
			{
				getStateByName("touchWall").phase = Process.BEGIN;
			}
			/*if (_collider is Ground)
			{
				getStateByName("touchGround").phase = Process.BEGIN;
			}*/		
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
			if (_collider is Wall)
			{
				getStateByName("touchWall").phase = Process.END;
			}
			/*if (_collider is Ground)
			{
				getStateByName("touchGround").phase = Process.END;
			}*/
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.restitution = 0.2;
			hitAreaFixtureDef = EasyBox2D.defineFixture(hitAreaFixtureDef, hitAreaShape, 0.01, 0.2, 0.0, PhysicsCollisionCategories.Get("PlayerSensor"), PhysicsCollisionCategories.Get("Ball"), true);
			moveAreaFixtureDef = EasyBox2D.defineFixture(moveAreaFixtureDef, moveAreaShape, 0.01, 0.2, 0.0, PhysicsCollisionCategories.Get("PlayerSensor2"), PhysicsCollisionCategories.Get("Ball"), true);
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
	}
}