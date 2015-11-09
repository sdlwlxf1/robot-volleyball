package gameObjects 
{
	import citrus.objects.CitrusSprite;
	import citrus.view.ISpriteView;
	import citrus.view.starlingview.StarlingView;
	import dragonBones.Armature;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.particles.PDParticleSystem;
	import objectPools.PoolParticle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ArithmeticParticle extends CitrusSprite 
	{		
		private var _tempSprite:Sprite;
		private var _relativeObjectView:DisplayObject;
		public var relativeObject:ISpriteView;		
		public var viewSprite:Sprite;		
		public var pdParticleSystem:PDParticleSystem;
		
		public var relativeScaleX:Number = 1;
		public var relativeScaleY:Number = 1;
		
		public var relativeX:Number = 0;
		public var relativeY:Number = 0;
		
		public var followType:Object;
		
		public var poolParticle:PoolParticle;
		
		public function ArithmeticParticle(name:String, params:Object=null) 
		{
			super(name, params);			
		}
		
		override public function initialize(poolObjectParams:Object = null):void 
		{
			super.initialize(poolObjectParams);
			_tempSprite = new Sprite();
			
			viewSprite = new Sprite();
			pdParticleSystem = view;
			Starling.juggler.add(pdParticleSystem);
			
			
			pdParticleSystem.scaleX = relativeScaleX;
			pdParticleSystem.scaleY = relativeScaleY;
			pdParticleSystem.x = relativeX;
			pdParticleSystem.y = relativeY;
			
			viewSprite.addChild(pdParticleSystem);
			view = viewSprite;
			
			if (relativeObject.view is Armature)
			{
				_relativeObjectView = (relativeObject.view as Armature).display as DisplayObject;
			}
			else
			{
				_relativeObjectView = relativeObject.view as DisplayObject;
			}
			
			//viewSprite.transformationMatrix = ((relativeObject.view as Armature).display as DisplayObject).getTransformationMatrix(((relativeObject.view as Armature).display as DisplayObject).stage);
			
			stop();
			
			updateCallEnabled = true;
		}

		override public function destroy():void 
		{
			pdParticleSystem.stop();
			pdParticleSystem.removeFromParent(true);
			Starling.juggler.remove(pdParticleSystem);
			super.destroy();

		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			
			render();
		}
		
		private function render():void
		{
			//_tempSprite.transformationMatrix = _relativeObjectView.getTransformationMatrix((_ce.state.view as StarlingView).viewRoot);
				
			if (followType["all"])
			{
				//viewSprite.transformationMatrix = _tempSprite.transformationMatrix;
			}
			else
			{
				if (followType["x"])
				{
					pdParticleSystem.emitterX = relativeObject.x;
				}
				if (followType["y"])
				{
					pdParticleSystem.emitterY = relativeObject.y;
				}
				if (followType["scaleX"])
				{
					viewSprite.scaleX = _tempSprite.scaleX;
				}
				if (followType["scaleY"])
				{
					viewSprite.scaleY = _tempSprite.scaleY;
				}
				if (followType["rotation"])
				{
					viewSprite.rotation = _tempSprite.rotation;
				}
			}
		}
		
		public function start():void
		{			
			render();
			pdParticleSystem.start();			
		}
		
		public function stop():void
		{
			pdParticleSystem.stop();
		}
		
		
		
	}

}