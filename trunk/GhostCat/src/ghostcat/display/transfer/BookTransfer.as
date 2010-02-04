package ghostcat.display.transfer
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BookTransfer extends GTransfer
	{
		private var _point:Point = new Point();
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
			
			var p:Point = Point.interpolate(point,new Point(),0.5);
			var t:Point = Point.interpolate(point,new Point(),1);
			var step:Number = t.length / rect.bottomRight.length;
			var k:Number = p.y / p.x;
			var r:Number = Math.atan2(p.y,p.x);
//			y = p.y - (x - p.x) / k
			var p1:Point = new Point(0, p.y + p.x / k);
			if (p1.y > rect.height)
				p1 = new Point((p.y - rect.height) * k + p.x,rect.height);
					
			var p2:Point = new Point(p.y * k + p.x, 0);
			if (p2.x > rect.width)
				p2 = new Point(rect.width,p.y - (rect.width - p.x) / k);
					
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
				graphics.moveTo(rect.x + p2.x,rect.y + p2.y);
				graphics.lineTo(rect.right,rect.y);
				graphics.lineTo(rect.right,rect.bottom);
				graphics.lineTo(rect.x,rect.bottom);
				graphics.lineTo(rect.x + p1.x,rect.y + p1.y);
				graphics.endFill();
			}
			
			function drawFront():void
			{
				graphics.moveTo(rect.x + p2.x,rect.y + p2.y);
				if (p2.y)
					graphics.lineTo(rect.x + p2.x + p2.y * Math.cos(r * 2 - Math.PI / 2),rect.y + p2.y + p2.y * Math.sin(r * 2 - Math.PI / 2));
				graphics.lineTo(rect.x + t.x,rect.y + t.y);
				if (p1.x)
					graphics.lineTo(rect.x + p1.x + p1.x * Math.cos(r * 2),rect.y + p1.y + p1.x * Math.sin(r * 2));
				graphics.lineTo(rect.x + p1.x,rect.y + p1.y);
				graphics.endFill();
			}
		}
	}
}