package ghostcat.game.layer.sort.client
{
	import flash.geom.Rectangle;

	/**
	 * 能够被SortSizeManager排序的对象 
	 * @author flashyiyi
	 * 
	 */
	public interface ISortSizeClient
	{
		function get sortRect():Rectangle;
	}
}