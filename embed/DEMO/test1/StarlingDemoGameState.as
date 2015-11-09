package test1
{
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.platformer.box2d.Cannon;
	import citrus.objects.platformer.box2d.Crate;
	import citrus.objects.platformer.box2d.Hills;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.objects.platformer.box2d.MovingPlatform;
	import citrus.objects.platformer.box2d.RevolvingPlatform;
	import citrus.objects.platformer.box2d.Reward;
	import citrus.objects.platformer.box2d.RewardBox;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.objects.platformer.box2d.Teleporter;
	import citrus.objects.platformer.box2d.Treadmill;
	import citrus.view.spriteview.SpriteDebugArt;
	import citrus.view.starlingview.StarlingSpriteDebugArt;
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import flash.display.Bitmap;
	
	/**
	 * @author Aymeric
	 */
	public class StarlingDemoGameState extends StarlingState
	{
		
		[Embed(source="/../embed/Hero.xml",mimeType="application/octet-stream")]
		private var _heroConfig:Class;
		
		[Embed(source="/../embed/Hero.png")]
		private var _heroPng:Class;
		
		[Embed(source="../../embed/Robot_output.swf", mimeType="application/octet-stream")]
		private var ResourcesData:Class;
		
		private var _ce:CitrusEngine;
		
		private var _factory:StarlingFactory;
		private var _armature:Armature;
		
		public function StarlingDemoGameState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();			
			_ce = CitrusEngine.getInstance();
			
			//图片数据处理
			_factory = new StarlingFactory();
			_factory.parseData(new ResourcesData());
			_factory.addEventListener(Event.COMPLETE, _textureCompleteHandler);
			
			var bitmap:Bitmap = new _heroPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new _heroConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			//初始化box2D
			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			
			//墙壁
			add(new Platform("floor", { x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth, view:SpriteDebugArt } ));
			//add(new Platform("right", {x:0 - 10, y:stage.stageHeight / 2, height:stage.stageHeight, view:SpriteDebugArt}));
			//add(new Platform("left", { x:stage.stageWidth +10, y:stage.stageHeight / 2, height:stage.stageHeight, view:SpriteDebugArt } ));
			
			add(new Ball("ball", { radius:10, x:700, y:200, view:SpriteDebugArt } ));
			setTimeout(addObjects, 1000);
			
			//_ce.input.addController(new VirtualJoystick("joy"));
		
		}
		
		private function addObjects():void 
		{
			add(new Ball("ball", { radius:10, x:700, y:200, view:SpriteDebugArt } ));
			setTimeout(addObjects, 1000);
		}
		
		
		
		private function _textureCompleteHandler(e:Event):void 
		{
			_factory.removeEventListener(Event.COMPLETE, _textureCompleteHandler);

			_armature = _factory.buildArmature("robot");

			(_armature.display as Sprite).scaleY = 0.5;
			// the character is build on the left
			(_armature.display as Sprite).scaleX = 0.5;
			//_armature.animation.timeScale = 0.5;

			//初始化主角
			var robot:DynamicObject = new DynamicObject("robot", {x:250, y:480, width:(_armature.display as Sprite).width - 60, height:(_armature.display as Sprite).height, offsetY:-10, view:_armature, registration:"topLeft", invertedBody:false});
			robot.animationName = { "walk":"run", "jump":"float", "idle":"stop", "hurt":"pushUp", "duck":"oneLegStand", "runMode":"run2" };
			add(robot);
		}
		
		
		
		private function heroHurt():void
		{
			_ce.sound.playSound("Hurt", 1, 0);
		}
		
		private function heroAttack():void
		{
			_ce.sound.playSound("Kill", 1, 0);
		}
	
	}
}
