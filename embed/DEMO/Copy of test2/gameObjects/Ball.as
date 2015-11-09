package test2.gameObjects
{
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import citrus.core.CitrusEngine;
	import citrus.objects.CitrusSprite;
	import citrus.physics.PhysicsCollisionCategories;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.extensions.particles.PDParticleSystem;
	import starling.textures.SubTexture;
	import test2.assets.Particles;
	import test2.logic.Logic;
	import test2.logic.Process;
	import test2.math.MathUtils;
	import test2.math.MathVector;
	
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
		public var fireParticle:PDParticleSystem;
		private var _linearAngle:MathVector = new MathVector();
		private var _fireParticleAdded:Boolean;
		
		public function Ball(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{			
			super.initialize(poolObjectParams);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
	
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		override protected function updateStates():void 
		{
			super.updateStates();
			Logic.stateCondition(getStateByName("rise"), _linearVelocity.y < 0);
			Logic.stateCondition(getStateByName("drop"), _linearVelocity.y > 0);
			Logic.stateCondition(getStateByName("inLoseExtent"), _body.GetPosition().y > (Starling.current.stage.stageHeight - height * 0.5 - 30) / 30);
			/*if (_groundContact)
			{
				if (_groundContact.IsTouching())
				{
					getStateByName("touchGround").phase = Process.BEGIN;
				}
				else
				{
					getStateByName("touchGround").phase = Process.END;
				}
			}*/
			
			
			
			//trace(getStateByName("touchGround").phase);
		}
		
		override protected function updateActions():void 
		{
			super.updateActions();
			_linearAngle.SetV(_linearVelocity.GetNegative());
			
			if (getStateByName("touchGround").phase == Process.BEGIN)
			{
				var particleFall1:CitrusSprite = CitrusEngine.getInstance().state.getObjectByName("particleFall1") as CitrusSprite;
				
				particleFall1.x = x;
				particleFall1.y = (CitrusEngine.getInstance().state.getObjectByName("ground") as Ground).y - particleFall1.height - height / 2 + 5;
				
				(particleFall1.view as MovieClip).currentFrame = 0;
				(particleFall1.view as MovieClip).play();
			}
			
		}
	
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.fixedRotation = false;
			//_bodyDef.angularDamping = 10;
			_bodyDef.linearDamping = 0.65;
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.m_customGravity = new b2Vec2(0, 5);
		}
		
		override protected function createShape():void
		{
			super.createShape();
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.density = 0.01;
			_fixtureDef.friction = 0.2;
			_fixtureDef.restitution = 0.3;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Ball");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();/*PhysicsCollisionCategories.GetAllExcept("Player");*/
			

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
				_body.m_customGravity = new b2Vec2(0, 5);
			}
		}
		
		public function get linearAngle():MathVector 
		{
			return _linearAngle;
		}
	}
}