package org.ghostcat.display.viewport
{
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import org.ghostcat.util.CallLater;

	/**
	 * 场景灯光类
	 * 
	 * 能够对物品生成投影，而且投影还可以在Wall对象上偏转
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Light extends Shape
	{
		private var _radius:Number = 0;
		private var _color:uint = 0xFFFFFF;
		
		public function Light(radius:Number,color:uint=0xFFFFFF,alpha:Number=0.5)
		{
			this.blendMode = BlendMode.SCREEN;
			this.radius = radius;
			this.color = color;
			this.alpha = alpha;
		}
		
		
		public function get color():uint
		{
			return _color;
		}

		public function set color(v:uint):void
		{
			_color = v;
			CallLater.callLater(render,null,true);
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(v:Number):void
		{
			_radius = v;
			CallLater.callLater(render,null,true);
		}
		
		protected function render():void
		{
			graphics.clear();
			var m:Matrix = new Matrix();
			m.createGradientBox(_radius*2,_radius*2,0,-_radius,-_radius);
			graphics.beginGradientFill(GradientType.RADIAL,[_color,_color],[1,0],[200,255],m);
			graphics.drawCircle(0,0,_radius);
			graphics.endFill();
		}

	}
}