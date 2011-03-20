package ghostcat.display.transfer
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	
	/**
	 * 向上出现烟雾（未完成）
	 * @author flashyiyi
	 * 
	 */
	public class Boost extends GBitmapEffect
	{
		private var _enabledTickRender:Boolean;
		
		public function Boost(target:DisplayObject=null)
		{
			super();
			
			this.paddingTop = 50;
			this.paddingBottom = 0;
			this.paddingLeft = 50;
			this.paddingRight = 50;
			
			this.target = target;
		}
		
		public override function set target(value: DisplayObject): void
		{
			super.target = value;
			start();
		}
		
		public override function start():void
		{
			renderTarget();
			super.start();
		}
		
		protected override function renderTickHandler(event:TickEvent):void
		{
			bitmapData.colorTransform(bitmapData.rect,new ColorTransform(1,1,1,0.9));
			var temp:BitmapData = bitmapData.clone();
			bitmapData.fillRect(bitmapData.rect,0);
			
			var m:Matrix = new Matrix();
			m.translate(-temp.width / 2,-temp.height);
			m.scale(1.03,1.01);
			m.translate(temp.width / 2,temp.height)
			bitmapData.draw(temp,m);
			temp.dispose();
			
			bitmapData.scroll(0,-1);
			bitmapData.draw(normalBitmapData,null,new ColorTransform(0,0,0,0.1,255,255,0),BlendMode.ADD);
		}
	}
}