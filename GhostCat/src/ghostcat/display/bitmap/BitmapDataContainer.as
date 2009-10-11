package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.util.Util;
	
	/**
	 * 位图数据的模拟容器
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapDataContainer extends EventDispatcher implements IBitmapDataDrawer
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var parent:BitmapDataContainer;
		public var children:Array = [];
		
		/**
		 * 添加
		 * @param obj
		 * 
		 */
		public function addChild(obj:BitmapDataContainer):void
		{
			children.push(obj);
			obj.parent = this;
		}
		
		/**
		 * 删除 
		 * @param obj
		 * 
		 */
		public function removeChild(obj:BitmapDataContainer):void
		{
			Util.remove(children,obj);
			obj.parent = null;
		}
		
		/**
		 * 位图数据
		 */
		public var bitmapData:BitmapData;
		
		/**
		 * 可以被绘制的显示对象
		 */
		public var source:IBitmapDrawable;
		
		public function BitmapDataContainer(source:IBitmapDrawable=null)
		{
			if (source is BitmapData)
				this.bitmapData = source as BitmapData;
			else
			{
				this.source = source;
				redraw();
			}
		}
		
		/**
		 * 重绘显示对象
		 * 
		 */
		public function redraw():void
		{
			if (source is DisplayObject)
			{
				if (bitmapData)
					bitmapData.dispose();
				
				var o:DisplayObject = source as DisplayObject;
				var rect:Rectangle = o.getBounds(o);
				bitmapData = new BitmapData(Math.ceil(rect.width),Math.ceil(rect.height),true,0);
				var m:Matrix = new Matrix();
				m.translate(-rect.x,-rect.y);
				bitmapData.draw(source,m);
			}
		}
		
		/**
		 * 获得全局坐标
		 * @return 
		 * 
		 */
		public function getGlobalPosition():Point
		{
			var o:BitmapDataContainer = this;
			var p:Point = new Point();
			while (o)
			{
				p = p.add(new Point(o.x,o.y))
				if (o.parent is BitmapDataContainer)
					o = (o.parent as BitmapDataContainer)
				else
					break;
			}
			return p;
		}
		
		
		/** @inheritDoc*/
		public function drawBitmapData(target:BitmapData):void
		{
			target.copyPixels(bitmapData,bitmapData.rect,getGlobalPosition());
			
			var children:Array = this.children;
			if (children)
			{
				for (var i:int = 0;i < children.length;i++)
					(children[i] as BitmapDataContainer).drawBitmapData(target);
			}
		}
		
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			if (bitmapData)
				bitmapData.dispose();
		}
	}
}