package gameObjects {

	import aze.motion.easing.Cubic;
	import aze.motion.eaze;
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.physics.PhysicsCollisionCategories;
	import dragonBones.Armature;
	import dragonBones.objects.BoneTransform;
	import flash.utils.Timer;
	import data.BallFlipData;
	import factory.BallFactory;
	import factory.ParticleFactory;
	import logics.gameLogic.TrainSmashBall;
	import logics.Process;
	import math.MathVector;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * A cannon is an object which fires missiles. A cannon is a static body so it extends Platform.
	 * <ul>Properties:
	 * <li>fireRate : The frequency that missiles are fired.</li>
	 * <li>startingDirection : The direction that missiles are fired.</li>
	 * <li>openFire : Indicate if the cannon shoot at start or not.</li></ul>
	 * 
	 * <ul>Events:
	 * <li>onGiveDamage - Dispatched when the missile explodes on a Box2DPhysicsObject. Passes one parameter:
	 * 				  The Object it exploded on (Box2DPhysicsObject)</li></ul>
	 */
	public class Cannon extends DynamicObject {
		
		/**
		 * The frequency that missiles are fired.
		 */
		[Inspectable(defaultValue="2000")]
		private var _fireRate:Number = 1500;
		
		/**
		 * The direction that missiles are fired
		 */
		[Inspectable(defaultValue="right",enumeration="right,left")]
		public var startingDirection:String = "left";
		
		/**
		 * Indicate if the cannon shoot at start or not.
		 */
		[Inspectable(defaultValue="true")]
		public var openFire:Boolean = true;

		[Inspectable(defaultValue="20")]
		public var missileWidth:uint = 20;

		[Inspectable(defaultValue="20")]
		public var missileHeight:uint = 20;

		[Inspectable(defaultValue="2")]
		public var missileSpeed:Number = 2;

		[Inspectable(defaultValue="0")]
		public var missileAngle:Number = 0;

		[Inspectable(defaultValue="1000")]
		public var missileExplodeDuration:Number = 1000;

		[Inspectable(defaultValue="10000")]
		public var missileFuseDuration:Number = 10000;

		[Inspectable(defaultValue="",format="File",type="String")]
		public var missileView:* = MovieClip;

		/**
		 * Dispatched when the missile explodes on a Box2DPhysicsObject. Passes one parameter:
		 * 				  The Object it exploded on (Box2DPhysicsObject)
		 */
		public var onGiveDamage:Signal;

		protected var _firing:Boolean = false;

		protected var _timer:Timer;
		
		
		private var launchSpeed:b2Vec2 = new b2Vec2(-15, -6);
		private var _isStatic:Boolean;
		private var _linearAngle:MathVector = new MathVector();
		private var _ballFactory:BallFactory;
		private var _gunFireNode:BoneTransform;
		private var ball:Ball;
		private var _ballFlipData:BallFlipData;
		private var _rotateCount:int;
		
		private var _isFiring:Boolean = false;
		
		
		
		public var train:TrainSmashBall;
		public var onFire:Signal;
		
		public var camTarget:Object = { x: 0, y: 0 };
		
		public var onTouchGround:Signal;
		
		public var gun:Gun;
		public var particleFactory:ParticleFactory;
		public var onServe:Signal;

		public function Cannon(name:String, params:Object = null) {
			
			super(name, params);

			onGiveDamage = new Signal(Box2DPhysicsObject);
			onFire = new Signal();
			onServe = new Signal();
		}
			
		override public function initialize(poolObjectParams:Object = null):void {
			
			super.initialize(poolObjectParams);
			
			//_ce.onTimeScaleChange.add(timerRateChange);
			
			
			_gunFireNode = (view as Armature).getBone("gunFire").node;
			
			_ballFactory = new BallFactory();
			
			_timer = new Timer(_fireRate)// / _ce.timeScale);
			_timer.addEventListener(TimerEvent.TIMER, _fire);
			
			if (openFire)
				startFire();
		}

		override public function destroy():void {

			onGiveDamage.removeAll();
			//_ce.onPlayingChange.remove(_playingChanged);

			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _fire);

			super.destroy();
		}
		
		/**
		 * Dispatch onGiveDamage's Signal if a missile fired by the cannon explodes.
		 */
		protected function _damage(missile:Missile, contact:Box2DPhysicsObject):void {

			if (contact != null)
				onGiveDamage.dispatch(contact);
		}
		
		/**
		 * Cannon starts to fire. The timer is also started with the <code>fireRate</code>'s frequency.
		 */
		public function startFire():void {

			_firing = true;
			_updateAnimation();

			_timer.start();
			
			_ce.onPlayingChange.add(_playingChanged);
		}
		
		
		/**
		 * Cannon stops to fire, timer is stopped.
		 */
		public function stopFire():void {

			_firing = false;
			_updateAnimation();

			_timer.stop();
			
			_ce.onPlayingChange.remove(_playingChanged);
			
		}
		
		private function timerRateChange(value:Number):void 
		{
			_timer.delay = _fireRate / value;
			//trace(_timer.delay);
		}

		
		
		/**
		 * Cannon fires a missile. This missile called the <code>_damage</code> function on missile's explosion.
		 */
		protected function _fire(tEvt:TimerEvent):void 
		{
			if (_isFiring)
			{
				onFire.dispatch();
			}
		}
		
		public function fire(ballType:uint, ballFlipData:BallFlipData):void
		{
			_ballFlipData = ballFlipData;
			
			ball = _ballFactory.createBall(ballType);						
			
			ball.group = 1;
			
			ball.train = train;
			
			train.hud.addChild(ball.overSkyImage);
			ball.overSkyImage.alpha = 0;
			
			ball.x = x;
			ball.y = y;
			
			ball.body.SetActive(false);		
			
			_rotateCount = 0;
			eaze(_gunFireNode).to(fireRate / 1000, { rotation: _ballFlipData.angle + Math.PI / 2 } ).onComplete(serveBall);
			eaze(train.hud.accumulator1.bar).to(0, {height: 0}).to(fireRate / 1000, { height: train.hud.accumulator1.barHeight} );
			eaze(gun).delay(fireRate / 1000 - 0.3).onComplete(gunFire);
		}
		
		/*private function rotateGun():void 
		{
			_rotateCount++;
			train.hud.accumulator1.update(_rotateCount, 55);
		}*/
		
		private function gunFire():void 
		{
			gun.fire();
			_ce.sound.playSound("hit_body");
		}
		
		private function serveBall():void 
		{
			ball.body.SetLinearVelocity(_ballFlipData.powerVec);			
			ball.body.SetActive(true);
			
			ball.group = 0;
			
			onServe.dispatch(ball);
		}

		protected function _updateAnimation():void {
			
			_animation = _firing ? "fire" : "normal";
		}
		
		/**
		 * Start or stop the timer. Automatically called by the engine when the game is paused/unpaused.
		 */
		protected function _playingChanged(playing:Boolean):void {
			
			playing ? _timer.start() : _timer.stop();
		}
		
			override protected function updateStates():void 
		{
			super.updateStates();
			
		}
		
		override protected function updateActions():void 
		{
			super.updateActions();			
		}
	
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.fixedRotation = false;
			//_bodyDef.angularDamping = 10;
			_bodyDef.linearDamping = 0.85;
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.m_customGravity = new b2Vec2(0, 4);	
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
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Cannon");
			_fixtureDef.filter.maskBits = /*PhysicsCollisionCategories.GetAll();*/PhysicsCollisionCategories.GetAllExcept("Player", "Ball");
			

		}
		
		override protected function createFixture():void
		{
			super.createFixture();
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
		
		public function get fireRate():Number 
		{
			return _fireRate;
		}
		
		public function set fireRate(value:Number):void 
		{
			_fireRate = value;
			//_timer.delay = _fireRate / _ce.timeScale;
		}
		
		public function get isFiring():Boolean 
		{
			return _isFiring;
		}
		
		public function set isFiring(value:Boolean):void 
		{
			_isFiring = value;
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
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			super.handlePreSolve(contact, oldManifold);
		}
	}
}