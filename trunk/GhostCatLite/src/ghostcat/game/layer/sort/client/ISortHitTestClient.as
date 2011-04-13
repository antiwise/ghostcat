package ghostcat.game.layer.sort.client
{
	import flash.display.BitmapData;

	/**
	 * 能够用SortHitTestManager排序的对象
	 * @author flashyiyi
	 * 
	 */
	public interface ISortHitTestClient
	{
		function get sortBitmapData():BitmapData
	}
}