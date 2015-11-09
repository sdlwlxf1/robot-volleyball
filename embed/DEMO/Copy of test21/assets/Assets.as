/**
 *
 * Hungry Hero Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2012 Hemanth Sharma (www.hsharma.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package test2.assets {

	import flash.utils.ByteArray;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	/**
	 * This class holds all embedded textures, fonts and sounds and other embedded files.  
	 * By using static access methods, only one instance of the asset file is instantiated. This 
	 * means that all Image types that use the same bitmap will use the same Texture on the video card.
	 * 
	 * @author hsharma
	 * 
	 */
	public class Assets
	{
		
		/**
		 * extra texture
		 */
		
		[Embed(source="../../../embed/Robot_output.swf", mimeType="application/octet-stream")]
		public static const Robot:Class;
		
		[Embed(source = "../../../embed/scene1.jpg")]
		public static const scene1:Class;
		
		[Embed(source = "../../../embed/scene2.jpg")]
		public static const scene2:Class;
		
		[Embed(source = "../../../embed/scene3.jpg")]
		public static const scene3:Class;
		
		[Embed(source = "../../../embed/scene4.jpg")]
		public static const scene4:Class;
		
		[Embed(source = "../../../embed/UIbackground.jpg")]
		public static const UIbackground:Class;
		
		[Embed(source = "../../../embed/developerText.png")]
		public static const developerText:Class;
		
		[Embed(source = "../../../embed/setKeyLine.png")]
		public static const setKeyLine:Class;
		
		
		/**
		 * Texture Atlas 
		 */
	
		[Embed(source = "../../../embed/gameSpriteSheet/GameSpritesheet.png")]
		public static const GameSpritesheet:Class;
		
		[Embed(source = "../../../embed/gameSpriteSheet/GameSpritesheet.xml", mimeType = "application/octet-stream")]
		public static const XML_GameSpritesheet:Class;
		
		
		
		/**
		 * XML
		 */
		[Embed(source="../../../embed/data/armature.xml", mimeType = "application/octet-stream")]
		public static const XML_Armature:Class;
		
		[Embed(source = "../../../embed/data/map.xml", mimeType = "application/octet-stream")]
		public static const XML_Map:Class;
		
		
		
		/**
		 * Texture Cache 
		 */
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameSWFs:Dictionary = new Dictionary();
		private static var gameTextureAtlas:Dictionary = new Dictionary();		
		private static var gameXMLs:Dictionary = new Dictionary();
		
		/**
		 * Returns the Texture atlas instance.
		 * @return the TextureAtlas instance (there is only oneinstance per app)
		 */
		public static function getAtlas(name:String):TextureAtlas
		{
			if (gameTextureAtlas[name] == undefined)
			{
				var texture:Texture = getTexture(name);
				var xml:XML = XML(new Assets["XML_" + name]());
				gameTextureAtlas[name] = new TextureAtlas(texture, xml);
			}
			
			return gameTextureAtlas[name];
		}
		
		public static function getMainAtlas():TextureAtlas
		{
			return gameTextureAtlas["GameSpritesheet"];
		}
		
		public static function getXML(name:String):XML
		{
			if (gameXMLs[name] == undefined)
			{
				var xml:XML = XML(new Assets["XML_" + name]());
				gameXMLs[name] = xml;
			}
			
			return gameXMLs[name];
		}
		
		/**
		 * Returns a texture from this class based on a string key.
		 * 
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling texture.
		 */
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				if (Assets[name])
				{
					var bitmap:Bitmap = new Assets[name]();
					gameTextures[name] = Texture.fromBitmap(bitmap);
				}
				else if(getAtlas("GameSpritesheet").getTexture(name))
				{
					gameTextures[name] = getAtlas("GameSpritesheet").getTexture(name);
				}
				else
				{
					gameTextures[name] = (ArmatureFactory.getStarlingFactory("Robot").getTextureDisplay(name) as Image).texture;
				}
			}
			
			return gameTextures[name];
		}
		
		public static function getSWF(name:String):ByteArray
		{
			/*if (gameSWF[name] == undefined)
			{*/
				gameSWFs[name] = new Assets[name]();
			/*}*/
			
			return gameSWFs[name];
		}
	}
}
