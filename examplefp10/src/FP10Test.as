package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.other.SWFDump;
	
	public class FP10Test extends Sprite
	{
		public const SIZE:int = 5;
		public var path:Array = [];
		public var map:Array;
		public var count:int = 0;
		public function search(x:int,y:int):void
		{
			if (x >= 0 && y >= 0 && x < SIZE && y < SIZE && map[x][y] == 0)
			{
				map[x][y] = 1;
				path.push(y * SIZE + x);
				if (path.length == SIZE * SIZE)
				{
					trace(path);
					count++;
				}
				else
				{
					search(x - 1,y);
					search(x + 1,y);
					search(x,y - 1);
					search(x,y + 1);
				}
				path.pop();
				map[x][y] = 0;
			}
		}
		public function createMap():void
		{
			map = []
			for (var i:int = 0;i < SIZE;i++)
			{
				map[i] = [];	
				for (var j:int = 0;j < SIZE;j++)
				{
					map[i][j] = 0;
				}
			}
		}
		public function FP10Test()
		{
			createMap();
			search(2,2);
			trace("count:",count)
		}
	}
}