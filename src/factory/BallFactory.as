package factory 
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import starling.display.Image;
	import assets.Assets;
	import assets.Particles;
	import constants.StageConst;
	import data.BallFlipData;
	import gameObjects.Ball;
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class BallFactory extends Object 
	{
		
		public static const BALL_WHITE:uint = 1;
		public static const BALL_COLOR:uint = 2;
		
		private var _ce:CitrusEngine;
		private var _particleFactory:ParticleFactory;
		
		public function BallFactory() 
		{
			super();
			_ce = CitrusEngine.getInstance();
			_particleFactory = new ParticleFactory();
		}
		
		public function createBall(type:uint):Ball
		{
			var ballImage:Image;
			var ball:Ball;
			
			switch(type) {
				case BALL_WHITE:
					
					ballImage = new Image(Assets.getTexture("whiteBall"));
				
					break;
					
					
				case BALL_COLOR:
					
					ballImage = new Image(Assets.getTexture("colorBall"));
					
					break;
			}
			
			ballImage.scaleX = StageConst.stageWidth * 0.35 / 1000;
			ballImage.scaleY = StageConst.stageWidth * 0.35 / 1000;
			
			ball = new Ball("ball", {radius: (ballImage.height + 12) / 2, view:ballImage, ballType:type });
			_ce.state.add(ball);
			
			ball.particleFall1 = _particleFactory.createMovieClipParticle(ParticleFactory.FALL_1, ball);			
			ball.particleExplode1 = _particleFactory.createMovieClipParticle(ParticleFactory.EXPLODE_1, ball);
			ball.particleExplode2 = _particleFactory.createMovieClipParticle(ParticleFactory.EXPLODE_2, ball);
			ball.particleHit1 = _particleFactory.createMovieClipParticle(ParticleFactory.HIT_3, ball);
			
			
			ball.fireParticle = _particleFactory.createArithmeticParticle(Particles.FIRE, ball);				
			
			return ball;
			
		}
		
	}

}