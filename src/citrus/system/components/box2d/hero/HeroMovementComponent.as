package citrus.system.components.box2d.hero {

	import Box2D.Common.Math.b2Vec2;

	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.system.components.InputComponent;
	import citrus.system.components.box2d.MovementComponent;

	import org.osflash.signals.Signal;

	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * The Box2D Hero movement component. Most of its properties are here. It uses a lot of informations from the input component and 
	 * some from the Box2D Hero collision component.
	 */
	public class HeroMovementComponent extends MovementComponent {
		
		//properties
		/**
		 * This is the rate at which the hero speeds up when you move him left and right. 
		 */
		public var acceleration:Number = 1;
		
		/**
		 * This is the fastest speed that the hero can move left or right. 
		 */
		public var maxVelocity:Number = 8;
		
		/**
		 * This is the initial velocity that the hero will move at when he jumps.
		 */
		public var jumpHeight:Number = 11;
		
		/**
		 * This is the amount of "float" that the hero has when the player holds the jump button while jumping. 
		 */
		public var jumpAcceleration:Number = 0.3;
		
		/**
		 * This is the y velocity that the hero must be travelling in order to kill a Enemy.
		 */
		public var killVelocity:Number = 3;
		
		/**
		 * The y velocity that the hero will spring when he kills an enemy. 
		 */
		public var enemySpringHeight:Number = 8;
		
		/**
		 * The y velocity that the hero will spring when he kills an enemy while pressing the jump button. 
		 */
		public var enemySpringJumpHeight:Number = 9;
		
		/**
		 * How long the hero is in hurt mode for. 
		 */
		public var hurtDuration:Number = 1000;
		
		/**
		 * The amount of kick-back that the hero jumps when he gets hurt. 
		 */
		public var hurtVelocityX:Number = 6;
		
		/**
		 * The amount of kick-back that the hero jumps when he gets hurt. 
		 */
		public var hurtVelocityY:Number = 10;
		
		/**
		 * Determines whether or not the hero's ducking ability is enabled.
		 */
		public var canDuck:Boolean = true;
		
		//events
		/**
		 * Dispatched whenever the hero jumps. 
		 */
		public var onJump:Signal;
		
		/**
		 * Dispatched whenever the hero gives damage to an enemy. 
		 */		
		public var onGiveDamage:Signal;
		
		/**
		 * Dispatched whenever the hero takes damage from an enemy. 
		 */		
		public var onTakeDamage:Signal;
		
		protected var _inputComponent:InputComponent;
		protected var _collisionComponent:HeroCollisionComponent;
		
		protected var _onGround:Boolean = false;
		protected var _springOffEnemy:Number = -1;
		protected var _hurtTimeoutID:uint;
		protected var _isHurt:Boolean = false;
		protected var _controlsEnabled:Boolean = true;
		protected var _playerMovingHero:Boolean = false;
		protected var _ducking:Boolean = false;

		public function HeroMovementComponent(name:String, params:Object = null) {
			
			super(name, params);
			
			onJump = new Signal();
			onGiveDamage = new Signal();
			onTakeDamage = new Signal();
		}
			
		override public function initialize(poolObjectParams:Object = null):void {
			
			super.initialize();
			
			_inputComponent = entity.lookupComponentByName("input") as InputComponent;
			_collisionComponent = entity.lookupComponentByName("collision") as HeroCollisionComponent;
		}
			
		override public function destroy():void {
			
			onJump.removeAll();
			onGiveDamage.removeAll();
			onTakeDamage.removeAll();
			
			clearTimeout(_hurtTimeoutID);
			
			super.destroy();
		}

		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);

			if (controlsEnabled && _physicsComponent) {
				
				var moveKeyPressed:Boolean = false;
				
				_ducking = (_inputComponent.isDoingDuck && _onGround && canDuck);
					
				if (_inputComponent.isDoingRight && !_ducking) {
					_velocity.Add(getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				if (_inputComponent.isDoingLeft && !_ducking) {					
					_velocity.Subtract(getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				//If player just started moving the hero this tick.
				if (moveKeyPressed && !_playerMovingHero) {
					_playerMovingHero = true;
					(_physicsComponent as HeroPhysicsComponent).changeFixtureToZero(); //Take away friction so he can accelerate.
				}
				//Player just stopped moving the hero this tick.
				else if (!moveKeyPressed && _playerMovingHero) {
					_playerMovingHero = false;
					(_physicsComponent as HeroPhysicsComponent).changeFixtureToItsInitialValue(); //Add friction so that he stops running
				}
				
				if (_onGround && _inputComponent.justDidJump && !_ducking) {
					_velocity.y = -jumpHeight;
					onJump.dispatch();
				}
				
				if (_inputComponent.isDoingJump && !_onGround && _velocity.y < 0)
					_velocity.y -= jumpAcceleration;
					
				if (_springOffEnemy != -1) {
					if (_inputComponent.isDoingJump)
						_velocity.y = -enemySpringJumpHeight;
					else
						_velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}
				
				//Cap velocities
				if (_velocity.x > maxVelocity)
					_velocity.x = maxVelocity;
				else if (_velocity.x < -maxVelocity)
					_velocity.x = -maxVelocity;
			}
		}
		
		/**
		 * The hero gives damage
		 */
		 
		public function giveDamage(collider:IBox2DPhysicsObject):void {
			
			_springOffEnemy = collider.y - _physicsComponent.height;
			onGiveDamage.dispatch();
		}
		
		/**
		 * Hurts and fling the hero, disables his controls for a little bit, and dispatches the onTakeDamage signal. 
		 */		
		public function hurt(collider:IBox2DPhysicsObject):void {
			
			_isHurt = true;
			controlsEnabled = false;
			_hurtTimeoutID = setTimeout(endHurtState, hurtDuration);
			onTakeDamage.dispatch();
			
			var hurtVelocity:b2Vec2 = _physicsComponent.body.GetLinearVelocity();
			hurtVelocity.y = -hurtVelocityY;
			hurtVelocity.x = hurtVelocityX;
			if (collider.x > _physicsComponent.x)
				hurtVelocity.x = -hurtVelocityX;
			_physicsComponent.body.SetLinearVelocity(hurtVelocity);
			
			//Makes sure that the hero is not frictionless while his control is disabled
			if (_playerMovingHero) {
				_playerMovingHero = false;
				(_physicsComponent as HeroPhysicsComponent).changeFixtureToItsInitialValue();
			}
		}
		
		protected function endHurtState():void {
			
			_isHurt = false;
			controlsEnabled = true;
		}
		
		protected function getSlopeBasedMoveAngle():b2Vec2 {
			return Box2DUtils.Rotateb2Vec2(new b2Vec2(acceleration, 0), _collisionComponent.combinedGroundAngle);
		}
		
		/**
		 * Whether or not the player can move and jump with the hero. 
		 */	
		public function get controlsEnabled():Boolean
		{
			return _controlsEnabled;
		}
		
		public function set controlsEnabled(value:Boolean):void
		{
			_controlsEnabled = value;
			
			if (!_controlsEnabled)
				(_physicsComponent as HeroPhysicsComponent).changeFixtureToItsInitialValue();
		}
		
		/**
		 * Returns true if the hero is on the ground and can jump. 
		 */		
		public function get onGround():Boolean {
			return _onGround;
		}
		
		public function set onGround(value:Boolean):void {
			_onGround = value;
		}

		public function get ducking():Boolean {
			return _ducking;
		}

		public function get isHurt():Boolean {
			return _isHurt;
		}
	}
}
