package gameObjects 
{
	import citrus.core.CitrusEngine;
	import citrus.core.CitrusObject;
	import citrus.objects.CitrusSprite;
	import citrus.view.ACitrusView;
	import citrus.view.ISpriteView;
	import dragonBones.Armature;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MovieClipParticle 
	{
		
		public var relativeObject:ISpriteView;
		
		public var viewSprite:Sprite;
		
		public var movieClip:MovieClip;
		
		public var name:String = "";
		
		public function MovieClipParticle(name:String, movieClip:MovieClip, relativeObject:ISpriteView) 
		{			
			this.name = name;
			this.movieClip = movieClip;
			this.relativeObject = relativeObject;
			initialize();
		}
		
		public function initialize():void 
		{		
			viewSprite = new Sprite();
			viewSprite.addChild(movieClip);
			
			var particle:CitrusSprite = new CitrusSprite(name, { view:viewSprite } );
			CitrusEngine.getInstance().state.add(particle);	
			particle.updateCallEnabled = true;
		}
		
		public function update():void 
		{
			movieClip.play();
			viewSprite.transformationMatrix = ((relativeObject.view as Armature).display as DisplayObject).getTransformationMatrix(((relativeObject.view as Armature).display as DisplayObject).stage);
		}
		
		public function play():void
		{
			movieClip.play();
		}
		
		public function stop():void
		{
			movieClip.stop();
		}
	}

}