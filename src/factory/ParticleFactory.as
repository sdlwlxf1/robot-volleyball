package factory
{
	import citrus.core.CitrusEngine;
	import citrus.view.ISpriteView;
	import starling.display.BlendMode;
	import starling.display.MovieClip;
	import starling.extensions.particles.PDParticleSystem;
	import assets.Assets;
	import assets.Particles;
	import gameObjects.ArithmeticParticle;
	import gameObjects.MovieClipParticle;
	
    public class ParticleFactory extends Object
    {
		private var _movieClip:MovieClip;	
		private var _movieClipParticle:MovieClipParticle;	
		
		
		private var _arithmeticParticle:ArithmeticParticle;
		private var _pdParticleSystem:PDParticleSystem;
		
		
        public static const HIT_1:String = "hit1_";
        public static const HIT_2:String = "hit2_";
        public static const HAND_HIT_1:String = "handHit1_";
        public static const HAND_HIT_2:String = "handHit2_";
        public static const FOG_1:String = "fog1_";
		public static const FOG_2:String = "fog2_";
		public static const FOG_3:String = "fog3_";
		
		public static const EXPLODE_1:String = "ef33_";
		public static const EXPLODE_2:String = "cie53_";
		public static const FALL_1:String = "fall1_";
		public static const JUMP_1:String = "ef14_";
		
		public static const HIT_3:String = "cie531_";

		public var object:ISpriteView;
		
		
        public function ParticleFactory()
        {
            
        }
		
		public function createFog1():MovieClipParticle
		{
			return createMovieClipParticle(ParticleFactory.FOG_1, object);
		}
		
		public function createFog2():MovieClipParticle
		{
			return createMovieClipParticle(ParticleFactory.FOG_2, object);
		}
		
        public function createMovieClipParticle(type:String, relativeObject:ISpriteView = null):MovieClipParticle
        {
			var fps:Number = 50;
			var blendMode:String = BlendMode.ADD;
			var loop:Boolean = false;
			var relativeX:Number = 0;
			var relativeY:Number = 0;
			var relativeScaleX:Number = 0;
			var relativeScaleY:Number = 0;
			var followType:Object = {};
			
            switch(type)
            {
                case HIT_1:
                {
                    
                    break;
                }
                case HIT_2:
                {

                    break;
                }
                case HAND_HIT_1:
                {
					fps = 20;
					relativeScaleX = -3;
					relativeScaleY = 3;
					relativeX = -130;
					relativeY = -290;
					followType = {"last":false, "all":true};
                    break;
                }
                case HAND_HIT_2:
                {
					fps = 20;
					relativeScaleX = -3;
					relativeScaleY = 3;
					relativeX = -130;
					relativeY = -290;
					followType = {"last":false, "all":true };
                    break;
                }
                case FOG_1:
                {	
					fps = 50;
					relativeScaleX = -2;
					relativeScaleY = 2;
					relativeX = 50;
					relativeY = 0;
					followType = {"last":false, "all":true };
                    break;
                }
				
				case FOG_2:
                {	
					fps = 50;
					relativeScaleX = -2;
					relativeScaleY = 2;
					relativeX = 0;
					relativeY = 0;
					followType = {"last":false, "all":true };
                    break;
                }
				
				case FOG_3:
                {	
					fps = 25;
					relativeScaleX = -2;
					relativeScaleY = 2;
					relativeX = 50;
					relativeY = 0;
					followType = {"last":false, "all":true };
                    break;
                }
				
				case EXPLODE_1:
				{
					fps = 30;
					relativeScaleX = 1;
					relativeScaleY = 1;
					relativeX = 0;
					relativeY = -80;
					followType = {"last":false, "all":false, "x":true, "y":true/*, "scaleX":true, "scaleY":true */};
					loop = false;
					break;
				}
				
				case EXPLODE_2:
				{
					fps = 15;
					relativeScaleX = 0.7;
					relativeScaleY = 0.7;
					relativeX = 0;
					relativeY = -10;
					followType = {"last":false, "all":false, "x":true, "y":true/*, "scaleX":true, "scaleY":true */};
					loop = false;
					
					break;
				}
				
				case FALL_1:
				{
					fps = 10;
					relativeScaleX = 1;
					relativeScaleY = 1;
					relativeX = 0;
					relativeY = -20;
					followType = {"last":false, "all":false, "x":true, "y":true/*, "scaleX":true, "scaleY":true */};
					loop = false;
					blendMode = BlendMode.NORMAL;
					break;
				}
				
				
				case JUMP_1:
				{
					fps = 30;
					relativeScaleX = 0.5;
					relativeScaleY = 0.5;
					relativeX = -12;
					relativeY = 15;
					followType = {"last":false, "all":false, "x":true, "y":true/*, "scaleX":true, "scaleY":true */};
					loop = false;
					blendMode = BlendMode.ADD;
					break;
				}
				
				case HIT_3:
				{
					fps = 20;
					relativeScaleX = 0.8;
					relativeScaleY = 0.8;
					relativeX = 0;
					relativeY = 0;
					followType = {"last":false, "all":false, "x":true, "y":true/*, "scaleX":true, "scaleY":true */};
					loop = false;
					blendMode = BlendMode.SCREEN;
					break;
				}
       
                default:  
                    break;
					
            }
            
			_movieClip = new MovieClip(Assets.getMainAtlas().getTextures(type), fps);
			_movieClip.blendMode = blendMode;
			_movieClip.pivotX = _movieClip.width >> 1;
			_movieClip.pivotY = _movieClip.height >> 1;
			_movieClip.loop = loop;
			
			
			_movieClipParticle = new MovieClipParticle(type, { view:_movieClip, relativeObject:relativeObject, relativeScaleX:relativeScaleX, relativeScaleY:relativeScaleY, relativeX:relativeX, relativeY:relativeY , followType:followType} );
			CitrusEngine.getInstance().state.add(_movieClipParticle);			
			
            return _movieClipParticle;
        }
		
		
		public function createArithmeticParticle(type:String, relativeObject:ISpriteView = null):ArithmeticParticle
        {
			var fps:Number = 50;
			var loop:Boolean = false;
			var relativeX:Number = 0;
			var relativeY:Number = 0;
			var relativeScaleX:Number = 0;
			var relativeScaleY:Number = 0;
			var followType:Object = {};
			
            switch(type)
            {
				case Particles.FIRE:
				{
					fps = 30;
					relativeScaleX = 1;
					relativeScaleY = 1;
					relativeX = 0;
					relativeY = 0;
					followType = {"x":true, "y":true};
					loop = true;
					break;
				}
       
                default: 
                    break;
					
            }
			
			_pdParticleSystem = Particles.getParticle(type);
			
			_arithmeticParticle = new ArithmeticParticle(type, { view:_pdParticleSystem, relativeObject:relativeObject, relativeScaleX:relativeScaleX, relativeScaleY:relativeScaleY, relativeX:relativeX, relativeY:relativeY , followType:followType} );
			CitrusEngine.getInstance().state.add(_arithmeticParticle);			
			
            return _arithmeticParticle;
        }

    }
}
