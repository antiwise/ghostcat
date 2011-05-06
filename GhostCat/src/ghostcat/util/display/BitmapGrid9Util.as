package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 位图Grid-9
	 * @author flashyiyi
	 * 
	 */
	public class BitmapGrid9Util
	{
		/**
		 * 通过Grid9算法获得新的位图，具体实现类为GBitmap
		 * @see ghostcat.display.bitmap.GBitmap
		 * 
		 * @param source	位图源
		 * @param width	新的宽度
		 * @param height	新的高度
		 * @param scale9Grid	Grid9缩放范围
		 * @param isTile	采用平铺模式伸展
		 * @return 
		 * 
		 */
		public static function grid9(source:BitmapData,width:Number,height:Number,scale9Grid:Rectangle,isTile:Boolean = false):BitmapData
		{
			var result:BitmapData = new BitmapData(width,height,source.transparent,0);
			drawAll(result,source,width,height,scale9Grid,isTile);
			return result;
		}
		
		/**
		 * 通过Grid9算法将位图绘制到一个元件上，具体实现类为BitmapGrid9Shape
		 * @see ghostcat.display.bitmap.BitmapGrid9Shape
		 * 
		 * @param graphics	绘制目标
		 * @param source	位图源
		 * @param width	新的宽度
		 * @param height	新的高度
		 * @param scale9Grid	Grid9缩放范围
		 * @param isTile	采用平铺模式伸展
		 * 
		 */
		public static function renderGrid9Shape(graphics:Graphics,source:BitmapData,width:Number,height:Number,scale9Grid:Rectangle,isTile:Boolean = false):void
		{
			graphics.clear();
			drawAll(graphics,source,width,height,scale9Grid,isTile)
		}
		
		private static function drawAll(target:*,source:BitmapData,width:Number,height:Number,scale9Grid:Rectangle,isTile:Boolean = false):void
		{
			if (!scale9Grid)
			{
				drawRectToRect(source,source.rect,target,new Rectangle(0,0,width,height));
			}
			else
			{
				var right:int = width - scale9Grid.right;
				var bottom:int = height - scale9Grid.bottom;
				var result:BitmapData = new BitmapData(width,height,source.transparent,0);
				var i:int;
				var len:int;
				var dx:int = width - scale9Grid.x - (source.width - scale9Grid.right);
				var dy:int = height - scale9Grid.y - (source.height - scale9Grid.bottom);
				if (isTile)
				{
					var lenx:int = Math.ceil(dx / scale9Grid.width);
					var leny:int = Math.ceil(dy / scale9Grid.height);
					
					//上
					for (i = 0;i < lenx;i++)
						drawRectToPoint(source,new Rectangle(scale9Grid.x,0,scale9Grid.width,scale9Grid.y),target,new Point(scale9Grid.x + i * scale9Grid.width,0));
					
					//左
					for (i = 0;i < leny;i++)
						drawRectToPoint(source,new Rectangle(0,scale9Grid.y,scale9Grid.x,scale9Grid.height),target,new Point(0,scale9Grid.y + i * scale9Grid.height));
					
					//中
					for (i = 0;i < leny;i++)
						for (var j:int = 0;j < lenx;j++)
							drawRectToPoint(source,scale9Grid,target,new Point(scale9Grid.x + j * scale9Grid.width,scale9Grid.y + i * scale9Grid.height));
					
					//下
					for (i = 0;i < lenx;i++)
						drawRectToPoint(source,new Rectangle(scale9Grid.x,scale9Grid.bottom,scale9Grid.width,source.height - scale9Grid.bottom),target,new Point(scale9Grid.x + i * scale9Grid.width,height - (source.height - scale9Grid.bottom)));
					
					//右
					for (i = 0;i < leny;i++)
						drawRectToPoint(source,new Rectangle(scale9Grid.right,scale9Grid.y,source.width - scale9Grid.right,scale9Grid.height),target,new Point(width - (source.width - scale9Grid.right),scale9Grid.y + i * scale9Grid.height));
					
				}
				else
				{
					drawRectToRect(source,new Rectangle(scale9Grid.x,0,scale9Grid.width,scale9Grid.y),target,new Rectangle(scale9Grid.x,0,dx,scale9Grid.y));
					drawRectToRect(source,new Rectangle(0,scale9Grid.y,scale9Grid.x,scale9Grid.height),target,new Rectangle(0,scale9Grid.y,scale9Grid.x,dy));
					drawRectToRect(source,scale9Grid,target,new Rectangle(scale9Grid.x,scale9Grid.y,dx,dy));
					drawRectToRect(source,new Rectangle(scale9Grid.x,scale9Grid.bottom,scale9Grid.width,source.height - scale9Grid.bottom),target,new Rectangle(scale9Grid.x,scale9Grid.y + dy,dx,height - (scale9Grid.y + dy)));
					drawRectToRect(source,new Rectangle(scale9Grid.right,scale9Grid.y,source.width - scale9Grid.right,scale9Grid.height),target,new Rectangle(scale9Grid.x + dx,scale9Grid.y,width - (scale9Grid.x + dx),dy));
				}
				drawRectToPoint(source,new Rectangle(0,0,scale9Grid.x,scale9Grid.y),target,new Point());
				drawRectToPoint(source,new Rectangle(scale9Grid.right,0,source.width - scale9Grid.right,scale9Grid.y),target,new Point(scale9Grid.x + dx,0));
				drawRectToPoint(source,new Rectangle(0,scale9Grid.bottom,scale9Grid.x,source.height - scale9Grid.bottom),target,new Point(0,scale9Grid.y + dy));
				drawRectToPoint(source,new Rectangle(scale9Grid.right,scale9Grid.bottom,source.width - scale9Grid.right,source.height - scale9Grid.bottom),target,new Point(scale9Grid.x + dx,scale9Grid.y + dy));
			}
		}
		
		private static function drawRectToPoint(source:BitmapData,sourceRect:Rectangle,target:*,targetRect:Point):void
		{
			if (target is Graphics)
			{
				var m:Matrix = new Matrix();
				m.translate(targetRect.x - sourceRect.x,targetRect.y - sourceRect.y);
				target.beginBitmapFill(source,m);
				target.drawRect(targetRect.x,targetRect.y,sourceRect.width,sourceRect.height);
				target.endFill();
			}
			else if (target is BitmapData)
			{
				target.copyPixels(source,sourceRect,targetRect);
			}
		}
		
		private static function drawRectToRect(source:BitmapData,sourceRect:Rectangle,target:*,targetRect:Rectangle):void
		{
			if (target is Graphics)
			{
				var m:Matrix = new Matrix();
				m.translate(-sourceRect.x,-sourceRect.y);
				m.scale(targetRect.width / sourceRect.width,targetRect.height / sourceRect.height);
				m.translate(targetRect.x,targetRect.y);
				target.beginBitmapFill(source,m);
				target.drawRect(targetRect.x,targetRect.y,targetRect.width,targetRect.height);
				target.endFill();
			}
			else if (target is BitmapData)
			{
				var bmd:BitmapData = new BitmapData(sourceRect.width,sourceRect.height);
				bmd.copyPixels(source,sourceRect,new Point());
			 	m = new Matrix();
				m.createBox(targetRect.width / bmd.width,targetRect.height / bmd.height,0,targetRect.x,targetRect.y);
				target.draw(bmd,m,null,null,null,true);
				bmd.dispose();
			}
		}
	}
}