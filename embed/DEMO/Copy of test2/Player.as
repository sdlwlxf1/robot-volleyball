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
	import citrus.objects.platformer.box2d.Hero;
	import flash.utils.Dictionary;
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
	public class Player extends ControledObject
	{
		public var distance:Number = 1;
		public var anchorPosition:b2Vec2;
		
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
		public var servePosition:Number;
		
		public var onLose:Signal;
		
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
			onLose = new Signal();
		}
		
		override protected function initializeBody():void
		{
			distance = width * 0.8;
			upperHandShapeWidth = width * 0.3;
			upperHandShapeHeight = width * 2.8;
			hitAreaRadius = width * 2.3;
			moveAreaHeight = width * 15;
			moveAreaWidth = width * 18;
			
			anchorPosition = new b2Vec2(_x, _y - _height / 3.5);
			upperHandPosition = new b2Vec2(_x, anchorPosition.y - upperHandShapeHeight / 30 / 2 - distance / 30);
			underHandPosition = new b2Vec2(_x + _width * 1.6, _y);
			hitAreaPosition = new b2Vec2(_x + _width * 0.1, _y - _height * 0.48);
			moveAreaPosition = new b2Vec2(_x, _y - (moveAreaHeight / 30 / 2 - _height / 2));
			
			generalFlipAngles = new <b2Vec2>[
			MathVector.GetUnitVectorByAngle(-0.25 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.24 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.23 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.20 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.18 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.15 * Math.PI, 20), 
			MathVector.GetUnitVectorByAngle( -0.13 * Math.PI, 23), 
			MathVector.GetUnitVectorByAngle(-0.13 * Math.PI, 23)];
			jumpFlipAngles = new <b2Vec2>[
			MathVector.GetUnitVectorByAngle(-0.1 * Math.PI, 30), 
			MathVector.GetUnitVectorByAngle(0.02 * Math.PI, 30), 
			MathVector.GetUnitVectorByAngle(0.03 * Math.PI, 30),
			MathVector.GetUnitVectorByAngle(0.04 * Math.PI, 30), 
			MathVector.GetUnitVectorByAngle(0.05 * Math.PI, 30), 
			MathVector.GetUnitVectorByAngle(0.06 * Math.PI, 30), 
			MathVector.GetUnitVectorByAngle(0.08 * Math.PI, 30), 
			MathVector.GetUnitVectorByAngle(0.1 * Math.PI, 30)];
			
			if (invertedBody == false)
			{
				inverted = false;
				servePosition = 100;
				upperHandAngularVelocity = 30;
				upperHandMaxAngle = 0.5 * Math.PI;
				upperHandMinAngle = -0.25 * Math.PI;
				upperHandBeginHitAngle = upperHandMinAngle;
				upperHandEndHitAngle = upperHandMaxAngle;
				//upperHandShapeAngle = -0.15 * Math.PI;
				underHandAngle = 0.7 * Math.PI;
				
				upperHandBackAngle = upperHandBeginHitAngle + -0.1 * Math.PI;
				
				hitBallBeginAngle = -0.8;
				hitBallEndAngle = 0;
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
				upperHandAngularVelocity = -30;
				upperHandMaxAngle = 0.25 * Math.PI;
				upperHandMinAngle = -0.5 * Math.PI;
				upperHandBeginHitAngle = upperHandMaxAngle;
				upperHandEndHitAngle = upperHandMinAngle;
				upperHandShapeAngle = 0.15 * Math.PI;
				underHandAngle = 0.3 * Math.PI;
				
				upperHandBackAngle = upperHandBeginHitAngle;
				
				hitBallBeginAngle = -0.2;
				hitBallEndAngle = -1;
			}
			
			hitBallAngleExtent = hitBallEndAngle - hitBallBeginAngle;
			
			super.initializeBody();
		}
		
		override public function set invertedBody(value:Boolean):void
		{
			super.invertedBody = value;
		}
		
		override protected function initializeLogic():void
		{
			_logic = new PlayerLogic(this);
			_logic.doExtraActions = doExtraActions;
			_logic.doAction = doAction;
			_logic.updateStates = updateStates;
			_logic.updateAnimation = updateAnimation;
		}
		
		override protected function updateAnimation():void
		{
			super.updateAnimation();
			if (getStateByName("matchBegin").phase > 0)
			{
				if (getActionByName("serve").phase > 0)
				{
					_animation = animationName["throw"];
				}
				else if (getStateByName("waitBallExtent").phase > 0)
				{
					_animation = animationName["waitHit"];
				}
				else if (getStateByName("ballRise").phase == Process.OFF && getStateByName("throwBallExtent").phase > 0)
				{
					_animation = animationName["backThrow"];
				}
			}
			
			if (getActionByName("hit").phase)
			{
				if (getActionByName("generalHit").phase > 0)
				{
					_animation = animationName["hit"];
				}
				else if (getActionByName("jumpHit").phase > 0)
				{
					_animation = animationName["jumpHit"];
				}
				else if (getActionByName("squatHit").phase > 0)
				{
					_animation = animationName["squatHit"];
				}
			}
		}
		
		override public function get logic():Logic
		{
			return _logic as PlayerLogic;
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
		
		override protected function doAction(action:Action):void
		{
			super.doAction(action);
			
			switch (action.name)
			{
				case "hit": 
					switch (action.phase)
				{
					case Process.BEGIN:
						upperHandBody.SetAngularVelocity(upperHandAngularVelocity);
						break;
					case Process.END: 
						trace("打结束");
						upperHandBody.SetAngle(upperHandBackAngle);
						break;
					case Process.ON: 						
						break;
				}
					break;
				case "generalHit": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						trace("普通打");
						break;
					case Process.END: 
						trace("打结束");
						break;
					case Process.ON: 
						break;
				}
					break;
				case "generalHitBall": 
					switch (action.phase)
				{
					case Process.BEGIN:
						trace("普通击球");
						ballFlipAngles = generalFlipAngles;
						hitBallAngleLength = ballFlipAngles.length;
						hitBallAngleAccuracy = hitBallAngleExtent / hitBallAngleLength;
						
						ballPosition.SetV(upperHandContactedBody.GetPosition());
						hitAreaBodyPosition.Set(_body.GetPosition().x, anchorPosition.y);
						hitBallCurVector.SetV(ballPosition);
						hitBallCurVector.Subtract(hitAreaBodyPosition);
						hitBallCurAngle = hitBallCurVector.GetAngle() / Math.PI;
						
						ballFlipDirection.SetV(ballFlipAngles[0]);
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
						
						upperHandContactedBody.SetLinearVelocity(ballFlipDirection);
						break;
					case Process.END: 
						break;
					case Process.BEGIN: 
						break;
				}
					break;
				case "jumpHit": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						trace("跳打");
						break;
					case Process.END: 
						trace("跳打结束");
						break;
					case Process.ON: 
						break;
				}
					break;
				case "jumpHitBall": 
					switch (action.phase)
				{
					case Process.BEGIN:
						trace("跳击球");
						ballFlipAngles = jumpFlipAngles;
						hitBallAngleLength = ballFlipAngles.length;
						hitBallAngleAccuracy = hitBallAngleExtent / hitBallAngleLength;
						
						ballPosition.SetV(upperHandContactedBody.GetPosition());
						hitAreaBodyPosition.Set(_body.GetPosition().x, anchorPosition.y);
						hitBallCurVector.SetV(ballPosition);
						hitBallCurVector.Subtract(hitAreaBodyPosition);
						hitBallCurAngle = hitBallCurVector.GetAngle() / Math.PI;
						
						ballFlipDirection.SetV(ballFlipAngles[0]);
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
						break;
					case Process.END: 
						break;
					case Process.BEGIN: 
						break;
				}
					break;
				case "squatHit": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						//trace("蹲打");
						break;
					case Process.END: 
						//trace("蹲打结束");
						break;
					case Process.ON: 
						break;
				}
					break;
				case "squatHitBall": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						underHandContactedBody.SetLinearVelocity(generalFlipAngles[0]);
						break;
					case Process.END: 
						break;
					case Process.BEGIN: 
						break;
				}
					break;
				case "hitDelay": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						break;
					case Process.END: 
						break;
					case Process.ON: 
						//_linearVelocity.SetZero();
						//_linearVelocity.y = 0;
						break;
				}
					break;
				case "serve": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						_hitBall.body.SetLinearVelocity(_serveBallVec);
						break;
					case Process.END: 
						break;
					case Process.ON: 
						break;
				}
					break;
				case "takeBall": 
					switch (action.phase)
				{
					case Process.BEGIN:
						break;
					case Process.END: 
						break;
					case Process.ON:
						_hitBall.x = _invertedBody ? x - width * 1.2 : x + width * 1.2;
						_hitBall.y = y - height * 0.18;
						break;
				}
					break;
				case "hitBall": 
					switch (action.phase)
				{
					case Process.BEGIN: 
						break;
					case Process.END: 
						break;
					case Process.ON: 
						break;
				}
					break;
				case "moveToServe": 
					switch (action.phase)
				{
					case Process.BEGIN:
						break;
					case Process.END: 
						break;
					case Process.ON:
						break;
				}
					break;
			
			}
		}
		
		override protected function doExtraActions():void
		{
			super.doExtraActions();
			/*if (getActionByName("hit").phase == Process.OFF)
			{
				upperHandBody.SetAngle(upperHandBackAngle);
			}*/
			if (getActionByName("hit").phase == Process.OFF)
			{
				upperHandBody.SetAngle(upperHandBackAngle);
			}
		}
		
		override protected function updateStates():void
		{
			super.updateStates();
			Logic.stateCondition(getStateByName("upperHandInRange"), Math.abs(upperHandBody.GetAngle()) < Math.abs(upperHandEndHitAngle) - 0.1);
			if (_hitBall)
			{
				Logic.stateCondition(getStateByName("inScope"), _invertedBody ? _hitBall.body.GetPosition().x > _ce.stage.stageWidth * 0.5 / 30 : _hitBall.body.GetPosition().x < _ce.stage.stageWidth * 0.5 / 30);
				Logic.stateCondition(getStateByName("ballIsLeft"), getStateByName("inScope").phase && _hitBall.body.GetPosition().x < (_invertedBody ? _body.GetPosition().x : _body.GetPosition().x - 1));
				Logic.stateCondition(getStateByName("ballIsRight"), getStateByName("inScope").phase && _hitBall.body.GetPosition().x > (_invertedBody ? _body.GetPosition().x + 1 : _body.GetPosition().x));
				//Logic.stateCondition(getStateByName("ballIsMiddle"), getStateByName("inScope").phase && _hitBall.body.GetPosition().x > _invertedBody?_body.GetPosition().x + 1:_body.GetPosition().x);
				Logic.stateCondition(getStateByName("ballOnGround"), _hitBall.getStateByName("touchGround").phase > 0);
				Logic.stateCondition(getStateByName("score"), getStateByName("ballOnGround").phase > 0 && getStateByName("inScope").phase > 0, false, getStateByName("matchEnd").phase > 0);
				
				Logic.stateCondition(getStateByName("ballRise"), _hitBall.getStateByName("rise").phase > 0);
				Logic.stateCondition(getStateByName("takeBallExtent"), _hitBall.body.GetPosition().y > _body.GetPosition().y - _height * 0.3 && _hitBall.body.GetPosition().y < _body.GetPosition().y);
				Logic.stateCondition(getStateByName("throwBallExtent"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.3 && _hitBall.body.GetPosition().y > _body.GetPosition().y - _height * 0.8);
				Logic.stateCondition(getStateByName("waitBallExtent"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.8);
					//Logic.stateCondition(getStateByName("takeBallExtentX"), _hitBall.body.GetPosition().y < _body.GetPosition().y - _height * 0.8);
			}
			if (_opponent)
			{
				/*Logic.stateCondition(getStateByName("youTurn"), _opponent.getStateByName("upperHandTouchBall").phase > 0 || _opponent.getStateByName("underHandTouchBall").phase > 0, false, getStateByName("upperHandTouchBall").phase > 0 || getStateByName("underHandTouchBall").phase > 0);*/
				Logic.stateCondition(getStateByName("youTurn"), _opponent.getActionByName("hitBall").phase > 0, false, getActionByName("hitBall").phase > 0 || getStateByName("score").phase == Process.BEGIN);
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
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
			
			upperHandBody = EasyBox2D.createBody(_box2D.world, upperHandBodyDef);
			upperHandBody.m_customGravity = new b2Vec2(0, 0);
			upperHandBody.beginContactHanlder = upperHandBeginContactHanlder;
			upperHandBody.endContactHanlder = upperHandEndContactHanlder;
			
			underHandBody = EasyBox2D.createBody(_box2D.world, underHandBodyDef);
			underHandBody.m_customGravity = new b2Vec2(0, 0);
			underHandBody.beginContactHanlder = underHandBeginContactHanlder;
			underHandBody.endContactHanlder = underHandEndContactHanlder;
			
			hitAreaBody = EasyBox2D.createBody(_box2D.world, hitAreaBodyDef);
			hitAreaBody.beginContactHanlder = hitAreaBeginContactHanlder;
			hitAreaBody.endContactHanlder = hitAreaEndContactHanlder;
		
		/*moveAreaBody = EasyBox2D.createBody(_box2D.world, moveAreaBodyDef);
		   moveAreaBody.beginContactHanlder = moveAreaBeginContactHanlder;
		 moveAreaBody.endContactHanlder = moveAreaEndContactHanlder;*/
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
			
			upperHandShape = EasyBox2D.createPolygonShape(upperHandShapeWidth, upperHandShapeHeight, null, /*upperHandShapeAngle*/0);
			underHandShape = EasyBox2D.createPolygonShape(underHandShapeWidth, underHandShapeHeight, null, underHandShapeAngle);
			hitAreaShape = EasyBox2D.createCircleShape(hitAreaRadius);
			//moveAreaShape = EasyBox2D.createBeveledRectShape(moveAreaWidth, moveAreaHeight, 0.3);
			//hitAreaShape = EasyBox2D.createBeveledRectShape(110, 140, 1);
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			
			upperHandFixtureDef = EasyBox2D.defineFixture(upperHandFixtureDef, upperHandShape, 1, 0.6, 0.5, PhysicsCollisionCategories.Get("PlayerHand"), PhysicsCollisionCategories.Get("Ball"), true);
			underHandFixtureDef = EasyBox2D.defineFixture(underHandFixtureDef, underHandShape, 1, 0.6, 0.5, PhysicsCollisionCategories.Get("PlayerHand"), PhysicsCollisionCategories.Get("Ball"), true);
			//upperHandFixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Level");
			hitAreaFixtureDef = EasyBox2D.defineFixture(hitAreaFixtureDef, hitAreaShape, 1, 0.2, 0.0, PhysicsCollisionCategories.Get("PlayerSensor"), PhysicsCollisionCategories.Get("Ball"), true);
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
	}
}