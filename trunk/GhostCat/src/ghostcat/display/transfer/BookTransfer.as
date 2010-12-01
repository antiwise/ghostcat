package ghostcat.display.transfer
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
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
		 * 阴影透明度 
		 */
		public var shadowAlpha:Number = 1.0;
		
		/**
		 * 左上角基准点 
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
		
		public var canvas:Shape;

		public function BookTransfer(target:DisplayObject=null)
		{
			this.canvas = new Shape();
			this.addChild(this.canvas);
			
			super(target);
		}
		
		/**
		 * 翻转图像以适应非左上角移动的情况
		 * @param h
		 * @param v
		 * 
		 */
		public function turn(h:Boolean,v:Boolean):void
		{
			this.canvas.scaleX = h ? -1 : 1;
			this.canvas.x = h ? bitmapData.width : 0;
			this.canvas.scaleY = v ? -1 : 1;
			this.canvas.y = v ? bitmapData.height : 0;
			
			showBitmapData();
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
			m.concat(this.canvas.transform.matrix);
			canvas.graphics.clear();
			canvas.graphics.beginBitmapFill(bitmapData,m,false);
			drawBack();
			
			m = new Matrix();
			m.createGradientBox(rect.width,rect.height,r,p.x,p.y);
			canvas.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[shadowAlpha * 0.75 * step,0.0],[0,50 * step],m);
			drawBack();
			
			m = new Matrix();
			m.createBox(1,1,0,rect.x,rect.y);
			m.concat(this.canvas.transform.matrix);
			m.scale(-1,1);
			m.rotate(r * 2);
			m.translate(t.x,t.y);
			canvas.graphics.beginBitmapFill(bitmapData,m,false);
			drawFront();
			
			m = new Matrix();
			m.createGradientBox(t.x - p.x,t.y - p.y,r,p.x,p.y);
			canvas.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[shadowAlpha * 0.5,0.0],[0,255],m);
			drawFront();
			
			function drawBack():void
			{
				if (op)
					return;
				
				canvas.graphics.moveTo(rect.x + p2.x,rect.y + p2.y);
				canvas.graphics.lineTo(rect.right,rect.y);
				canvas.graphics.lineTo(rect.right,rect.bottom);
				canvas.graphics.lineTo(rect.x,rect.bottom);
				canvas.graphics.lineTo(rect.x + p1.x,rect.y + p1.y);
				canvas.graphics.endFill();
			}
			
			function drawFront():void
			{
				if (op)
					canvas.graphics.moveTo(rect.x + op.x,rect.y + op.y);
				else
					canvas.graphics.moveTo(rect.x + p2.x,rect.y + p2.y);
				
				if (p2.y)
					canvas.graphics.lineTo(rect.x + p2.x + p2.y * Math.cos(r * 2 - Math.PI / 2),rect.y + p2.y + p2.y * Math.sin(r * 2 - Math.PI / 2));
				
				canvas.graphics.lineTo(rect.x + t.x,rect.y + t.y);
				
				if (p1.x)
					canvas.graphics.lineTo(rect.x + p1.x + p1.x * Math.cos(r * 2),rect.y + p1.y + p1.x * Math.sin(r * 2));
				
				if (!op)
					canvas.graphics.lineTo(rect.x + p1.x,rect.y + p1.y);
				
				canvas.graphics.endFill();
			}
		}
	}
}