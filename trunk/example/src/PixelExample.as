package 
{
	import flash.geom.Point;
	
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.display.GBase;
	import ghostcat.display.residual.PixelItem;
	import ghostcat.display.residual.PixelResidualScreen;
	import ghostcat.events.TickEvent;
	
	[SWF(width="200",height="200",backgroundColor="0xFFFFFF",frameRate="60")]
	
	public class PixelExample extends GBase
	{
		public var s:PixelResidualScreen;
		public var p:PhysicsManager;
		
		public function PixelExample()
		{
			s = new PixelResidualScreen(200,200);
			s.blurSpeed = 2;
			s.fadeSpeed = 0.98;
			addChild(s);
			p = new PhysicsManager();
			p.gravity = new Point(0,50);
			p.onTick = onTick;
			
			this.enabledTick = true;
		}
		
		private function onTick(v:PhysicsItem,inv:int):void
		{
			if (v.y > 500)
			{
				s.removeItem(v.target);
				p.remove(v.target);
			}
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			var item:PixelItem = new PixelItem(mouseX,mouseY,0xFFFF0000);
			s.addItem(item);
			p.add(item);
			p.setVelocity(item,new Point((Math.random() - 0.5)*50,-100))
		}
	}
}