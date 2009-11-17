package 
{
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.display.GBase;
	import ghostcat.display.bitmap.PixelItem;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.events.TickEvent;
	import ghostcat.util.display.ColorConvertUtil;
	
	[SWF(width="200",height="200",frameRate="60",backgroundColor="0xFFFFFF")]
	
	public class PixelExample extends GBase
	{
		public var s:ResidualScreen;
		public var p:PhysicsManager;
		public var c:Number = 0;
		
		public function PixelExample()
		{
			//创建位图显示
			s = new ResidualScreen(200,200,false,0);
			s.blurSpeed = 30;//扩散速度
//			s.colorTransform = new ColorTransform(1,1,1,1,-5,-5,0);
			addChild(s);
			
			//创建物理
			p = new PhysicsManager(onTick);
			p.gravity = new Point(0,50);//重力
			
			this.refreshInterval = 5;
		}
		
		private function onTick(v:PhysicsItem,inv:int):void
		{
			//落下屏幕则删除
			if (v.y > 500)
			{
				s.removeObject(v.target);
				p.remove(v.target);
			}
		}
		
		protected override function updateDisplayList() : void
		{
			c = (c < 0xFF) ? (c + 0.3) : 0;
			
			//新建点
			var item:PixelItem = new PixelItem(mouseX,mouseY,ColorConvertUtil.fromHSL(0xFF000000 + (c << 16) + 0xFF80));
			s.addObject(item);//加入显示
			p.add(item);//加入物理
			p.setVelocity(item,new Point((Math.random() - 0.5)*50,-100));//给予初速度
		}
	}
}