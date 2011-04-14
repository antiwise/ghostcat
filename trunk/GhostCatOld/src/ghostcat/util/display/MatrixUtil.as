package ghostcat.util.display
{
	import flash.display.DisplayObject;
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
		 * 通过一组属性来创建Matrix
		 * @param obj
		 * @return 
		 * 
		 */
		public static function createFromObject(obj:Object):Matrix
		{
			var m:Matrix = new Matrix();
			m.createBox(obj.scaleX,obj.scaleY,obj.rotation / 180 * Math.PI,obj.x,obj.y);
			return m;
		}
		
		/**
		 * 从Matrix中输出一组属性
		 * @param m
		 * @return 
		 * 
		 */
		public static function toObject(m:Matrix):Object
		{
			var rotate:Number = Math.atan(m.b / m.a);
			return {x:m.tx,y:m.ty,rotation:rotate * 180 / Math.PI,scaleX:m.b / Math.sin(rotate),scaleY:m.d / Math.cos(rotate)};
		}
		
		/**
		 * 获得对象到另一个对象的Matrix
		 *  
		 * @param obj
		 * @param contain
		 * @return 
		 * 
		 */
		public static function getMatrixAt(obj:DisplayObject,container:DisplayObject):Matrix
		{
			if (obj == container)
				return new Matrix();
			
			if (obj.stage)//有stage
			{	
				var m1:Matrix = obj.transform.concatenatedMatrix;
				var m2:Matrix = container.transform.concatenatedMatrix;
				m2.invert();
				m1.concat(m2);
			}
			else
			{
				m1 = obj.transform.matrix;
				var cur:DisplayObject = obj.parent;
				while (cur != container)
				{
					if (!cur)
						return null;
					
					m1.concat(cur.transform.matrix);
					
					if (cur != cur.parent)
						cur = cur.parent;
					else
						return null;
				}
			}
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