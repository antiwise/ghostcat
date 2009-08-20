package
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	import org.ghostcat.filter.FilterProxy;
	import org.ghostcat.manager.RootManager;
	import org.ghostcat.operation.DelayOper;
	import org.ghostcat.operation.RepeatOper;
	import org.ghostcat.operation.TimeoutOper;
	import org.ghostcat.operation.TweenOper;
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.parse.graphics.GraphicsFill;
	import org.ghostcat.parse.graphics.GraphicsRect;
	import org.ghostcat.util.TweenUtil;
	import org.ghostcat.util.Util;
	import org.ghostcat.util.easing.Elastic;
	
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
			new RepeatOper([
				new TweenOper(f,1000,{blurX:20,blurY:20}),
				new TweenOper(f,1000,{blurX:0,blurY:0})
			]).commit();
			
		}
	}
}