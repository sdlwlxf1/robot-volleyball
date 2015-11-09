package test2.factory
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
	import test2.assets.ArmatureFactory;
	import test2.assets.Assets;
	import test2.data.ArmData;
	import test2.data.PlayerData;
	import test2.data.ShoulderMotorData;
	import test2.data.WaistMotorData;
	import test2.gameObjects.Hand;
	import test2.gameObjects.Player;
	import test2.gameObjects.ViewObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerFactory extends Object
	{
		
		private var _playerData:PlayerData;
		private var _factory:StarlingFactory;
		private var _armature:Armature;
		private var _player:Player;
		private var _viewSprite:Sprite;
		private var _arm1:Hand;
		private var _arm2:Hand;
		private var _arm1Display:DisplayObject;
		private var _arm2Display:DisplayObject;
		
		private var _arm1Bone:Bone;
		private var _arm2Bone:Bone;
		private var _waistMotor1Bone:Bone;
		private var _waistMotor2Bone:Bone;
		private var _shoulderMotorBone:Bone;
		private var _particleHit1:CitrusSprite;
		private var _particleHit2:CitrusSprite;
		private var _particleHandHit1:CitrusSprite;
		private var _particleHandHit2:CitrusSprite;
		
		public function PlayerFactory()
		{
		
		}
		
		public function createPlayer(playerData:PlayerData, factory:StarlingFactory):Player
		{
			_playerData = playerData;
			_factory = factory;
			_armature = _factory.buildArmature(_playerData.armatureData.armaturePath);
			_viewSprite = _armature.display as Sprite;
			_viewSprite.scaleY = _playerData.scale;
			_viewSprite.scaleX = _playerData.scale;
			_armature.animation.timeScale = playerData.timeScale;
			
			if (playerData.equipArmData)
			{
				var _armImage1:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_playerData.equipArmData.path) as Image;
				var _armImage2:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_playerData.equipArmData.path2) as Image;
				
				_arm1Bone = _armature.getBone(_playerData.equipArmData.bone1);
				_arm2Bone = _armature.getBone(_playerData.equipArmData.bone2);
				
				_arm1Bone.display.dispose();
				_arm2Bone.display.dispose();
				_arm1Bone.display = _armImage1;
				_arm2Bone.display = _armImage2;
			}
			
			
			if (playerData.equipWaistMotorData)
			{
				var _waistMotorImage1:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_playerData.equipWaistMotorData.path) as Image;
				var _waistMotorImage2:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_playerData.equipWaistMotorData.path2) as Image;
				
				_waistMotor1Bone = _armature.getBone(_playerData.equipWaistMotorData.bone1);
				_waistMotor2Bone = _armature.getBone(_playerData.equipWaistMotorData.bone2);
				
				_waistMotor1Bone.display.dispose();
				_waistMotor2Bone.display.dispose();
				_waistMotor1Bone.display = _waistMotorImage1;
				_waistMotor2Bone.display = _waistMotorImage2;
			}
			
			if (playerData.equipShoulderMotorData)
			{
				var _shoulderMotorImage:Image = ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(_playerData.equipShoulderMotorData.path) as Image;
				
				_shoulderMotorBone = _armature.getBone(_playerData.equipShoulderMotorData.bone);
				
				_shoulderMotorBone.display.dispose();
				_shoulderMotorBone.display = _shoulderMotorImage;
			}
			
			//初始化主角
			_player = new Player(_playerData.name, {x: _playerData.startX, y: _playerData.startY, width: 50, height: _viewSprite.height, offsetY: 0, view: _armature, registration: "topLeft", data: _playerData});
			CitrusEngine.getInstance().state.add(_player);
			
			if (_playerData.equipArmData)
			{
				_arm1Display = _armature.getBone(_playerData.equipArmData.bone1).display as DisplayObject;
				_arm2Display = _armature.getBone(_playerData.equipArmData.bone2).display as DisplayObject;
			}
			else
			{
				_arm1Display = _armature.getBone("forearm").display as DisplayObject;
				_arm2Display = _armature.getBone("forearm_R").display as DisplayObject;
			}
			
			_arm1 = new Hand("forearm", {player: _player, invertedViewAndBody: _player.invertedViewAndBody, width: /*_arm1Display.width*/120 * _playerData.scale, height: _arm1Display.height * _playerData.scale, followView: _arm1Display /*, view:SpriteDebugArt*/});
			CitrusEngine.getInstance().state.add(_arm1);
			
			_arm2 = new Hand("forearm_R", {player: _player, invertedViewAndBody: _player.invertedViewAndBody, width: /*_arm2Display.width*/120 * _playerData.scale, height: _arm2Display.height * _playerData.scale, followView: _arm2Display /*, view:SpriteDebugArt*/});
			CitrusEngine.getInstance().state.add(_arm2);
			
			_player.hand1 = _arm1;
			_player.hand2 = _arm2;
			
			var hit1:MovieClip = new MovieClip(Assets.getMainAtlas().getTextures("hit1_"), 24);
			hit1.blendMode = BlendMode.SCREEN;
			hit1.pivotX = hit1.width >> 1;
			hit1.pivotY = hit1.height >> 1;
			hit1.loop = false;

			_particleHit1 = new CitrusSprite("particleHit1", { x:500, y:500, view:hit1 } );
			_player.particleHit1 = _particleHit1;
			CitrusEngine.getInstance().state.add(_particleHit1);
			
			var hit2:MovieClip = new MovieClip(Assets.getMainAtlas().getTextures("hit2_"), 45);
			hit2.blendMode = BlendMode.SCREEN;
			hit2.pivotX = hit2.width >> 1;
			hit2.pivotY = hit2.height >> 1;
			hit2.loop = false;

			_particleHit2 = new CitrusSprite("particleHit2", { x:500, y:500, view:hit2 } );
			_player.particleHit2 = _particleHit2
			CitrusEngine.getInstance().state.add(_particleHit2);
			
			
			var handHit1:MovieClip = new MovieClip(Assets.getMainAtlas().getTextures("handHit1_"), 24);
			handHit1.blendMode = BlendMode.SCREEN;
			handHit1.pivotX = handHit1.width >> 1;
			handHit1.pivotY = handHit1.height >> 1;
			handHit1.loop = false;

			_particleHandHit1 = new CitrusSprite("particleHandHit1", { x:500, y:500, view:handHit1 } );
			_player.particleHandHit1 = _particleHandHit1;
			CitrusEngine.getInstance().state.add(_particleHandHit1);
			
			var handHit2:MovieClip = new MovieClip(Assets.getMainAtlas().getTextures("handHit2_"), 30);
			handHit2.blendMode = BlendMode.SCREEN;
			handHit2.pivotX = handHit2.width >> 1;
			handHit2.pivotY = handHit2.height >> 1;
			handHit2.loop = false;

			_particleHandHit2 = new CitrusSprite("particleHandHit2", { x:500, y:500, view:handHit2 } );
			_player.particleHandHit2 = _particleHandHit2;
			CitrusEngine.getInstance().state.add(_particleHandHit2);
			
			
			_player.canAutoJump = playerData.canAutoJump;
			
			return _player;
		}
	
	}

}