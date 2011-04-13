package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 位图Grid-9（可以在放大时采用平铺方式）
	 * @author flashyiyi
	 * 
	 */
	public class BitmapGrid9Util
	{
		/**
		 * 通过Grid9算法获得新的位图 
		 * @param source
		 * @param width
		 * @param height
		 * @param scale9Grid
		 * @param isTile	采用平铺模式伸展
		 * @return 
		 * 
		 */
		public static function grid9(source:BitmapData,width:Number,height:Number,scale9Grid:Rectangle,isTile:Boolean = false):BitmapData
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
					result.copyPixels(source,new Rectangle(scale9Grid.x,0,scale9Grid.width,scale9Grid.y),new Point(scale9Grid.x + i * scale9Grid.width,0));
				
				//左
				for (i = 0;i < leny;i++)
					result.copyPixels(source,new Rectangle(0,scale9Grid.y,scale9Grid.x,scale9Grid.height),new Point(0,scale9Grid.y + i * scale9Grid.height));
				
				//中
				for (i = 0;i < leny;i++)
					for (var j:int = 0;j < lenx;j++)
						result.copyPixels(source,scale9Grid,new Point(scale9Grid.x + j * scale9Grid.width,scale9Grid.y + i * scale9Grid.height));
				
				//下
				for (i = 0;i < lenx;i++)
					result.copyPixels(source,new Rectangle(scale9Grid.x,scale9Grid.bottom,scale9Grid.width,source.height - scale9Grid.bottom),new Point(scale9Grid.x + i * scale9Grid.width,height - (source.height - scale9Grid.bottom)));
				
				//右
				for (i = 0;i < leny;i++)
					result.copyPixels(source,new Rectangle(scale9Grid.right,scale9Grid.y,source.width - scale9Grid.right,scale9Grid.height),new Point(width - (source.width - scale9Grid.right),scale9Grid.y + i * scale9Grid.height));
			}
			else
			{
				drawRectToRect(source,new Rectangle(scale9Grid.x,0,scale9Grid.width,scale9Grid.y),result,new Rectangle(scale9Grid.x,0,dx,scale9Grid.y));
				drawRectToRect(source,new Rectangle(0,scale9Grid.y,scale9Grid.x,scale9Grid.height),result,new Rectangle(0,scale9Grid.y,scale9Grid.x,dy));
				drawRectToRect(source,scale9Grid,result,new Rectangle(scale9Grid.x,scale9Grid.y,dx,dy));
				drawRectToRect(source,new Rectangle(scale9Grid.x,scale9Grid.bottom,scale9Grid.width,source.height - scale9Grid.bottom),result,new Rectangle(scale9Grid.x,scale9Grid.y + dy,scale9Grid.x + dx,height - (scale9Grid.y + dy)));
				drawRectToRect(source,new Rectangle(scale9Grid.right,scale9Grid.y,source.width - scale9Grid.right,scale9Grid.height),result,new Rectangle(scale9Grid.x + dx,scale9Grid.y,width - (scale9Grid.x + dx),scale9Grid.y + dy));
			}
			result.copyPixels(source,new Rectangle(0,0,scale9Grid.x,scale9Grid.y),new Point());
			result.copyPixels(source,new Rectangle(scale9Grid.right,0,source.width - scale9Grid.right,scale9Grid.y),new Point(width - (source.width - scale9Grid.right),0));
			result.copyPixels(source,new Rectangle(0,scale9Grid.bottom,scale9Grid.x,source.height - scale9Grid.bottom),new Point(0,height - (source.height - scale9Grid.bottom)));
			result.copyPixels(source,new Rectangle(scale9Grid.right,scale9Grid.bottom,source.width - scale9Grid.right,source.height - scale9Grid.bottom),new Point(width - (source.width - scale9Grid.right),height - (source.height - scale9Grid.bottom)));
			return result;
		}
		
		private static function drawRectToRect(source:BitmapData,sourceRect:Rectangle,target:BitmapData,targetRect:Rectangle):void
		{
			var bmd:BitmapData = new BitmapData(sourceRect.width,sourceRect.height);
			bmd.copyPixels(source,sourceRect,new Point());
			var m:Matrix = new Matrix();
			m.createBox(targetRect.width / bmd.width,targetRect.height / bmd.height,0,targetRect.x,targetRect.y);
			target.draw(bmd,m,null,null,null,true);
			bmd.dispose();
		}
		
		/**
		 * 根据显示对象的大小和scale9Grid自动转换Grid9 
		 * @param target	提供参照的对象容器，转换完的位图会替换其内容
		 * @param bitmapData	位图
		 * @param isTile	采用平铺模式伸展
		 */
		public static function autoGrid9(target:Sprite,bitmapData:BitmapData,isTile:Boolean = false,disposeSource:Boolean = true):void
		{
			if (!target.scale9Grid)
				return;
			
			var bitmap:Bitmap = new Bitmap(grid9(bitmapData,target.width,target.height,target.scale9Grid,isTile));
			
			while (target.numChildren)
				target.removeChildAt(0);
			
			target.scaleX = target.scaleY = 1.0;
			target.addChild(bitmap);
			
			if (disposeSource)
				bitmapData.dispose();
		}
	}
}