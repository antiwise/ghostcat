package ghostcat.game.item
{
	import flash.display.Sprite;
	
	import ghostcat.display.GBase;
	import ghostcat.display.GSprite;
	import ghostcat.game.item.sort.ISortCalculater;
	
	public class GameItem extends Sprite implements IGameItem
	{
		public var sortCalculater:ISortCalculater;
		
		public override function set x(v:Number):void
		{	
			if (x == v)
				return;
			
			super.x = v;
			
			if (sortCalculater)
				sortCalculater.calculate();
		}
		
		public override function set y(v:Number):void
		{
			if (y == v)
				return;
			
			super.y = v;
			
			if (sortCalculater)
				sortCalculater.calculate();
		}
		
		private var _priority:Number;
		
		public function get priority():Number
		{
			return _priority;
		}
		
		public function set priority(v:Number):void
		{
			_priority = v;
		}
		
		public function GameItem()
		{
			super();
		}
	}
}