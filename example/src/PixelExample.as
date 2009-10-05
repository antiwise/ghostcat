package 
{
	import flash.geom.Point;
	
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.display.GBase;
	import ghostcat.display.residual.PixelItem;
	import ghostcat.display.residual.PixelResidualScreen;
	import ghostcat.events.TickEvent;
	
	[SWF(width="200",height="200",frameRate="60")]
	
	public class PixelExample extends GBase
	{
		public var s:PixelResidualScreen;
		public var p:PhysicsManager;
		
		public function PixelExample()
		{
			//创建位图显示
			s = new PixelResidualScreen(200,200);
			s.blurSpeed = 2;//扩散速度
			s.fadeSpeed = 0.98;//渐消速度
			addChild(s);
			
			//创建物理
			p = new PhysicsManager(onTick);
			p.gravity = new Point(0,50);//重力
			
			this.enabledTick = true;
		}
		
		private function onTick(v:PhysicsItem,inv:int):void
		{
			//落下屏幕则删除
			if (v.y > 500)
			{
				s.removeItem(v.target);
				p.remove(v.target);
			}
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			//新建点
			var item:PixelItem = new PixelItem(mouseX,mouseY,0xFFFF0000);
			s.addItem(item);//加入显示
			p.add(item);//加入物理
			p.setVelocity(item,new Point((Math.random() - 0.5)*50,-100));//给予初速度
		}
	}
}