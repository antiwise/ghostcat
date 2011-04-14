package ghostcat.util.encrypt
{
	/**
	 * 加密接口
	 * @author flashyiyi
	 * 
	 */
	public interface IEncrypt
	{
		/**
		 * 加密
		 * @param data
		 * @return 
		 * 
		 */
		function encode(data:*):*;
		/**
		 * 解密
		 * @param data
		 * @return 
		 * 
		 */
		function decode(data:*):*;
	}
}