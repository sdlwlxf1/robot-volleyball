package assets
{
	import starling.extensions.particles.ParticleSystem;
	import starling.extensions.particles.PDParticleSystem;
	import starling.textures.Texture;
	import customObjects.Particle;
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
		
		[Embed(source="../../embed/particle/fire.pex", mimeType="application/octet-stream")]
		public static var XML_fire:Class;
		
		[Embed(source="../../embed/particle/fire.png")]
		public static var PNG_fire:Class;
		
		
		
		[Embed(source = "../../embed/particle/heroair.pex", mimeType = "application/octet-stream")]
		public static var XML_heroair:Class;
		
		[Embed(source = "../../embed/particle/heroair.png")]
		public static var PNG_heroair:Class;
		
		public static var HEROAIR:String = "heroair";
		
		[Embed(source = "../../embed/particle/smoke.pex", mimeType = "application/octet-stream")]
		public static var XML_smoke:Class;
		
		[Embed(source = "../../embed/particle/smoke.png")]
		public static var PNG_smoke:Class;
		
		public static var SMOKE:String = "smoke";
		
		[Embed(source = "../../embed/particle/fireworks.pex", mimeType = "application/octet-stream")]
		public static var XML_fireworks:Class;
		
		[Embed(source = "../../embed/particle/fireworks.png")]
		public static var PNG_fireworks:Class;
		
		
		[Embed(source = "../../embed/LOGO.swf")]
		public static const LOGO:Class;
		
		public static var FIRE:String = "fire";
		public static var FIREWORKS:String = "fireworks";
		
		public static function getParticle(_Particlestyle:String):PDParticleSystem
		{
			/*if (Particles[_Particlestyle] == undefined)
			{*/
				var texture:Texture = Texture.fromBitmap(new Particles["PNG_" + _Particlestyle]());
				var xml:XML = XML(new Particles["XML_" + _Particlestyle]());
				Particles[_Particlestyle] = new PDParticleSystem(xml, texture);
			//}
			
			return Particles[_Particlestyle];
		}
	}
}
