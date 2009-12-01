package 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.community.physics.PhysicsUtil;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GBase;
	import ghostcat.display.bitmap.PixelItem;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.util.display.ColorConvertUtil;
	import ghostcat.util.display.DisplayUtil;
	
	[SWF(width="400",height="400",frameRate="60",backgroundColor="0xFFFFFF")]
	
	public class PixelExample extends GBase
	{
		public var s:ResidualScreen;
		public var p:PhysicsManager;
		public var c:Number = 0; 
		public var stageRect:Rectangle;
		public function PixelExample()
		{
			new EnabledSWFScreen(stage,function ():void{refreshInterval = 2},function ():void{refreshInterval = 0})
			
			stageRect = new Rectangle(0,0,400,400);
			//创建位图显示
			s = new ResidualScreen(400,400,false,0);
			s.blurSpeed = 20;
			addChild(s);
			
			//创建物理
			p = new PhysicsManager(onTick);
			p.gravity = new Point(0,50);//重力
			
			this.refreshInterval = 2;
		}
		
		private function onTick(v:PhysicsItem,inv:int):void
		{
			//离开屏幕则删除
			if (!stageRect.contains(v.x,v.y))
			{
				s.removeObject(v.target);
				p.remove(v.target);
			}
		}
		
		protected override function updateDisplayList() : void
		{
			PhysicsUtil.attract(p,new Point(s.mouseX,s.mouseY));
			
			c = (c < 0xFF) ? (c + 0.3) : 0;
			
			//新建点
			var item:PixelItem = new PixelItem(200,400,ColorConvertUtil.fromHSL(0xFF000000 + (c << 16) + 0xFF80));
			s.addObject(item);//加入显示
			p.add(item);//加入物理
			p.setVelocity(item,new Point((Math.random() - 0.5)*50,-100 + (Math.random() - 0.5)*20));//给予初速度
		}
	}
}