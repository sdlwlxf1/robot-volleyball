package ui 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import assets.Assets;
	
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class LifeMark extends Sprite 
	{
		private var lifeOnImage:Image;
		private var lifeOffImage:Image;
		
		public function LifeMark() 
		{
			super();
			
			lifeOnImage = new Image(Assets.getTexture("lifeOn"));
			lifeOnImage.pivotX = lifeOnImage.width >> 1;
			lifeOnImage.pivotY = lifeOnImage.height >> 1;
			lifeOnImage.alpha = 0;
			addChild(lifeOnImage);
			
			lifeOffImage = new Image(Assets.getTexture("lifeOver"));
			lifeOffImage.pivotX = lifeOffImage.width >> 1;
			lifeOffImage.pivotY = lifeOffImage.height >> 1;
			lifeOffImage.alpha = 0;
			addChild(lifeOffImage);
			
			setAlive();
		}
		
		public function setOver():void
		{
			lifeOnImage.alpha = 0;
			lifeOffImage.alpha = 1;
		}
		
		public function setAlive():void
		{
			lifeOnImage.alpha = 1;
			lifeOffImage.alpha = 0;
		}
		
	}

}