package org.ghostcat.bitmap.effect
{
	import flash.geom.Point;

	public class FireScreen extends ResidualScreen
	{
		public function FireScreen(width:Number,height:Number)
		{
			super(width,height);
			
			this.refreshInterval = 30;
			this.fadeSpeed = 0.9;
			this.blurSpeed = 12;
			this.offest = new Point(0,-4);
		}
		
		protected override function updateDisplayList() : void
		{
			super.updateDisplayList();
		} 
	}
}