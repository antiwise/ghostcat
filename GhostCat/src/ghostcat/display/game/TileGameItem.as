package ghostcat.display.game
{
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	
	/**
	 * 加载到Tile上的物品类
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class TileGameItem extends GBase
	{
		public var tile:Tile;
		public function TileGameItem(skin:*=null, tile:Tile = null, replace:Boolean=true)
		{
			this.tile = tile;
			super(skin, replace);
		}
		
		public function get tilePosition():Point
		{
			return tile.displayToItem(position);
		}
		
		public function set tilePosition(v:Point):void
		{
			position = tile.itemToDisplay(v);
		}
	}
}