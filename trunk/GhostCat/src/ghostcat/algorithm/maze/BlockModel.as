package ghostcat.algorithm.maze
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import ghostcat.algorithm.traversal.MapModel;
	
	/**
	 * 阻碍格子迷宫数据模型 
	 * @author flashyiyi
	 * 
	 */
	public class BlockModel extends MapModel
	{
		public function BlockModel(map:Array=null)
		{
			super(map);
			this.diagonal = false;
		}
		
		/** @inheritDoc */	
		public override function isBlock(v:*, cur:* = null) : Boolean
		{
			var mapHeight : int = map.length;
			var mapWidth : int = map[0].length;
			
			if (v.x < 0 || v.x >= mapWidth || v.y < 0 || v.y >= mapHeight)
				return true;
			
			var item:Block4 = map[cur.y][cur.x];
			var offest:Point = v.subtract(cur);
			return item.left && offest.x == -1 || item.right && offest.x == 1 || 
					item.top && offest.y == -1 || item.bottom && offest.y == 1;
		}
		
		/**
		 * 转换为图形显示 
		 * @return 
		 * 
		 */
		public function toShape(size:int = 10):Shape
		{
			return BlockUtil.blockMapToShape(map,size);
		}
		
		/**
		 * 转换为位图显示 
		 * @return 
		 * 
		 */
		public override function toBitmap():Bitmap
		{
			return BlockUtil.boolMapToBitmap(BlockUtil.blockToBoolMap(map));
		}
	}
}