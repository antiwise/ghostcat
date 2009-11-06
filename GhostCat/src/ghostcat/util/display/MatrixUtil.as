package ghostcat.util.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;

	/**
	 * 矩阵转换类，主要用于draw方法的矩阵转换参数
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class MatrixUtil
	{
		/**
		 * 获得对象到另一个对象的Matrix
		 *  
		 * @param obj
		 * @param contain
		 * @return 
		 * 
		 */
		public static function getMatrixAt(obj:DisplayObject,container:DisplayObjectContainer):Matrix
		{
			if (obj == container)
				return new Matrix();
			
			var m1:Matrix = obj.transform.concatenatedMatrix;
			var m2:Matrix = container.transform.concatenatedMatrix;
			m2.invert();
			m1.concat(m2);
			return m1;
		}
		
		/**
		 * 创建按缩放比的矩阵 
		 * @param width
		 * @param height
		 * @param rotation
		 * @param tx
		 * @param ty
		 * @return 
		 * 
		 */
		public static function createBox(scaleX:Number,scaleY:Number,rotation:Number = 0,tx:Number = 0,ty:Number = 0):Matrix
		{
			var m:Matrix = new Matrix();
			m.createBox(scaleX,scaleY,rotation,tx,ty);	
			return m;
		}
		
		/**
		 * 创建用于填充的矩阵
		 * @param width
		 * @param height
		 * @param rotation
		 * @param tx
		 * @param ty
		 * 
		 */
		public static function createGradientBox(width:Number,height:Number,rotation:Number = 0,tx:Number = 0,ty:Number = 0):Matrix
		{
			var m:Matrix = new Matrix();
			m.createGradientBox(width,height,rotation,tx,ty);	
			return m;
		}
		
		/**
		 * 矩阵相加
		 * @param m1
		 * @param m2
		 * @return 
		 * 
		 */
		public static function concat(m1:Matrix,m2:Matrix):Matrix
		{
			var m:Matrix = m1.clone();
			m.concat(m2);
			return m;
		}
		
		/**
		 * 矩阵取反
		 * @param m
		 * @return 
		 * 
		 */
		public static function invert(m:Matrix):Matrix
		{
			var m:Matrix = m.clone();
			m.invert();
			return m;
		}
	}
}