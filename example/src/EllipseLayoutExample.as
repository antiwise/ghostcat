package
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.events.TickEvent;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.ui.layout.EllipseLayout;
	import ghostcat.util.Util;
	import ghostcat.util.display.Geom;
	import ghostcat.util.easing.Elastic;
	import ghostcat.util.easing.TweenUtil;
	
	[SWF(width="500",height="300",frameRate="60")]
	
	/**
	 * 此类演示特殊布局以及布局类的单独使用方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class EllipseLayoutExample extends GBase
	{
		public var layout:EllipseLayout;
		
		protected override function init():void
		{
			//创建椭圆布局，并应用在this上
			layout = new EllipseLayout(this,true);
			mouseDownHandler(null);
			
			//加入一组字母
			for (var i:int = 0;i < 10;i++)
				addChild(TextFieldParse.createTextField(i.toString()))
			
			//加入一个图形
			addChild(new TestHuman());	
			//先强制布局一次
			layout.vaildLayout();
			
			//加入特效
			stage.addChildAt(Util.createObject(new ResidualScreen(stage.stageWidth,stage.stageHeight),{refreshInterval:10,fadeSpeed:0.9,blurSpeed:2,items:[this]}),0);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.enabledTick = true;
		}
		
		//根据鼠标位置调节布局旋转角
		protected override function tickHandler(event:TickEvent) : void
		{
			var p:Point = Geom.center(stage);
			var speed:Number = Point.distance(new Point(mouseX,mouseY),p)/100;
			layout.rotation += speed * speed * ((mouseX > p.x) ? 1 : -1);
			layout.invalidateLayout();
		}
		//鼠标点击时变化布局参数
		private function mouseDownHandler(event:MouseEvent):void
		{
			TweenUtil.removeAllTween();
			layout.paddingLeft = layout.paddingRight = layout.paddingTop = layout.paddingBottom = 150;
			TweenUtil.to(layout,3000,{paddingLeft:50,paddingRight:50,paddingTop:50,paddingBottom:50,ease: Elastic.easeOut});
		}
	}
}