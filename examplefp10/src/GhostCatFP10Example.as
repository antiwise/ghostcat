package 
{
	import asset.Panel3D;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	import ghostcat.community.sort.Sort3DManager;
	import ghostcat.display.GBase;
	import ghostcat.display.g3d.GBitmapSphere;
	import ghostcat.events.TickEvent;
	import ghostcat.util.easing.TweenUtil;
	

	[SWF(width="500",height="500",backgroundColor="0")]
	public class GhostCatFP10Example extends GBase
	{
		[Embed("earth.jpg")]
		public var cls:Class;
		public var sphere:GBitmapSphere;
		
		protected override function init():void
		{
			sphere = new GBitmapSphere(new cls().bitmapData);
			sphere.x = 250;
			sphere.y = 250;
			sphere.z = 0;
			
			addChild(sphere);
			
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			super.tickHandler(event);
			sphere.rotateSphere(0,1,0);
		}
	}
}