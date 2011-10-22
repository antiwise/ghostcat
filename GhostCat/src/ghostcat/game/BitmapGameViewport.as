package ghostcat.game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.events.TickEvent;
	import ghostcat.game.layer.GameLayer;

	/**
	 * 位图场景 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapGameViewport extends GameViewport
	{
		public var screen:Bitmap;
		public function BitmapGameViewport(width:Number,height:Number,transparent:Boolean = false,fillColor:uint = 0xFFFFFF)
		{
			super();
			this.screen = new Bitmap(new BitmapData(width,height,transparent,fillColor));
			this.addChild(this.screen);
		}
		
		override public function addLayer(layer:GameLayer):void
		{
			layer.isBitmapEngine = true;
			layers[layers.length] = layer;
		}
		
		override public function removeLayer(layer:GameLayer):void
		{
			var index:int = layers.indexOf(layer);
			if (index != -1)
				layers.splice(index, 1);
		}
		
		public override function render():void
		{
			this.screen.bitmapData.fillRect(this.screen.bitmapData.rect,0xFFFFFF);
			for each (var layer:GameLayer in layers)
			{
				if (layer)
					layer.drawToBitmapData(this.screen.bitmapData,new Point());
			}
		}
	}
}