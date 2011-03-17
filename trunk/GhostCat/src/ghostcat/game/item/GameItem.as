package ghostcat.game.item
{
	import flash.display.Sprite;
	
	import ghostcat.display.GBase;
	import ghostcat.display.GSprite;
	import ghostcat.game.item.collision.ICollision;
	import ghostcat.game.item.collision.ICollisionClient;
	import ghostcat.game.item.sort.ISortCalculater;
	
	public class GameItem extends Sprite implements ICollisionClient
	{
		public var sortCalculater:ISortCalculater;
		public var priority:Number;
		
		private var _oldX:Number;
		private var _oldY:Number;
		
		private var _collision:ICollision;
		public function get collision():ICollision
		{
			return _collision;
		}
		
		public override function set x(v:Number):void
		{	
			if (x == v)
				return;
			
			_oldX = super.x;
			super.x = v;
			
			updatePosition();
		}
		
		public override function set y(v:Number):void
		{
			if (y == v)
				return;
			
			_oldY = super.y;
			super.y = v;
			
			updatePosition();
		}
		
		protected function updatePosition():void
		{
			if (sortCalculater)
				priority = sortCalculater.calculate();
		}
		
		public function get oldX():Number
		{
			return _oldX;
		}
		
		public function get oldY():Number
		{
			return _oldY;
		}
		
		public function GameItem()
		{
			super();
			updatePosition();
		}
	}
}