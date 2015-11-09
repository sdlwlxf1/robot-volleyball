package gameObjects 
{
	import citrus.objects.CitrusSprite;
	import citrus.view.ISpriteView;
	import citrus.view.starlingview.StarlingView;
	import dragonBones.Armature;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import objectPools.PoolParticle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MovieClipParticle extends CitrusSprite 
	{
		
		public static const FOLLOW_XY:String = "xy";
		public static const FOLLOW_ALL:String = "all";
		
		public var relativeObject:ISpriteView;		
		public var viewSprite:Sprite;		
		public var movieClip:MovieClip;
		
		private var _relativeObjectView:DisplayObject;
		private var _tempSprite:Sprite;
		
		public var relativeScaleX:Number = 1;
		public var relativeScaleY:Number = 1;
		
		public var relativeX:Number = 0;
		public var relativeY:Number = 0;
		
		public var followType:Object;
		
		public var poolParticle:PoolParticle;
		
		public function MovieClipParticle(name:String, params:Object=null) 
		{
			super(name, params);			
		}
		
		override public function destroy():void 
		{
			super.destroy();

			Starling.juggler.remove(movieClip);
			movieClip.removeFromParent(true);
		}
		
		override public function initialize(poolObjectParams:Object = null):void 
		{
			super.initialize(poolObjectParams);
			
			_tempSprite = new Sprite()
			
			viewSprite = new Sprite();
			movieClip = view;
			Starling.juggler.add(movieClip);
			
			movieClip.scaleX = relativeScaleX;
			movieClip.scaleY = relativeScaleY;
			movieClip.x = relativeX;
			movieClip.y = relativeY;
			
			movieClip.addEventListener(Event.COMPLETE, onComplete);
			
			viewSprite.addChild(movieClip);
			view = viewSprite;
			
			if (relativeObject.view is Armature)
			{
				_relativeObjectView = (relativeObject.view as Armature).display as DisplayObject;
			}
			else
			{
				_relativeObjectView = relativeObject.view as DisplayObject;
			}
			/*if (followType["all"])
			{
				viewSprite.transformationMatrix = _relativeObjectView.getTransformationMatrix((_ce.state.view as StarlingView).viewRoot);
			}*/
			/*_relativeObjectView.stage*/
			
			stop();
			
			updateCallEnabled = true;
		}
		
		private function onComplete(e:Event):void 
		{
			if (poolParticle)
			{
				poolParticle.checkIn(this);
			}
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
		
			//trace(followType[(MovieClipParticle.FOLLOW_ALL)]);
			
			if (movieClip.isPlaying)
			{
				movieClip.alpha = 1;
			}
			else
			{
				movieClip.alpha = 0;
			}
			
			if (followType["last"])
			{
				render();
			}
		}
		
		private function render():void
		{
			_tempSprite.transformationMatrix = _relativeObjectView.getTransformationMatrix((_ce.state.view as StarlingView).viewRoot);
				
			if (followType["all"])
			{
				viewSprite.transformationMatrix = _tempSprite.transformationMatrix;
			}
			else
			{
				if (followType["x"])
				{
					viewSprite.x = relativeObject.x/*_tempSprite.x*/;
				}
				if (followType["y"])
				{
					viewSprite.y = relativeObject.y/*_tempSprite.y*/;
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
					viewSprite.rotation = relativeObject.rotation;
				}
			}
		}
		
		public function play():void
		{	
			
			render();
			
			movieClip.currentFrame = 0;
			movieClip.play();	
			
		}
		
		public function stop():void
		{
			movieClip.stop();
		} 
		
		
		
	}

}