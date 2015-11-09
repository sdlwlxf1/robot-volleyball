package test2
{
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
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
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Hero;
	import dragonBones.Armature;
	import dragonBones.Bone;
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.deg2rad;
	import test2.assets.Assets;
	import test2.logic.Action;
	import test2.logic.Logic;
	import test2.logic.Process;
	import test2.logic.State;
	import test2.math.MathMatrix22;
	import test2.math.MathUtils;
	import test2.math.MathVector;
	
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.utils.EasyBox2D;
	
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
		public var distance:Number = 1;
		public var anchorPosition:b2Vec2;
		
		private var _playerMovingHero:Boolean;
		
		public var onJump:Signal;
		public var onLose:Signal;
		public var onHit:Signal;
		public var onAnimationChange:Signal;
		

		/**
		 * This is the fastest speed that the DynamicObject can move left or right.
		 */
		[Inspectable(defaultValue="8")]
		public var maxVelocity:Number = 8;
		
		/**
		 * This is the fastest speed that the DynamicObject can move left or right.
		 */
		[Inspectable(defaultValue="(8, 0)")]
		public var velocityVec:b2Vec2 = new b2Vec2(5, 0);
		
		[Inspectable(defaultValue="(3, 0)")]
		public var velocityJumpVec:b2Vec2 = new b2Vec2(6, 0);
		
		/**
		 * This is the initial velocity that the DynamicObject will move at when he jumps.
		 */
		[Inspectable(defaultValue="11")]
		public var jumpHeight:Number = 16;
		
		/**
		 * This is the amount of "float" that the DynamicObject has when the player holds the jump button while jumping.
		 */
		[Inspectable(defaultValue="0.3")]
		public var jumpAcceleration:Number = 0.4;
		


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
		private var upperHandMaxAngle:Number;
		private var upperHandMinAngle:Number;
		
		private var upperHandAngularVelocity:Number;
		private var upperHandBeginHitAngle:Number;
		private var upperHandEndHitAngle:Number;
		private var upperHandBackAngle:Number;
		
		//击球后弹出角度参数
		private var hitBallAngleExtent:Number;
		private var hitBallBeginAngle:Number;
		private var hitBallEndAngle:Number;
		private var hitBallAngleLength:Number;
		private var hitBallAngleAccuracy:Number;
		
		//手臂刚体相关参数
		private var upperHandShapeWidth:Number = 10;
		private var upperHandShapeHeight:Number = 75;
		private var upperHandShapeAngle:Number = 0;
		private var upperHandBodyDef:b2BodyDef = new b2BodyDef;
		private var upperHandBody:b2Body;
		private var upperHandShape:b2Shape;
		private var upperHandFixtureDef:b2FixtureDef = new b2FixtureDef;
		private var upperHandFixture:b2Fixture;
		private var upperHandJoint:b2Joint;
		private var upperHandRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef;
		private var upperHandContactedBody:b2Body;
		private var upperHandPosition:b2Vec2;
		
		//手臂刚体相关参数
		private var underHandShapeWidth:Number = 10;
		private var underHandShapeHeight:Number = 66;
		private var underHandAngle:Number;
		private var underHandShapeAngle:Number = 0;
		private var underHandBodyDef:b2BodyDef = new b2BodyDef;
		private var underHandBody:b2Body;
		private var underHandShape:b2Shape;
		private var underHandFixtureDef:b2FixtureDef = new b2FixtureDef;
		private var underHandFixture:b2Fixture;
		private var underHandJoint:b2Joint;
		private var underHandWeldJointDef:b2WeldJointDef = new b2WeldJointDef;
		private var underHandContactedBody:b2Body;
		private var underHandPosition:b2Vec2;
		
		//击球感应区相关参数
		private var hitAreaRadius:Number = 64;
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
		private var moveAreaHeight:Number = 100;
		private var moveAreaWidth:Number = 100;
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
		
		private var _serveBallVec:b2Vec2 = new b2Vec2(0, -13);
		public var serveBallPosition:Number;
		
		private var upperHandView:DisplayObject;
		private var upperHandBodyPosition:b2Vec2 = new b2Vec2();
		
		public var power:Number = 0;
		private var powerV:Number = 0;
		private var powerA:Number = 0.1;
		public var powerMax:Number = 10;
		
		public var canDuck:Boolean = true;
		public var canServe:Boolean = false;
		public var canHit:Boolean = true;
		public var canAutoMove:Boolean = true;
		public var canJump:Boolean = true;
		public var canMove:Boolean = true;
		
		public var servePosition:Number;
		
		
		
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
			animationName = {"walk": "walk", "jump": "jump", "idle": "idle", "hurt": "hurt", "duck": "duck"};
			inputName = {"down": "down", "right": "right", "left": "left", "jump": "up", "hit": "ctrl"};
			//inputName = { "down":"s", "right":"d", "left":"a", "down":"s", "hit":"space" };
			onJump = new Signal();
			onAnimationChange = new Signal();
			onLose = new Signal();
			onHit = new Signal();
		}
		
		override protected function initializeBody():void
		{
			distance = width * 0.8;
			upperHandShapeWidth = width * 0.5;
			upperHandShapeHeight = width * 2.8;
			hitAreaRadius = width * 2.3;
			moveAreaHeight = width * 15;
			moveAreaWidth = width * 18;
			
			anchorPosition = new b2Vec2(_x, _y - _height / 3.5);
			upperHandPosition = new b2Vec2(_x, anchorPosition.y - upperHandShapeHeight / 30 / 2 - distance / 30);
			underHandPosition = new b2Vec2(_x + _width * 1.6, _y);
			hitAreaPosition = new b2Vec2(_x + _width * 0.1, _y - _height * 0.48);
			moveAreaPosition = new b2Vec2(_x, _y - (moveAreaHeight / 30 / 2 - _height / 2));
			
			generalFlipAngles = new <b2Vec2>[MathVector.GetUnitVectorByAngle(-0.25 * Math.PI, 20), MathVector.GetUnitVectorByAngle(-0.24 * Math.PI, 20), MathVector.GetUnitVectorByAngle(-0.23 * Math.PI, 20), MathVector.GetUnitVectorByAngle(-0.20 * Math.PI, 20), MathVector.GetUnitVectorByAngle(-0.18 * Math.PI, 20), MathVector.GetUnitVectorByAngle(-0.15 * Math.PI, 20), MathVector.GetUnitVectorByAngle(-0.13 * Math.PI, 23), MathVector.GetUnitVectorByAngle(-0.13 * Math.PI, 23)];
			jumpFlipAngles = new <b2Vec2>[MathVector.GetUnitVectorByAngle(-0.1 * Math.PI, 30), MathVector.GetUnitVectorByAngle(0.02 * Math.PI, 30), MathVector.GetUnitVectorByAngle(0.03 * Math.PI, 30), MathVector.GetUnitVectorByAngle(0.04 * Math.PI, 30), MathVector.GetUnitVectorByAngle(0.05 * Math.PI, 30), MathVector.GetUnitVectorByAngle(0.06 * Math.PI, 30), MathVector.GetUnitVectorByAngle(0.08 * Math.PI, 30), MathVector.GetUnitVectorByAngle(0.1 * Math.PI, 30)];
			
			if (invertedBody == false)
			{
				inverted = false;
				servePosition = 100;
				upperHandAngularVelocity = 7;
				upperHandMaxAngle = 0.5 * Math.PI;
				upperHandMinAngle = -0.25 * Math.PI;
				upperHandBeginHitAngle = upperHandMinAngle;
				upperHandEndHitAngle = upperHandMaxAngle;
				//upperHandShapeAngle = -0.15 * Math.PI;
				underHandAngle = 0.7 * Math.PI;
				
				upperHandBackAngle = upperHandBeginHitAngle /* - 0.02 * Math.PI*/;
				
				hitBallBeginAngle = -0.8;
				hitBallEndAngle = 0;
				
				serveBallPosition = 100;
			}
			else if (invertedBody == true)
			{
				for (var i:Number = 0; i < generalFlipAngles.length; i++)
				{
					MathVector.invertVector(generalFlipAngles[i]);
				}
				for (i = 0; i < jumpFlipAngles.length; i++)
				{
					MathVector.invertVector(jumpFlipAngles[i]);
				}
				
				MathVector.invertVector(upperHandPosition, _x);
				//MathVector.invertVector(anchorPosition, _x);
				MathVector.invertVector(hitAreaPosition, _x);
				MathVector.invertVector(underHandPosition, _x);
				
				inverted = true;
				servePosition = _ce.stage.stageWidth - 100;
				upperHandAngularVelocity = -7;
				upperHandMaxAngle = 0.25 * Math.PI;
				upperHandMinAngle = -0.5 * Math.PI;
				upperHandBeginHitAngle = upperHandMaxAngle;
				upperHandEndHitAngle = upperHandMinAngle;
				upperHandShapeAngle = 0.15 * Math.PI;
				underHandAngle = 0.3 * Math.PI;
				
				upperHandBackAngle = upperHandBeginHitAngle /* + 0.02 * Math.PI*/;
				
				hitBallBeginAngle = -0.2;
				hitBallEndAngle = -1;
				
				serveBallPosition = _ce.stage.stageWidth - 100;
			}
			
			hitBallAngleExtent = hitBallEndAngle - hitBallBeginAngle;
			
			super.initializeBody();
		}
		
		override public function set invertedBody(value:Boolean):void
		{
			super.invertedBody = value;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			if (view && upperHandBody)
			{
				upperHandBodyPosition.Set(upperHandBody.GetPosition().x - _body.GetPosition().x, upperHandBody.GetPosition().y - _body.GetPosition().y);
				if (_invertedBody)
				{
					MathVector.invertVector(upperHandBodyPosition, 0);
				}
				upperHandView.x = upperHandBodyPosition.x * 30;
				upperHandView.y = upperHandBodyPosition.y * 30;
				upperHandView.rotation = _invertedBody ? -upperHandBody.GetAngle() : upperHandBody.GetAngle() /* * 180 / Math.PI*/;
			}
			updateHand();
		}
		
		override protected function updateAnimation():void
		{
			super.updateAnimation();
			
			var prevAnimation:String = _animation;
			
			if (!getStateByName("onGround").phase)
			{
				_animation = animationName["jump"];
				if (getStateByName("moveLeft").phase)
				{
					//inverted = true;
				}
				else if (getStateByName("moveRight").phase)
				{
					//inverted = false;
				}
			}
			else
			{
				if (getStateByName("moveLeft").phase)
				{
					//inverted = true;
					_animation = animationName["walk"];
				}
				else if (getStateByName("moveRight").phase)
				{
					//inverted = false;
					_animation = animationName["walk"];
				}
				else if (getStateByName("stop").phase)
				{
					_animation = animationName["ready"];
				}
			}
			
			if (canServe)
			{
				if (getActionByName("serve").phase)
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
				else if (getActionByName("takeBall").phase > 0)
				{
					_animation = animationName["readyThrow"];
				}
			}
			
			if (getActionByName("hit").phase)
			{
				if (getActionByName("generalHit").phase)
				{
					_animation = animationName["hit"];
				}
				else if (getActionByName("jumpHit").phase)
				{
					_animation = animationName["jumpHit"];
				}
			}
			
			if (prevAnimation != _animation)
				onAnimationChange.dispatch();
		}
		
		private function hit():void
		{
			getActionByName("hit").phase = Process.BEGIN;
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
					
					if (_ce.input.isDoing(inputName["right"]))
					{
						//velocity.Add(getSlopeBasedMoveAngle());
						velocity.x = velocityVec.x;
						moveKeyPressed = true;
					}
					if (_ce.input.isDoing(inputName["left"]))
					{
						//velocity.Subtract(getSlopeBasedMoveAngle());
						velocity.x = -velocityVec.x;
						moveKeyPressed = true;
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
					velocity.SetZero();
					_fixture.SetFriction(_friction); //Add friction so that he stops running
				}
				
				if (canJump)
				{
					if (getStateByName("touchGround").phase && _ce.input.justDid(inputName["jump"]))
					{
						velocity.y = -jumpHeight;
						onJump.dispatch();
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
						if (_ce.input.justDid(inputName["hit"]))
						{
							_hitBall.body.SetLinearVelocity(_serveBallVec);
							getActionByName("takeBall").phase = Process.END;
							getActionByName("serve").phase = Process.BEGIN;
						}
						
						if (!getStateByName("ballRise").phase)
						{
							getActionByName("takeBall").phase = Process.BEGIN;
							_hitBall.x = _invertedBody ? x - width * 1.2 : x + width * 1.2;
							_hitBall.y = y - height * 0.18;
							_hitBall.body.SetAngle(0);
						}
					}
					else
					{
						if (_ce.input.justDid(inputName["hit"]))
						{
							hit();
						}
					}
					if (_ce.input.justEnd(inputName["hit"]))
					{
						getActionByName("serve").phase = Process.END;
					}
				}
				
				if (canHit)
				{
					if (_ce.input.justDid(inputName["hit"]))
					{
						hit();
					}
					else if (_ce.input.isDoing(inputName["hit"]))
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
				}
			}
			else if (_control == "auto")
			{
				if (canAutoMove)
				{
					var moveAutoActived:Boolean = false;
					if (getStateByName("ballIsRight").phase)
					{
						//velocity.Add(getSlopeBasedMoveAngle());
						velocity.x = velocityVec.x;
						moveAutoActived = true;
					}
					
					if (getStateByName("ballIsLeft").phase)
					{
						//velocity.Subtract(getSlopeBasedMoveAngle());
						velocity.x = -velocityVec.x;
						moveAutoActived = true;
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
				
				if (getStateByName("hitAreaTouchBall").phase == Process.BEGIN)
				{
					hit();
				}
				
			}
			//update physics with new velocity
			_body.SetLinearVelocity(velocity);
			
			if (!getStateByName("upperHandInRange").phase)
			{
				upperHandBody.SetAngle(upperHandBackAngle);
				power = 0;
				powerV = 0;
				getActionByName("hit").phase = Process.END;
				getActionByName("generalHit").phase = Process.END;
				getActionByName("jumpHit").phase = Process.END;
			}
			
			if (!getActionByName("hit").phase)
			{
				upperHandBody.SetAngularVelocity(0);
				upperHandBody.SetAngle(upperHandBackAngle);
			}
			else
			{
				upperHandBody.SetAngularVelocity(upperHandAngularVelocity);
				
				if (getStateByName("touchGround").phase)
				{
					getActionByName("generalHit").phase = Process.BEGIN;
					
					if (getStateByName("upperHandTouchBall").phase == Process.BEGIN)
					{
						ballFlipAngles = generalFlipAngles;
						hitBallAngleLength = ballFlipAngles.length;
						hitBallAngleAccuracy = hitBallAngleExtent / hitBallAngleLength;
						
						ballPosition.SetV(upperHandContactedBody.GetPosition());
						hitAreaBodyPosition.Set(_body.GetPosition().x, anchorPosition.y);
						hitBallCurVector.SetV(ballPosition);
						hitBallCurVector.Subtract(hitAreaBodyPosition);
						hitBallCurAngle = hitBallCurVector.GetAngle() / Math.PI;
						
						ballFlipDirection.SetV(ballFlipAngles[5]);
						//trace(hitBallCurAngle);
						//trace(hitAreaBodyPosition);
						for (var i:int = 0; i < hitBallAngleLength; i++)
						{
							if (MathUtils.isInExtend(hitBallCurAngle, hitBallBeginAngle + i * hitBallAngleAccuracy, hitBallBeginAngle + (i + 1) * hitBallAngleAccuracy))
							{
								ballFlipDirection.SetV(ballFlipAngles[i]);
								break;
							}
						}
						
						ballFlipDirection.Multiply(ballFlipDirection.Normalize() + power);
						upperHandContactedBody.SetLinearVelocity(ballFlipDirection);
						onHit.dispatch();
					}
				}
				
				else
				{
					//_linearVelocity.SetZero();
					//_fixture.SetFriction(_friction);
					getActionByName("jumpHit").phase = Process.BEGIN;
					
					if (getStateByName("upperHandTouchBall").phase == Process.BEGIN)
					{
						ballFlipAngles = jumpFlipAngles;
						hitBallAngleLength = ballFlipAngles.length;
						hitBallAngleAccuracy = hitBallAngleExtent / hitBallAngleLength;
						
						ballPosition.SetV(upperHandContactedBody.GetPosition());
						hitAreaBodyPosition.Set(_body.GetPosition().x, anchorPosition.y);
						hitBallCurVector.SetV(ballPosition);
						hitBallCurVector.Subtract(hitAreaBodyPosition);
						hitBallCurAngle = hitBallCurVector.GetAngle() / Math.PI;
						
						ballFlipDirection.SetV(ballFlipAngles[5]);
						//trace(hitBallCurAngle);
						//trace(hitAreaBodyPosition);
						for (i = 0; i < hitBallAngleLength; i++)
						{
							if (MathUtils.isInExtend(hitBallCurAngle, hitBallBeginAngle + i * hitBallAngleAccuracy, hitBallBeginAngle + (i + 1) * hitBallAngleAccuracy))
							{
								ballFlipDirection.SetV(ballFlipAngles[i]);
								break;
							}
						}
						
						upperHandContactedBody.SetLinearVelocity(ballFlipDirection);
						onHit.dispatch();
					}
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
			Logic.stateCondition(getStateByName("moveLeftMax"), _walkingSpeed < -maxVelocity);
			Logic.stateCondition(getStateByName("moveRight"), _walkingSpeed > acceleration);
			Logic.stateCondition(getStateByName("moveRightMax"), _walkingSpeed > maxVelocity);
			Logic.stateCondition(getStateByName("stop"), _walkingSpeed > -acceleration && _walkingSpeed < acceleration);
			Logic.stateCondition(getStateByName("upperHandInRange"), Math.abs(upperHandBody.GetAngle()) < Math.abs(upperHandEndHitAngle) - 0.1);
			if (_hitBall)
			{
				Logic.stateCondition(getStateByName("inScope"), _invertedBody ? _hitBall.body.GetPosition().x > _ce.stage.stageWidth * 0.5 / 30 : _hitBall.body.GetPosition().x < _ce.stage.stageWidth * 0.5 / 30);
				Logic.stateCondition(getStateByName("ballIsLeft"), getStateByName("inScope").phase && _hitBall.body.GetPosition().x < (_invertedBody ? _body.GetPosition().x : _body.GetPosition().x - 1));
				Logic.stateCondition(getStateByName("ballIsRight"), getStateByName("inScope").phase && _hitBall.body.GetPosition().x > (_invertedBody ? _body.GetPosition().x + 1 : _body.GetPosition().x));
				//Logic.stateCondition(getStateByName("ballIsMiddle"), getStateByName("inScope").phase && _hitBall.body.GetPosition().x > _invertedBody?_body.GetPosition().x + 1:_body.GetPosition().x);
				Logic.stateCondition(getStateByName("ballOnGround"), _hitBall.getStateByName("touchGround").phase > 0);
				Logic.stateCondition(getStateByName("loseBall"), getStateByName("ballOnGround").phase > 0 && getStateByName("inScope").phase > 0);
				
				Logic.stateCondition(getStateByName("ballRise"), _hitBall.getStateByName("rise").phase > 0);
				Logic.stateCondition(getStateByName("takeBallExtent"), _hitBall.body.GetPosition().y > _body.GetPosition().y - _height * 0.3 && _hitBall.body.GetPosition().y < _body.GetPosition().y);
				Logic.stateCondition(getStateByName("throwBallExtent"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.3 && _hitBall.body.GetPosition().y > _body.GetPosition().y - _height * 0.8);
				Logic.stateCondition(getStateByName("waitBallExtent"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.8);
					//Logic.stateCondition(getStateByName("takeBallExtentX"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.8);
			}
		}
		
		private function updateHand():void
		{
			/*face = mouseX > armatureClip.x ? 1 : -1;
			   if (armatureClip.scaleX != face)
			   {
			   armatureClip.scaleX = face;
			   updateMovement();
			   }
			
			   var _r:Number;
			   if (face > 0)
			   {
			   _r = Math.atan2(mouseY - armatureClip.y, mouseX - armatureClip.x);
			   }
			   else
			   {
			   _r = Math.PI - Math.atan2(mouseY - armatureClip.y, mouseX - armatureClip.x);
			   if (_r > Math.PI)
			   {
			   _r -= Math.PI * 2;
			   }
			 }*/
			
			var _body1:Bone = (view as Armature).getBone("bady-a10");
			_body1.node.rotation = _invertedBody ? -upperHandBody.GetAngle() : upperHandBody.GetAngle() /* * 180 / Math.PI*/;
			
			var _body2:Bone = (view as Armature).getBone("bady-a20");
			//_body2.node.rotation = _invertedBody ? -upperHandBody.GetAngle() : upperHandBody.GetAngle() /* * 180 / Math.PI*/;
			
			var _body3:Bone = (view as Armature).getBone("bady-a30");
			//_body3.node.rotation = _invertedBody ? -upperHandBody.GetAngle() : upperHandBody.GetAngle() /* * 180 / Math.PI*/;
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			upperHandBodyDef = EasyBox2D.defineBody(upperHandBodyDef, upperHandPosition, 0, 2, this);
			hitAreaBodyDef = EasyBox2D.defineBody(hitAreaBodyDef, hitAreaPosition, 0, 2, this);
			//moveAreaBodyDef = EasyBox2D.defineBody(moveAreaBodyDef, moveAreaPosition, 0, 2, this);
			underHandBodyDef = EasyBox2D.defineBody(underHandBodyDef, underHandPosition, underHandAngle, 2, this);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
			_body.m_customGravity = new b2Vec2(0, 20);
			
			upperHandBody = EasyBox2D.createBody(_box2D.world, upperHandBodyDef);
			upperHandBody.beginContactHanlder = upperHandBeginContactHanlder;
			upperHandBody.endContactHanlder = upperHandEndContactHanlder;
			
			upperHandView = new Quad(upperHandShapeWidth * 2, upperHandShapeHeight * 2, 0X000000);
			//upperHandView = new Image(Assets.getTexture("Ball"));
			upperHandView.pivotX = 0 /*(upperHandView.width >> 1)*/;
			upperHandView.pivotY = (upperHandView.height /* >> 1*/);
			((view as Armature).display as Sprite).addChild(upperHandView);
			
			underHandBody = EasyBox2D.createBody(_box2D.world, underHandBodyDef);
			underHandBody.beginContactHanlder = underHandBeginContactHanlder;
			underHandBody.endContactHanlder = underHandEndContactHanlder;
			
			hitAreaBody = EasyBox2D.createBody(_box2D.world, hitAreaBodyDef);
			hitAreaBody.beginContactHanlder = hitAreaBeginContactHanlder;
			hitAreaBody.endContactHanlder = hitAreaEndContactHanlder;
		
		/*moveAreaBody = EasyBox2D.createBody(_box2D.world, moveAreaBodyDef);
		   moveAreaBody.beginContactHanlder = moveAreaBeginContactHanlder;
		 moveAreaBody.endContactHanlder = moveAreaEndContactHanlder;*/
		}
		
		override protected function beginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			super.beginContactHanlder(selfBody, contactedBody);
			if (contactedBody.GetUserData() is Wall)
			{
				getStateByName("touchWall").phase = Process.BEGIN;
			}
			if (contactedBody.GetUserData() is Ground)
			{
				getStateByName("touchGround").phase = Process.BEGIN;
			}
		}
		
		override protected function endContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			super.endContactHanlder(selfBody, contactedBody);
			if (contactedBody.GetUserData() is Ground)
			{
				getStateByName("touchWall").phase = Process.END;
			}
			if (contactedBody.GetUserData() is Ground)
			{
				getStateByName("touchGround").phase = Process.END;
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
		
		private function moveAreaBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			moveAreaContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("moveAreaTouchBall").phase = Process.BEGIN;
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
		
		private function upperHandBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			upperHandContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("upperHandTouchBall").phase = Process.BEGIN;
			}
		}
		
		private function upperHandEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			upperHandContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("upperHandTouchBall").phase = Process.END;
			}
		}
		
		private function underHandBeginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			underHandContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("underHandTouchBall").phase = Process.BEGIN;
			}
		}
		
		private function underHandEndContactHanlder(selfBody:b2Body, contactedBody:b2Body):void
		{
			underHandContactedBody = contactedBody;
			if (contactedBody.GetUserData().name == "ball")
			{
				_hitBall = contactedBody.GetUserData();
				getStateByName("underHandTouchBall").phase = Process.END;
			}
		}
		
		override protected function createShape():void
		{
			super.createShape();
			
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.3);	
			
			upperHandShape = EasyBox2D.createPolygonShape(upperHandShapeWidth, upperHandShapeHeight, null, /*upperHandShapeAngle*/ 0);
			underHandShape = EasyBox2D.createPolygonShape(underHandShapeWidth, underHandShapeHeight, null, underHandShapeAngle);
			hitAreaShape = EasyBox2D.createCircleShape(hitAreaRadius);
			//moveAreaShape = EasyBox2D.createBeveledRectShape(moveAreaWidth, moveAreaHeight, 0.3);
			//hitAreaShape = EasyBox2D.createBeveledRectShape(110, 140, 1);
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			//_fixtureDef.friction = 0.1;
			
			upperHandFixtureDef = EasyBox2D.defineFixture(upperHandFixtureDef, upperHandShape, 0.01, 0.2, 0.5, PhysicsCollisionCategories.Get("PlayerHand"), PhysicsCollisionCategories.Get("Ball"), true);
			underHandFixtureDef = EasyBox2D.defineFixture(underHandFixtureDef, underHandShape, 0.01, 0.6, 0.5, PhysicsCollisionCategories.Get("PlayerHand"), PhysicsCollisionCategories.Get("Ball"), true);
			//upperHandFixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Level");
			hitAreaFixtureDef = EasyBox2D.defineFixture(hitAreaFixtureDef, hitAreaShape, 0.01, 0.2, 0.0, PhysicsCollisionCategories.Get("PlayerSensor"), PhysicsCollisionCategories.Get("Ball"), true);
			//upperHandFixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
			//moveAreaFixtureDef = EasyBox2D.defineFixture(moveAreaFixtureDef, moveAreaShape, 0.1, 0.2, 0.0, PhysicsCollisionCategories.Get("PlayerSensor"), PhysicsCollisionCategories.Get("Ball"), true);
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			
			upperHandFixture = EasyBox2D.createFixture(upperHandBody, upperHandFixtureDef);
			underHandFixture = EasyBox2D.createFixture(underHandBody, underHandFixtureDef);
			hitAreaFixture = EasyBox2D.createFixture(hitAreaBody, hitAreaFixtureDef);
			//moveAreaFixture = EasyBox2D.createFixture(moveAreaBody, moveAreaFixtureDef)
		}
		
		override protected function defineJoint():void
		{
			super.defineJoint();
			upperHandRevoluteJointDef = EasyBox2D.defineRevoluteJoint(upperHandRevoluteJointDef, _body, upperHandBody, anchorPosition, false, 0, 100, true, upperHandMinAngle, upperHandMaxAngle);
			underHandWeldJointDef = EasyBox2D.defineWeldJoint(underHandWeldJointDef, _body, underHandBody, anchorPosition);
			hitAreaJointDef = EasyBox2D.defineWeldJoint(hitAreaJointDef, _body, hitAreaBody, anchorPosition);
			//moveAreaJointDef = EasyBox2D.defineWeldJoint(moveAreaJointDef, _body, moveAreaBody, anchorPosition);
		}
		
		override protected function createJoint():void
		{
			upperHandJoint = EasyBox2D.createJoint(_box2D.world, upperHandRevoluteJointDef);
			underHandJoint = EasyBox2D.createJoint(_box2D.world, underHandWeldJointDef);
			hitAreaJoint = EasyBox2D.createJoint(_box2D.world, hitAreaJointDef);
			//moveAreaJoint = EasyBox2D.createJoint(_box2D.world, moveAreaJointDef);
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
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
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