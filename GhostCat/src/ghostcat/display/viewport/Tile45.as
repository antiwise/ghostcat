package ghostcat.display.viewport
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 45度角重复场景，适合实现超大范围的地图显示
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Tile45 extends Tile
	{
		private var tranSourceTo45:Boolean = false;
		private var wh:Number;//方块长宽比
		/**
		 * 
		 * @param base	源图像
		 * @param tranSourceTo45	是否将源图像由矩形转换成菱形
		 * 
		 */
		public function Tile45(itemClass:*,tranSourceTo45:Boolean = false)
		{
			this.tranSourceTo45 = tranSourceTo45;
			super(itemClass);
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
		/** @inheritDoc*/
		override public function getItemPointAtPoint(p:Point):Point
		{
			p = displayToItem(p);
			return new Point(Math.round(p.x / contentRect.width) - 1 , Math.round(p.y / contentRect.height)); 
		}
		
		/** @inheritDoc*/
		override public function displayToItem(p:Point):Point
		{
			return new Point(p.x + p.y * wh,p.y - p.x/wh);
		}
		
		/** @inheritDoc*/
		override public function itemToDisplay(p:Point):Point
		{
			return new Point((p.x - p.y * wh)/2,(p.x / wh + p.y)/2);
		}
		
		/** @inheritDoc*/
		override public function setContentClass(ref:*) : void
		{
			super.setContentClass(ref);
			if (this.ref)//使用经过变换后的大小
			{
				if (tranSourceTo45)
					_contentRect = new Rectangle(_contentRect.x,_contentRect.y,_contentRect.width * 2,_contentRect.height);
				wh = _contentRect.width/_contentRect.height;
			}
		}
		
		/** @inheritDoc*/
		override protected function getLocalScreen():Rectangle
		{
			//扩大显示范围
			var sRect:Rectangle = super.getLocalScreen();
			var nRect:Rectangle = new Rectangle();
			nRect.x = sRect.x;
			nRect.y = sRect.y - sRect.width/2 - contentRect.height;
			nRect.width = sRect.width + sRect.height * wh /2 + contentRect.width;
			nRect.height = sRect.height + contentRect.height;
			return nRect;
		}
		
		/** @inheritDoc*/
		override protected function getItemRect(viewport:Rectangle):Rectangle
		{
			var r:Rectangle = super.getItemRect(viewport);
			return new Rectangle(r.x + r.y,r.y - r.x,r.width*2,r.height*2);
		}
		
		/** @inheritDoc*/
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