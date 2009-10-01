package
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.display.GTickBase;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.events.TickEvent;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.ui.layout.EllipseLayout;
	import ghostcat.util.display.Geom;
	import ghostcat.util.easing.TweenUtil;
	import ghostcat.util.Util;
	import ghostcat.util.easing.Elastic;
	
	[SWF(width="500",height="300",frameRate="60")]
	
	/**
	 * 此类演示特殊布局以及布局类的单独使用方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class EllipseLayoutExample extends GTickBase
	{
		public var layout:EllipseLayout;
		
		protected override function init():void
		{
			layout = new EllipseLayout(this,true);
			mouseDownHandler(null);
			
			for (var i:int = 0;i < 10;i++)
				addChild(TextFieldParse.createTextField(i.toString()))
		
			addChild(new TestHuman());	
			layout.vaildLayout();
		
			stage.addChildAt(Util.createObject(new ResidualScreen(stage.stageWidth,stage.stageHeight),{refreshInterval:10,fadeSpeed:0.9,blurSpeed:2,items:[this]}),0);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			var p:Point = Geom.center(stage);
			var speed:Number = Point.distance(new Point(mouseX,mouseY),p)/100;
			layout.rotation += speed * speed * ((mouseX > p.x) ? 1 : -1);
			layout.invalidateLayout();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			TweenUtil.removeAllTween();
			layout.paddingLeft = layout.paddingRight = layout.paddingTop = layout.paddingBottom = 150;
			TweenUtil.to(layout,3000,{paddingLeft:50,paddingRight:50,paddingTop:50,paddingBottom:50,ease: Elastic.easeOut});
		}
	}
}