package ghostcat.display.other
{
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	import ghostcat.display.GTickBase;
	import ghostcat.events.TickEvent;

	/**
	 * 跟随鼠标的光球
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class CircleLight extends GTickBase
	{
		public function CircleLight(radius:Number)
		{
			super();
			
			blendMode=BlendMode.ADD;
			
			var ma:Matrix=new Matrix();
			ma.createGradientBox(radius*2,radius*2,0,-radius,-radius);
			graphics.beginGradientFill(GradientType.RADIAL,[0xFFFFFF,0xFFFFFF],[0.8,0.0],[0,0xFF],ma);
			graphics.drawCircle(0,0,radius);
			graphics.endFill();
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			x += mouseX * event.interval / 300;
			y += mouseY * event.interval / 300;
		}
	}
}