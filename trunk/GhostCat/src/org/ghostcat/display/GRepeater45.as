package org.ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.util.Geom;

	/**
	 * 45度角重复场景
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GRepeater45 extends GRepeater
	{
		private var tranSourceTo45:Boolean = false;
		/**
		 * 
		 * @param base	源图像
		 * @param tranSourceTo45	是否将源图像由矩形转换成菱形
		 * 
		 */
		public function GRepeater45(base:*,tranSourceTo45:Boolean = false)
		{
			this.tranSourceTo45 = tranSourceTo45;
			super(base);
		}
		
		/**
		 * 转换图像为45角
		 * @param p
		 * 
		 */
		public static function shapeTo45(p:DisplayObject):void
		{
			var m:Matrix = new Matrix();
            m.b = m.c = -Math.tan(1/3);
            m.rotate(Math.PI/4);
            m.tx = p.x;
            m.ty = p.y;
            p.transform.matrix = m;
		}
		/**
		 * 由显示坐标转换为内部坐标
		 * 
		 * @param p
		 * @return 
		 * 
		 */
		public function displayToItem(p:Point):Point
		{
			var wh:Number = contentRect.width / contentRect.height;
			return new Point(p.x + p.y * wh,p.y - p.x/wh);
		}
		
		/**
		 * 由内部坐标转换为显示坐标
		 * 
		 * @param p
		 * @return 
		 * 
		 */
		public function itemToDisplay(p:Point):Point
		{
			var wh:Number = contentRect.width / contentRect.height;
			return new Point((p.x - p.y * wh)/2,(p.x / wh + p.y)/2);
		}
		
		override public function setContentClass(ref:*) : void
		{
			super.setContentClass(ref);
			if (this.ref)//使用经过变换后的大小
			{
				if (tranSourceTo45)
					_contentRect = new Rectangle(_contentRect.x,_contentRect.y,_contentRect.width * 2,_contentRect.height);
			}
		}
		
		override protected function getLocalScreen():Rectangle
		{
			if (!scrollRectContainer)
				return null;
				
			var sRect:Rectangle; 
			if (viewRect)
				sRect = viewRect;
			else if (scrollRectContainer is Stage)
				sRect = Geom.getRect(scrollRectContainer);
			else
				sRect = scrollRectContainer.scrollRect;
			
			sRect = sRect.clone();
			sRect.x -= sRect.width;
			sRect.y -= sRect.height;
			sRect.width *= 3;
			sRect.height *= 3;
			return Geom.localRectToContent(sRect,scrollRectContainer,this);
		}
		
		override protected function getItemRect(viewport:Rectangle):Rectangle
		{
			var r:Rectangle = super.getItemRect(viewport);
			return new Rectangle(r.x + r.y,r.y - r.x,r.width*2,r.height*2);
		}
		
		override protected function addItem(i:int,j:int,lowest:Boolean=false):DisplayObject
		{
			var s:DisplayObject = super.addItem(i,j,lowest);
			var p:Point = itemToDisplay(new Point(s.x,s.y));
			s.x = p.x;
			s.y = p.y;
			if (tranSourceTo45)
				shapeTo45(s);
				
			return s;
		}
	}
}