package ghostcat.algorithm
{
	
	/**
	 * 3D坐标
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Point3D
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public function Point3D(x:Number=0,y:Number=0,z:Number=0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		/**
		 * 判断是否相等
		 * 
		 * @param p
		 * @return 
		 * 
		 */
		public function equals(p:Point3D):Boolean
		{
			return this.x == p.x && this.y == p.y && this.z == p.z;
		}
		
		/**
		 * 计算两个点之间的距离
		 * 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */
		public static function distance(p1:Point3D,p2:Point3D):Number
		{
			return Math.sqrt((p1.x - p2.x)*(p1.x - p2.x)+(p1.y - p2.y)*(p1.y - p2.y)+(p1.z - p2.z)*(p1.z - p2.z));
		}
	}
}