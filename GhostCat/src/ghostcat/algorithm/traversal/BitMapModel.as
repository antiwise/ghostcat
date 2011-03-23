package ghostcat.algorithm.traversal
{
	import flash.geom.Point;

	/**
	 * 将地图数据压缩保存的模型，可以用ghostcat.util.data.BitArray做两者间的转换
	 * @author flashyiyi
	 * 
	 */
	public class BitMapModel extends MapModel
	{
		public function BitMapModel(map:Array=null)
		{
			super(map);
		}
		
		override public function createMap(width:int, height:int, isArray2D:Boolean=false):void
		{
			var w:int = Math.ceil(width / 32);
			var m:Array = [];
			
			if (isArray2D)
			{
				for (var j:int = 0;j < height;j++)
				{
					var line:Array = [];
					for (var i:int = 0;i < w;i++)
						line[i] = 0;
					
					m[j] = line;
				}
			}
			else
			{
				var l:int = w * height;
				for (i = 0;i < l;i++)
					m[i] = 0;
			}
			
			this.map = m;
		}
		
		override public function isBlock(v:*, cur:*=null):Boolean
		{
			var p:Point = Point(v);
			if (p.x < 0 || p.x >= width || p.y < 0 || p.y >= height)
			{
				return true;
			}
			else
			{
				var n:int = isArray2D ? _map[v.y][Math.ceil(p.x / 32)] : _map[p.y * width + Math.ceil(p.x / 32)];
				return n == (n | (1 << (p.x % 32)));
			}
		}
		
		override public function set map(value:Array):void
		{
			super.map = value;
			this.width = this.width * 32;
		}
		
	}
}