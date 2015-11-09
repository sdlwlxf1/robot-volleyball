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
		
		[Embed(source="../../../embed/ball.png")]
		public static const Ball:Class;
		
		
		[Embed(source="../../../embed/Robot_output.swf", mimeType="application/octet-stream")]
		public static const Robot:Class;
		
		
		/**
		 * Texture Atlas 
		 */
		[Embed(source="../../../embed/games/hungryhero/graphics/mySpritesheet.png")]
		public static const Game:Class;
		
		[Embed(source="../../../embed/games/hungryhero/graphics/mySpritesheet.xml", mimeType="application/octet-stream")]
		public static const XML_Game:Class;
		
		
		/**
		 * Texture Cache 
		 */
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameSWF:Dictionary = new Dictionary();
		private static var gameTextureAtlas:Dictionary = new Dictionary();
		
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
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name]=Texture.fromBitmap(bitmap);
			}
			
			return gameTextures[name];
		}
		
		public static function getSWF(name:String):ByteArray
		{
			if (gameSWF[name] == undefined)
			{
				gameSWF[name] = new Assets[name]();
			}
			
			return gameSWF[name];
		}
	}
}
