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

package test2.assets
{
	import starling.extensions.particles.ParticleSystem;
	import starling.extensions.particles.PDParticleSystem;
	import starling.textures.Texture;
	import test2.customObjects.Particle;
	/**
	 * This class holds all particle files.  
	 * 
	 * @author hsharma
	 * 
	 */
	public class Particles
	{
		/**
		 * Particle 
		 */
		/*[Embed(source="/../embed/games/hungryhero/Particles/particleCoffee.pex", mimeType="application/octet-stream")]
		public static var ParticleCoffeeXML:Class;
		
		[Embed(source="/../embed/games/hungryhero/Particles/particleMushroom.pex", mimeType="application/octet-stream")]
		public static var ParticleMushroomXML:Class;
		
		[Embed(source="/../embed/games/hungryhero/Particles/texture.png")]
		public static var ParticleTexture:Class;*/
		
		[Embed(source = "../../../embed/fire.pex", mimeType = "application/octet-stream")]
		public static var XML_Fire:Class;
		
		[Embed(source = "../../../embed/fire.png")]
		public static var Particle_Fire:Class;
		
		public static function getParticle(_Particlestyle:String):PDParticleSystem
		{
			if (Particles[_Particlestyle] == undefined)
			{
				var texture:Texture = Texture.fromBitmap(new Particles["Particle_" + _Particlestyle]());
				var xml:XML = XML(new Particles["XML_" + _Particlestyle]());
				Particles[_Particlestyle] = new PDParticleSystem(xml, texture);
			}
			
			return Particles[_Particlestyle];
		}
	}
}
