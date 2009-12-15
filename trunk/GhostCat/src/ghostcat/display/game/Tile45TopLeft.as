package ghostcat.display.game
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 45度角重复场景（元素注册点在左上角） 
	 * @author flashyiyi
	 * 
	 */
	public class Tile45TopLeft extends Tile45
	{
		private var halfContentWidth:Number = 0;//缓存元素的半宽
		public function Tile45TopLeft(itemClass:*=null)
		{
			super(itemClass);
		}
		
		/** @inheritDoc*/
		public override function set contentRect(v:Rectangle):void
		{
			super.contentRect = v;
			halfContentWidth = v.width / 2;
		}
		
		/** @inheritDoc*/
		override public function displayToItem(p:Point):Point
		{
			return super.displayToItem(new Point(p.x + halfContentWidth,p.y));
		}
		
		/** @inheritDoc*/
		override public function itemToDisplay(p:Point):Point
		{
			var p:Point = super.itemToDisplay(p);
			p.x -= halfContentWidth;
			return p;
		}
	}
}