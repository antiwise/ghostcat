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
		/**
		 * 
		 * @param base	源图像
		 * @param tranSourceTo45	是否将源图像由矩形转换成菱形
		 * 
		 */
		public function Tile45(itemClass:*=null,tranSourceTo45:Boolean = false)
		{
			this.tranSourceTo45 = tranSourceTo45;
			super(itemClass);
		}
		
		/** @inheritDoc*/
		public override function set contentRect(v:Rectangle):void
		{
			if (tranSourceTo45)
				v = new Rectangle(v.x,v.y,v.width * 2,v.height);
			super.contentRect = v;
			
			Display45Util.setContentSize(v.width,v.height);
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
			return Display45Util.getItemPointAtPoint(p);
		}
		
		/** @inheritDoc*/
		override public function displayToItem(p:Point):Point
		{
			return Display45Util.trans45To90(p);
		}
		
		/** @inheritDoc*/
		override public function itemToDisplay(p:Point):Point
		{
			return Display45Util.trans90To45(p);
		}
		
		/** @inheritDoc*/
		override public function getLocalScreen():Rectangle
		{
			//扩大显示范围
			var sRect:Rectangle = super.getLocalScreen();
			var nRect:Rectangle = new Rectangle();
			nRect.x = sRect.x;
			nRect.y = sRect.y - sRect.width/2 - contentRect.height;
			nRect.width = (sRect.width + sRect.height * (contentRect.width / contentRect.height) /2 + contentRect.width) * 2;
			nRect.height = sRect.height * 2;
			return nRect;
		}
		
		/** @inheritDoc*/
		override protected function getItemRect(viewport:Rectangle):Rectangle
		{
			var r:Rectangle = super.getItemRect(viewport);
			return new Rectangle(r.x + r.y,r.y - r.x,r.width,r.height);
		}
		
		/** @inheritDoc*/
		override protected function setItemPosition(s:DisplayObject,i:int,j:int):void
		{
			super.setItemPosition(s,i,j);
			var p:Point = itemToDisplay(new Point(s.x,s.y));
			s.x = p.x;
			s.y = p.y;
			if (tranSourceTo45)
				shapeTo45(s);
		}
	}
}