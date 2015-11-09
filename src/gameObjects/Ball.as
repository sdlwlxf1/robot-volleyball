package gameObjects
{
	
	import aze.motion.eaze;
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import citrus.core.CitrusEngine;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.PhysicsCollisionCategories;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.extensions.particles.PDParticleSystem;
	import starling.filters.BlurFilter;
	import starling.textures.SubTexture;
	import assets.Assets;
	import assets.Particles;
	import constants.StageConst;
	import logics.gameLogic.TrainSmashBall;
	import logics.Logic;
	import logics.Process;
	import math.MathUtils;
	import math.MathVector;
	
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	/**
	 * A Platform is a rectangular object that is meant to be stood on. It can be given any position, width, height, or rotation to suit your level's needs.
	 * You can make your platform a "one-way" or "cloud" platform so that you can jump on from underneath (collision is only applied when coming from above it).
	 *
	 * There are two ways of adding graphics for your platform. You can give your platform a graphic just like you would any other object (by passing a graphical
	 * class into the view property) or you can leave your platform invisible and line it up with your backgrounds for a more custom look.
	 *
	 * <ul>Properties:
	 * <li>oneWay - Makes the platform only collidable when falling from above it.</li></ul>
	 */
	public class Ball extends DynamicObject
	{
		
		private var launchSpeed:b2Vec2 = new b2Vec2(-15, -6);
		private var _isStatic:Boolean;
		
		private var _linearAngle:MathVector = new MathVector();
		private var _fireParticleAdded:Boolean;
		private var _preSoundTime:Number;
		private var _nowSoundTime:Number;
		private var _nouSound:Date;
		private var _timeoutF1:uint;
		
		public var exploded:Boolean = false;
		
		public var fireParticle:ArithmeticParticle;
		public var particleExplode1:MovieClipParticle;
		public var particleExplode2:MovieClipParticle;
		public var particleFall1:MovieClipParticle;
		public var particleHit1:MovieClipParticle;
		
		public var camTarget:Object = { x: 0, y: 0 };
		
		public var onTouchGround:Signal;
		public var onLose:Signal;
		
		private var _gravity:b2Vec2 = new b2Vec2(0, 3);
		
		
		public var train:TrainSmashBall;
		
		
		private var _overSkyImage:Image;
		
		private var _rise:Boolean;
		
		public var ballType:uint;
		public var fireParticleOpen:Boolean;
		public var explodeParticleEnable:Boolean;
		
		public var countId:int;
		
		public var blockAddScore:Boolean = false;
		
		public function Ball(name:String, params:Object = null)
		{
			super(name, params);
			
			onTouchGround = new Signal();
			onLose = new Signal();
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{			
			super.initialize(poolObjectParams);
			
			_overSkyImage = new Image(Assets.getTexture("overSky"));
			_overSkyImage.pivotX = _overSkyImage.width >> 1;
			
		}
		
		public function explode():void
		{
			if (!exploded)
			{
				if (explodeParticleEnable)
				{
					particleExplode1.play();
				}
				particleExplode2.play();
		
				eaze(this).delay(0.1).onComplete(destroy).delay(1).onComplete(destroyParticle);
				//destroy();
				exploded = true;
			}
		}
		
		public function hitGround():void
		{
			particleFall1.play();
		}
		
		//override 
		
		public function destroyParticle():void
		{
			
			_ce.state.remove(particleExplode1);
			_ce.state.remove(particleExplode2);
			_ce.state.remove(particleHit1);
			_ce.state.remove(fireParticle);
			
			particleExplode1.destroy();
			particleExplode2.destroy();
			particleHit1.destroy();
			
			fireParticle.stop();
			fireParticle.destroy();		
			
			_ce.state.remove(this);
		}
		
		override public function destroy():void
		{	
			overSkyImage.removeFromParent(true);
			(view as Image).removeFromParent(true);
			_box2D.world.DestroyBody(_body);
			//super.destroy();			
		}
	
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			camTarget.x = x;
			camTarget.y = StageConst.stageHeight;
		}
		
		override protected function updateStates():void 
		{
			super.updateStates();
			
			_rise = false;
			
			if (_linearVelocity.y < 0)
			{
				_rise = true;
			}
			
			Logic.stateCondition(getStateByName("rise"), _linearVelocity.y < 0);
			Logic.stateCondition(getStateByName("drop"), _linearVelocity.y > 0);
			Logic.stateCondition(getStateByName("inLoseExtent"), y > StageConst.stageHeight - height * 0.5 - 50);

			Logic.stateCondition(getStateByName("loseBall"), getStateByName("inLoseExtent").phase > 0 && x < StageConst.stageWidth / 2);		
		}
		
		override protected function updateActions():void 
		{
			super.updateActions();
			_linearAngle.SetV(_linearVelocity.GetNegative());
			
			if (getStateByName("touchGround").phase == Process.BEGIN)
			{				
				hitGround();
			}
			
			
			if (getStateByName("loseBall").phase == Process.BEGIN)
			{
				onLose.dispatch();
			}
			
			if (fireParticle && fireParticleOpen)
			{
			
				fireParticle.pdParticleSystem.emitAngle = linearAngle.GetAngle();
				//fireParticle.pdParticleSystem.speed = linearAngle.Length() * 15;
				
				/*if (linearAngle.Length() > 16)
				{*/
				fireParticle.start();
				fireParticle.pdParticleSystem.maxNumParticles = int(_linearAngle.Length() * 20);
				//fireParticle.maxNumParticles = int(_linearAngle.Length() * 20);
				/*}
				else
				{
					fireParticle.stop();
				}*/
			}
			
			if (y < 0)
			{
				overSkyImage.alpha = 1;
				overSkyImage.x = x;
				overSkyImage.scaleX = 1 + y / 200;
				overSkyImage.scaleY = 1 + y / 200;
			}
			else
			{
				overSkyImage.alpha = 0;
			}
			
		}
	
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.fixedRotation = false;
			//_bodyDef.angularDamping = 10;
			_bodyDef.linearDamping = 1;
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.m_customGravity = _gravity;	
		}
		
		override protected function createShape():void
		{
			super.createShape();
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.density = 1;
			_fixtureDef.friction = 0.2;
			_fixtureDef.restitution = 0.2;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Ball");
			_fixtureDef.filter.maskBits = /*PhysicsCollisionCategories.GetAll();*/PhysicsCollisionCategories.GetAllExcept("Player", "Ball");
			

		}
		
		override protected function createFixture():void
		{
			super.createFixture();
		}
		
		override protected function defineJoint():void
		{
			
		}
		
		override protected function createJoint():void
		{

		}
		
		
		override protected function beginContactHanlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			super.beginContactHanlder(selfBody, contactedBody);
			
			var power:Number = _linearVelocity.Length() / 15;
			
			if (contactedBody.GetUserData() is Ground)
			{
				_ce.sound.playSound("hit_ground3");
				_ce.sound.setVolume("hit_ground3", power)
				getStateByName("touchGround").phase = Process.BEGIN;
				onTouchGround.dispatch(this);
			}
			else if (contactedBody.GetUserData().name == "rightWall" || contactedBody.GetUserData().name == "leftWall")
			{
				_ce.sound.playSound("hit_ground4");
				_ce.sound.setVolume("hit_ground3", power)
				getStateByName("touchWall").phase = Process.BEGIN;
			}
			else if (contactedBody.GetUserData().name == "net")
			{
				
				_preSoundTime = _nowSoundTime;
				
				_nouSound = new Date();
				_nowSoundTime = _nouSound.getTime();
				
				if (_nowSoundTime - _preSoundTime > 1000)
				{
					_ce.sound.playSound("hit_net");
					_ce.sound.setVolume("hit_net", power)
				}			
				getStateByName("touchNet").phase = Process.BEGIN;
			}
			else if (contactedBody.GetUserData() is Player)
			{				
				getStateByName("touchBody").phase = Process.BEGIN;
			}
		}
		
		override protected function endContactHandlder(selfBody:b2Body, contactedBody:b2Body):void 
		{
			super.endContactHandlder(selfBody, contactedBody);
			
			if (contactedBody.GetUserData() is Ground)
			{
				getStateByName("touchGround").phase = Process.END;
			}
			else if (contactedBody.GetUserData().name == "rightWall" || contactedBody.GetUserData().name == "leftWall")
			{
				
				getStateByName("touchWall").phase = Process.END;
			}
			else if (contactedBody.GetUserData().name == "net")
			{
				getStateByName("touchNet").phase = Process.END;
			}
			else if (contactedBody.GetUserData() is Player)
			{
				getStateByName("touchBody").phase = Process.END;
			}
			
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			super.handlePreSolve(contact, oldManifold);
			//trace("小球碰撞提前处理");
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			//trace("小球碰撞开始处理");
			if (_collider is Wall)
			{
				getStateByName("touchWall").phase = Process.BEGIN;	
			}
			else if (_collider is Ground)
			{
				getStateByName("touchGround").phase = Process.BEGIN;	
			}
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			super.handleEndContact(contact);
			//trace("小球碰撞结束处理");
			if (_collider is Wall)
			{
				getStateByName("touchWall").phase = Process.END;
			}
			else if (_collider is Ground)
			{
				getStateByName("touchGround").phase = Process.END;	
			}
		}
		
		public function get isStatic():Boolean 
		{
			return _isStatic;
		}
		
		public function set isStatic(value:Boolean):void 
		{
			_isStatic = value;
			if (value == true)
			{
				_body.m_customGravity = new b2Vec2(0, 0);
			}
			else if(value == false)
			{
				_body.m_customGravity = _gravity;
			}
		}
		
		public function get linearAngle():MathVector 
		{
			return _linearAngle;
		}
		
		public function get overSkyImage():Image 
		{
			return _overSkyImage;
		}
		
		public function get rise():Boolean 
		{
			return _rise;
		}
	}
}