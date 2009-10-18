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
		 * 获得对象到某个父容器的Matrix
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
			
			var m:Matrix = obj.transform.matrix;
			var cur:DisplayObject = obj.parent;
				
			while (cur != container)
			{
				if (cur)
					m.concat(cur.transform.matrix);
				
				if (cur && cur != cur.parent)
					cur = cur.parent;
				else
					break;
//					throw new Error("obj不在指定的容器内！");
			}
			return m;
		}
		/**
		 * 获得两个对象之间的Matrix，
		 * 求出的是对象1到对象2的Matrix
		 * 
		 * @param obj1	对象1
		 * @param obj2	对象2
		 * @param container	共同的父容器，默认为stage
		 * 
		 */
		public static function getMatrixBetween(obj1:DisplayObject,obj2:DisplayObject,container:DisplayObjectContainer=null):Matrix
		{
			if (!container)
				container = obj1.stage as DisplayObjectContainer;
			
			var m1:Matrix = getMatrixAt(obj1,container);
			var m2:Matrix = getMatrixAt(obj2,container);
			m2.invert();
			m1.concat(m2);
			return m1;
		}
		
		/**
		 * 创建渐变时用的矩阵
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