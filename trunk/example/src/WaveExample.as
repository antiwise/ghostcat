package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.filter.DisplacementMapFilterProxy;
	
	[SWF(width="1000",height="1000")]
	public class WaveExample extends Sprite
	{
		[Embed(source="p1.jpg")]
		public var cls:Class;
		public function WaveExample()
		{
			addChild(new cls());
			
			var f:DisplacementMapFilterProxy = new DisplacementMapFilterProxy(DisplacementMapFilterProxy.BUBBLE);
			f.pos = new Point(100,100);
			f.applyFilter(this);
		}
	}
}