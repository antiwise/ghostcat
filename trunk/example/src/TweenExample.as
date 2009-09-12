package
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	import ghostcat.filter.FilterProxy;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.RepeatOper;
	import ghostcat.operation.TimeoutOper;
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.DisplayParse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsRect;
	import ghostcat.util.TweenUtil;
	import ghostcat.util.Util;
	import ghostcat.util.easing.Elastic;
	
	public class TweenExample extends Sprite
	{
		public var sp:Sprite;
		public var f:FilterProxy;
		public function TweenExample()
		{
			RootManager.register(this,1,1);
			
			sp = DisplayParse.createSprite([new GraphicsFill(0xFFFFFF),new GraphicsRect(0,0,100,100,10)])
			addChild(sp);
			
			TweenUtil.from(sp,1000,{delay:500,x:100,tint:0xFF0000,ease:Elastic.easeIn,renderOnStart:true})
			TweenUtil.to(sp,1000,{delay:1500,x:100,tint:0x0000FF,ease:Elastic.easeOut});
			
			//利用滤镜代理来实现滤镜Tween
			f = new FilterProxy(new BlurFilter(0,0));
			f.applyFilter(sp);
			
			//利用Operation机制实现的顺序以及循环Tween
			(Util.createObject(DelayOper,{timeout:2000}) as DelayOper).commit();
			new RepeatOper([new TweenOper(f,1000,{blurX:20,blurY:20}),new TweenOper(f,1000,{blurX:0,blurY:0})]).commit();
			
		}
	}
}