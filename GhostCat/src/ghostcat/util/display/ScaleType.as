package ghostcat.util.display
{
	/**
	 * 缩放类型 
	 * @author flashyiyi
	 * 
	 */
	public final class ScaleType
	{
		/**
		 * 等比例缩放，但不会超过容器的范围
		 */
		public static const UNIFORM:String = "uniform";
		/**
		 * 等比例填充，多余的部分会被裁切
		 */
		public static const CROP:String = "crop";
		/**
		 * 非等比例填充
		 */
		public static const FILL:String = "fill";
	}
}