package ghostcat.display
{
	/**
	 * 支持ToolTip的对象需要实现的接口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface IToolTipManagerClient
	{
		/**
		 * 一般为字符串，根据你设置的toolTipObj而定
		 * @return 
		 * 
		 */
		function get toolTip():*;
		/**
		 * 如果是类，则自动实例化
		 * 如果是对象，则直接设置
		 * 如果是字符串，则从已经设置的对象列表中获得
		 * @return 
		 * 
		 */
		function get toolTipObj():*;
	}
}