package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 可以拥有无限大小（仅受内存限制）的BitmapData
	 * @author flashyiyi
	 * 
	 */
	public class BitmapDataSource extends EventDispatcher
	{
		/**
		 * 位图最大宽高
		 */
		public var MAX_SIZE:int = 2880;
		
		/**
		 * 位图数组
		 */
		public var bitmapDatas:Array;
		
		private var _width:int;
		private var _height:int;
		private var _transparent:Boolean;
		private var _fillColor:uint;
		
		private var lx:int;
		private var ly:int;
		private var ex:int;
		private var ey:int;
		
		/**
		 * 宽度 
		 * @return 
		 * 
		 */
		public function get width():int
		{
			return _width;
		}
		
		/**
		 * 高度 
		 * @return 
		 * 
		 */
		public function get height():int
		{
			return _height;
		}
		
		/**
		 * 是否透明
		 */
		public function get transparent():Boolean
		{
			return _transparent;
		}
		
		/**
		 * 背景色
		 */
		public function get fillColor():uint
		{
			return _fillColor;
		}
		
		/**
		 * 图形大小
		 * @return 
		 * 
		 */
		public function get rect():Rectangle
		{
			return new Rectangle(0,0,_width,_height);
		}
		
		public function BitmapDataSource(width:int,height:int,transparent:Boolean = true,fillColor:uint = 0x00FFFFFF)
		{
			this._width = width;
			this._height = height;
			this._transparent = transparent; 
			this._fillColor = fillColor;
		
			createBitmapDatas();
		}
		protected function createBitmapDatas():void
		{
			bitmapDatas = [];
			
			lx = _width / MAX_SIZE;
			ly = _height / MAX_SIZE;
			ex = _width % MAX_SIZE;
			ey = _height % MAX_SIZE;
			
			for (var j:int = 0;j < ly;j++)
			{
				for (var i:int = 0;i < lx;i++)
					bitmapDatas.push(new BitmapData(MAX_SIZE,MAX_SIZE,transparent,fillColor));
			
				if (ex > 0)
					bitmapDatas.push(new BitmapData(ex,MAX_SIZE,transparent,fillColor));
			}
			if (ey > 0)
			{
				for (i = 0;i < lx;i++)
					bitmapDatas.push(new BitmapData(MAX_SIZE,ey,transparent,fillColor));
				
				bitmapDatas.push(new BitmapData(ex,ey,transparent,fillColor));
			}			
		}
		
		/**
		 * 导出位图
		 * 
		 * @param target
		 * @param sourceRect
		 * @param destPoint
		 * 
		 */
		public function copyPixelsTo(target:BitmapData,sourceRect:Rectangle,destPoint:Point = null):void
		{
			if (!destPoint)
				destPoint = new Point();
			
			for (var i:int = 0; i < bitmapDatas.length;i++)
			{
				var bitmap:BitmapData = bitmapDatas[i] as BitmapData;
				var rect:Rectangle = getBitmapRect(i);
				var offest:Point = rect.topLeft;
				rect = rect.intersection(sourceRect);
				if (!rect.isEmpty())
				{
					var localPoint:Point = offest.subtract(sourceRect.topLeft);
					rect.offset(-offest.x,-offest.y)
					target.copyPixels(bitmap,rect,localPoint);
				}
			}
		}
		
		/**
		 * 获得一个区域的BitmapData
		 * 
		 * @param target
		 * @param sourceRect
		 * @return 
		 * 
		 */
		public function getBitmapData(sourceRect:Rectangle):BitmapData
		{
			var bitmap:BitmapData = new BitmapData(sourceRect.width,sourceRect.height,transparent,fillColor);
			copyPixelsTo(bitmap,sourceRect);
			return bitmap;
		}
		
		/**
		 * 从外部拷贝位图数据
		 * @param source
		 * @param sourceRect
		 * @param destPoint
		 * 
		 */
		public function copyPixels(source:BitmapData,sourceRect:Rectangle,destPoint:Point = null):void
		{
			if (!destPoint)
				destPoint = new Point();
			
			var targetRect:Rectangle = new Rectangle(destPoint.x,destPoint.y,sourceRect.width,sourceRect.height);
			
			for (var i:int = 0; i < bitmapDatas.length;i++)
			{
				var bitmap:BitmapData = bitmapDatas[i] as BitmapData;
				var rect:Rectangle = getBitmapRect(i);
				var offest:Point = rect.topLeft;
				rect = rect.intersection(targetRect);
				if (!rect.isEmpty())
				{
					var localPoint:Point = destPoint.subtract(offest);
					bitmap.copyPixels(source,sourceRect,localPoint);
				}
			}
		}
		
		/**
		 * 在位图上绘制
		 * 
		 * @param source
		 * @param matrix
		 * @param colorTransform
		 * @param blendMode
		 * @param clipRect
		 * @param smoothing
		 * 
		 */
		public function draw(source:IBitmapDrawable,matrix:Matrix = null,colorTransform:ColorTransform = null,blendMode:String = null,clipRect:Rectangle = null,smoothing:Boolean=false):void
		{
			for (var i:int = 0; i < bitmapDatas.length;i++)
			{
				var bitmap:BitmapData = bitmapDatas[i] as BitmapData;
				var rect:Rectangle = getBitmapRect(i);
				var m:Matrix = new Matrix();
				if (matrix)
					m.concat(matrix);
				m.translate(-rect.x,-rect.y)
				bitmap.draw(source,m,colorTransform,blendMode,clipRect,smoothing);
			}
		}
		
		/**
		 * 获得索引处的位图矩形
		 * @param index
		 * @return 
		 * 
		 */
		protected function getBitmapRect(index:int):Rectangle
		{
			var x:int = index % (lx + (ex ? 1 : 0));
			var y:int = index / (ly + (ey ? 1 : 0));
			
			var bitmap:BitmapData = bitmapDatas[index] as BitmapData;
			var rect:Rectangle = bitmap.rect;
			rect.offset(x * MAX_SIZE,y * MAX_SIZE);
			return rect;
		}
		
		/**
		 * 回收位图内存
		 * 
		 */
		public function dispose():void
		{
			for each (var bitmap:BitmapData in bitmapDatas)
				bitmap.dispose();
				
			bitmapDatas = [];
		}
	}
}