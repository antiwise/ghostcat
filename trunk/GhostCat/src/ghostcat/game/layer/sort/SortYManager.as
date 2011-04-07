package ghostcat.game.layer.sort
{
	import ghostcat.game.layer.GameLayer;

	/**
	 * 根据对象的y属性排序
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