package ghostcat.game.layer.sort
{
	import ghostcat.game.layer.GameLayer;

	/**
	 * 以Y作为深度的排序器 
	 * @author flashyiyi
	 * 
	 */
	public class SortYManager extends SortPriorityManager
	{
		public function SortYManager(layer:GameLayer)
		{
			super(layer,"y");
		}
	}
}