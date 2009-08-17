package org.ghostcat.util
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.debug.Debug;

	        
	/**
	 * 不规则物品碰撞检测
	 * 
	 */
	public class HitTest
	{
		/**
		 * 不规则物品碰撞检测
		 * 
		 * @param target1	物品1
		 * @param target2	物品2
		 * @param accurracy	检测精度
		 * @return 
		 * 
		 */
		public static function complexHitTestObject(target1:DisplayObject, target2:DisplayObject, accurracy:Number = 1):Boolean
		{
			return complexIntersectionRectangle(target1,target2,accurracy).width != 0;
		}
		                
		/**
		 * 获得两个不规则物品相交的矩形
		 *  
		 * @param target1	物品1
		 * @param target2	物品2
		 * @param accurracy	检测精度
		 * @return 
		 * 
		 */
		public static function complexIntersectionRectangle( target1:DisplayObject, target2:DisplayObject, accurracy:Number = 1 ):Rectangle
		{                     
			if (accurracy <= 0) 
				Debug.error("精度必须大于0");
			
			// If a simple hitTestObject is false, they cannot be intersecting.
			if (!target1.hitTestObject(target2)) 
				return new Rectangle();
			
			var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
			// If their boundaries are no interesecting, they cannot be intersecting.
			if (hitRectangle.width * accurracy < 1 || hitRectangle.height * accurracy < 1) 
				return new Rectangle();
			
			try
			{                        
				var bitmapData:BitmapData = new BitmapData( hitRectangle.width * accurracy, hitRectangle.height * accurracy, false, 0x000000 ); 
			}
			catch(e:Error)
			{
				return new Rectangle();
			}
			// Draw the first target.
			bitmapData.draw(target1, getDrawMatrix( target1, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
			// Overlay the second target.
			bitmapData.draw(target2, getDrawMatrix( target2, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );
			
			// Find the intersection.
			var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );
			
			bitmapData.dispose();
			
			// Alter width and positions to compensate for accurracy
			if (accurracy != 1)
			{
				intersection.x /= accurracy;
				intersection.y /= accurracy;
				intersection.width /= accurracy;
				intersection.height /= accurracy;
			}
			
			intersection.x += hitRectangle.x;
			intersection.y += hitRectangle.y;
			
			return intersection;
		}
		
		/**
		 * 获得两个物品外边框矩形的交叠部分（比complexIntersectionRectangle要快）
		 * 
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */
		public static function intersectionRectangle(target1:DisplayObject, target2:DisplayObject):Rectangle
		{
			if (!target1.stage || !target2.stage || !target1.hitTestObject(target2)) 
				return new Rectangle();
			
			var bounds1:Rectangle = target1.getBounds(target1.stage);
			var bounds2:Rectangle = target2.getBounds(target2.stage);
			 
			return bounds1.intersection(bounds2);
		}
		                
		private static function getDrawMatrix(target:DisplayObject, hitRectangle:Rectangle, accurracy:Number):Matrix
		{
			var localToGlobal:Point;;
			var matrix:Matrix;
			                        
			var rootConcatenatedMatrix:Matrix = target.stage.transform.concatenatedMatrix;
			                        
			localToGlobal = target.localToGlobal(new Point());
			matrix = target.transform.concatenatedMatrix;
			matrix.tx = localToGlobal.x - hitRectangle.x;
			matrix.ty = localToGlobal.y - hitRectangle.y;
			
			matrix.a = matrix.a / rootConcatenatedMatrix.a;
			matrix.d = matrix.d / rootConcatenatedMatrix.d;
			if (accurracy != 1) 
				matrix.scale( accurracy, accurracy );
			
			return matrix;
		}
		
	}
	
} 