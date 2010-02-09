package ghostcat.display.transfer
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 翻页效果 
	 * @author flashyiyi
	 * 
	 */
	public class BookTransfer extends GTransfer
	{
		private var _point:Point = new Point();
		
		/**
		 * 基准点 
		 * @return 
		 * 
		 */
		public function get point():Point
		{
			return _point;
		}

		public function set point(value:Point):void
		{
			_point = value;
			invalidateRenderBitmap();
		}

		public function BookTransfer(target:DisplayObject=null)
		{
			super(target);
		}
		
		/** @inheritDoc*/
		protected override function showBitmapData() : void
		{
			var rect: Rectangle = _target.getBounds(_target);
			
			var t:Point = point.clone();
			if (t.x <= 0)
				t.x = 0.1;
			if (t.y <= 0)
				t.y = 0.1;
			
			var p:Point = Point.interpolate(t,new Point(),0.5);
			var step:Number = t.length / rect.bottomRight.length;
			var k:Number = p.y / p.x;
			var r:Number = Math.atan2(p.y,p.x);
//			y = p.y - (x - p.x) / k
			var p1:Point = new Point(0, p.y + p.x / k);
			if (p1.y > rect.height) //修正方折角
				p1 = new Point((p.y - rect.height) * k + p.x,rect.height);
					
			var p2:Point = new Point(p.y * k + p.x, 0);
			if (p2.x > rect.width)
				p2 = new Point(rect.width,p.y - (rect.width - p.x) / k);
			
			if (rect.y + p2.y > rect.bottom) //修正超出
			{
				var d:Number = (rect.y + p2.y - rect.bottom) * Math.sin(r) * 2;
				var op:Point = new Point(rect.width + Math.cos(r) * d, rect.height + Math.sin(r) * d);
			}
			
			var m:Matrix = new Matrix();
			m.createBox(1,1,0,rect.x,rect.y);
			graphics.clear();
			graphics.beginBitmapFill(bitmapData,m,false);
			drawBack();
			
			m = new Matrix();
			m.createGradientBox(rect.width,rect.height,r,p.x,p.y);
			graphics.beginGradientFill(GradientType.LINEAR,[0,0],[0.75 * step,0.0],[0,50 * step],m);
			drawBack();
			
			m = new Matrix();
			m.createBox(1,1,0,rect.x,rect.y);
			m.scale(-1,1);
			m.rotate(r * 2);
			m.translate(t.x,t.y);
			graphics.beginBitmapFill(bitmapData,m,false);
			drawFront();
			
			m = new Matrix();
			m.createGradientBox(t.x - p.x,t.y - p.y,r,p.x,p.y);
			graphics.beginGradientFill(GradientType.LINEAR,[0,0],[0.5,0.0],[0,255],m);
			drawFront();
			
			function drawBack():void
			{
				if (op)
					return;
				
				graphics.moveTo(rect.x + p2.x,rect.y + p2.y);
				graphics.lineTo(rect.right,rect.y);
				graphics.lineTo(rect.right,rect.bottom);
				graphics.lineTo(rect.x,rect.bottom);
				graphics.lineTo(rect.x + p1.x,rect.y + p1.y);
				graphics.endFill();
			}
			
			function drawFront():void
			{
				if (op)
					graphics.moveTo(rect.x + op.x,rect.y + op.y);
				else
					graphics.moveTo(rect.x + p2.x,rect.y + p2.y);
				
				if (p2.y)
					graphics.lineTo(rect.x + p2.x + p2.y * Math.cos(r * 2 - Math.PI / 2),rect.y + p2.y + p2.y * Math.sin(r * 2 - Math.PI / 2));
				
				graphics.lineTo(rect.x + t.x,rect.y + t.y);
				
				if (p1.x)
					graphics.lineTo(rect.x + p1.x + p1.x * Math.cos(r * 2),rect.y + p1.y + p1.x * Math.sin(r * 2));
				
				if (!op)
					graphics.lineTo(rect.x + p1.x,rect.y + p1.y);
				
				graphics.endFill();
			}
		}
	}
}