package ghostcat.display
{
	/**
	 * 支持光标的对象需要实现的接口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface ICursorManagerClient
	{
		/**
		 * 如果是类，则自动实例话
		 * 如果是对象，则直接设置
		 * 如果是字符串，则从已经设置的对象列表中获得
		 * @return 
		 * 
		 */
		function get cursor():*
	}
}