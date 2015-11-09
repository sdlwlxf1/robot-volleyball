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

package assets {

	import customObjects.Font;

	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	/**
	 * This class embeds the bitmap fonts used in the game. 
	 * 
	 * @author hsharma
	 * 
	 */
	public class Fonts
	{
		
		[Embed(source="../../embed/font/ArialFont.png")]
		public static const Font_Arial:Class;
		
		[Embed(source="../../embed/font/ArialFont.fnt", mimeType="application/octet-stream")]
		public static const XML_Arial:Class;
		
		[Embed(source = "../../embed/font/black.fnt", mimeType = "application/octet-stream")]
		public static const XML_black:Class;
		
		[Embed(source = "../../embed/font/black_0.png")]
		public static const Font_black:Class;
		
		[Embed(source = "../../embed/font/founder.fnt", mimeType = "application/octet-stream")]
		public static const XML_founder:Class;
		
		[Embed(source = "../../embed/font/founder_0.png")]
		public static const Font_founder:Class;
		
		[Embed(source = "../../embed/font/stencil.fnt", mimeType = "application/octet-stream")]
		public static const XML_stencil:Class;
		
		[Embed(source = "../../embed/font/stencil_0.png")]
		public static const Font_stencil:Class;
		
		[Embed(source = "../../embed/font/britannic.fnt", mimeType = "application/octet-stream")]
		public static const XML_britannic:Class;
		
		[Embed(source = "../../embed/font/britannic_0.png")]
		public static const Font_britannic:Class;
		
		[Embed(source = "../../embed/font/black1.fnt", mimeType = "application/octet-stream")]
		public static const XML_black1:Class;
		
		[Embed(source = "../../embed/font/black1_0.png")]
		public static const Font_black1:Class;
		
		[Embed(source = "../../embed/font/smooth.fnt", mimeType = "application/octet-stream")]
		public static const XML_smooth:Class;
		
		[Embed(source = "../../embed/font/smooth_0.png")]
		public static const Font_smooth:Class;
		
		
		[Embed(source="../../embed/font/magneto.fnt", mimeType="application/octet-stream")]
		public static const XML_magneto:Class;
		
		[Embed(source="../../embed/font/magneto_0.png")]
		public static const Font_magneto:Class;
		
		
		[Embed(source="../../embed/font/vrinda.fnt", mimeType="application/octet-stream")]
		public static const XML_vrinda:Class;
		
		[Embed(source="../../embed/font/vrinda_0.png")]
		public static const Font_vrinda:Class;
		
		[Embed(source="../../embed/font/harlowSolidItalic.fnt", mimeType="application/octet-stream")]
		public static const XML_harlowSolidItalic:Class;
		
		[Embed(source="../../embed/font/harlowSolidItalic_0.png")]
		public static const Font_harlowSolidItalic:Class;
		
		[Embed(source="../../embed/font/华文行楷.fnt", mimeType="application/octet-stream")]
		public static const XML_huawenxingkai:Class;
		
		[Embed(source="../../embed/font/华文行楷_0.png")]
		public static const Font_huawenxingkai:Class;
		
		/**
		 * Font objects.
		 */
		private static var Regular:BitmapFont;
		private static var ScoreLabel:BitmapFont;
		private static var ScoreValue:BitmapFont;
		private static var Arial:BitmapFont;
		
		/**
		 * Returns the BitmapFont (texture + xml) instance's fontName property (there is only oneinstance per app).
		 * @return String 
		 */
		public static function getFont(_fontStyle:String):Font
		{
			if (Fonts[_fontStyle] == undefined)
			{
				var texture:Texture = Texture.fromBitmap(new Fonts["Font_" + _fontStyle]());
				var xml:XML = XML(new Fonts["XML_" + _fontStyle]());
				Fonts[_fontStyle] = new BitmapFont(texture, xml);
				TextField.registerBitmapFont(Fonts[_fontStyle]);
			}
			
			return new Font(Fonts[_fontStyle].name, Fonts[_fontStyle].size);
		}
	}
}
