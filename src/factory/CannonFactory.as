package factory
{
	import citrus.core.CitrusEngine;
	import citrus.objects.CitrusSprite;
	import citrus.view.spriteview.SpriteDebugArt;
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.factorys.StarlingFactory;
	import flash.events.Event;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import assets.ArmatureFactory;
	import assets.Assets;
	import data.ArmData;
	import data.CannonData;
	import data.CannonData;
	import data.ShoulderMotorData;
	import data.WaistMotorData;
	import gameObjects.Cannon;
	import gameObjects.Gun;
	import gameObjects.MovieClipParticle;
	import gameObjects.ViewObject;
	import objectPools.PoolParticle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CannonFactory extends Object
	{
		
		private var _cannonData:CannonData;
		private var _factory:StarlingFactory;
		private var _armature:Armature;
		private var _cannon:Cannon;
		private var _viewSprite:Sprite;
		private var _gun:Gun;
		private var _gunDisplay:DisplayObject;
		
		private var _gunBone:Bone;

		
		private var _particleFactory:ParticleFactory;
		
		public function CannonFactory()
		{
		
		}
		
		public function createCannon(cannonData:CannonData, factory:StarlingFactory):Cannon
		{
			_cannonData = cannonData;
			_factory = factory;
			_armature = _factory.buildArmature(_cannonData.armatureData.armaturePath);
			_viewSprite = _armature.display as Sprite;
			_viewSprite.scaleY = _cannonData.scale;
			_viewSprite.scaleX = _cannonData.scale;
			_armature.animation.timeScale = cannonData.timeScale;
			
			/*if (cannonData.equipArmData)
			{
				var _armImage1:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_cannonData.equipArmData.path) as Image;
				var _armImage2:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_cannonData.equipArmData.path2) as Image;
				
				_gunBone = _armature.getBone(_cannonData.equipArmData.bone1);
				_arm2Bone = _armature.getBone(_cannonData.equipArmData.bone2);
				
				_gunBone.display.dispose();
				_arm2Bone.display.dispose();
				_gunBone.display = _armImage1;
				_arm2Bone.display = _armImage2;
			}
			
			
			if (cannonData.equipWaistMotorData)
			{
				var _waistMotorImage1:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_cannonData.equipWaistMotorData.path) as Image;
				var _waistMotorImage2:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_cannonData.equipWaistMotorData.path2) as Image;
				
				_waistMotor1Bone = _armature.getBone(_cannonData.equipWaistMotorData.bone1);
				_waistMotor2Bone = _armature.getBone(_cannonData.equipWaistMotorData.bone2);
				
				_waistMotor1Bone.display.dispose();
				_waistMotor2Bone.display.dispose();
				_waistMotor1Bone.display = _waistMotorImage1;
				_waistMotor2Bone.display = _waistMotorImage2;
			}
			
			if (cannonData.equipShoulderMotorData)
			{
				var _shoulderMotorImage:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_cannonData.equipShoulderMotorData.path) as Image;
				
				_shoulderMotorBone = _armature.getBone(_cannonData.equipShoulderMotorData.bone);
				
				_shoulderMotorBone.display.dispose();
				_shoulderMotorBone.display = _shoulderMotorImage;
			}*/
			
			//初始化
			_cannon = new Cannon(_cannonData.name, {group:1, x: _cannonData.startX, y: _cannonData.startY, width: _viewSprite.width / 2, height: _viewSprite.height, view: _armature, registration: "topLeft", data: _cannonData});
			CitrusEngine.getInstance().state.add(_cannon);
			
			/*if (_cannonData.equipArmData)
			{
				_gunDisplay = _armature.getBone(_cannonData.equipArmData.bone1).display as DisplayObject;
				_arm2Display = _armature.getBone(_cannonData.equipArmData.bone2).display as DisplayObject;
			}
			else
			{*/
			
			_gunDisplay = _armature.getBone("gunFire").display as DisplayObject;
			
			_gun = new Gun("gun", {cannon: _cannon, invertedViewAndBody: _cannon.invertedViewAndBody, bodyCenterX: -18, bodyCenterY: -80, width: _gunDisplay.width * _cannonData.scale, height: _gunDisplay.height * _cannonData.scale, followView: _gunDisplay /*, view:SpriteDebugArt*/});
			CitrusEngine.getInstance().state.add(_gun);
			
			_gun.armature = _armature.getBone("gunFire").childArmature;
			
			_cannon.gun = _gun;
			
			
			_particleFactory = new ParticleFactory();
			_particleFactory.object = _cannon;			
			_cannon.particleFactory = _particleFactory;	
			
			_cannon.fireRate = _cannonData.fireRate;
			
			/*_cannon.particleGunHit1 = _particleFactory.createMovieClipParticle(ParticleFactory.Gun_HIT_1, _cannon);

			_cannon.particleGunHit2 = _particleFactory.createMovieClipParticle(ParticleFactory.Gun_HIT_2, _cannon);		
			
			_cannon.particleFog3 = _particleFactory.createMovieClipParticle(ParticleFactory.FOG_3, _cannon);*/
			
			return _cannon;
		}	
			
	}	
	
}

