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

package test2.customObjects
{
	/**
	 * This class stores the properties of a Particle -
	 * 		Particle Name
	 * 		Particle Size
	 * 		Particle Color
	 * 
	 * @author hsharma
	 * 
	 */
	public final class Particle
	{
		private var _ParticleName:String;
		
		public function Particle(ParticleName:String)
		{
			this.ParticleName = ParticleName;
		}

		/**
		 * Particle Name. 
		 * @return 
		 * 
		 */
		public function get ParticleName():String
		{
			return _ParticleName;
		}

		public function set ParticleName(value:String):void
		{
			_ParticleName = value;
		}
	}
}