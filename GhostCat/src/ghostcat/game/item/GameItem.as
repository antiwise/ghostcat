package ghostcat.game.item
{
	import flash.display.Sprite;
	
	import ghostcat.display.GBase;
	import ghostcat.display.GSprite;
	import ghostcat.game.item.collision.ICollision;
	import ghostcat.game.item.sort.ISortCalculater;
	
	public class GameItem extends Sprite
	{
		public var sortCalculater:ISortCalculater;
		public var collision:ICollision;
		public var priority:Number;
		
		public override function set x(v:Number):void
		{	
			if (x == v)
				return;
			
			super.x = v;
			
			if (sortCalculater)
				priority = sortCalculater.calculate();
		}
		
		public override function set y(v:Number):void
		{
			if (y == v)
				return;
			
			super.y = v;
			
			if (sortCalculater)
				priority = sortCalculater.calculate();
		}
		
		public function GameItem()
		{
			super();
		}
	}
}