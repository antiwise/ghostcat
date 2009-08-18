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
	 * @author Administrator
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
		 * 获得两个不规则物品的交叠矩形
		 *  
		 * @param target1	物品1
		 * @param target2	物品2
		 * @param accurracy	检测精度
		 * @return 
		 * 
		 */
		public static function complexIntersectionRectangle(target1:DisplayObject,target2:DisplayObject, accurracy:Number = 1):Rectangle
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
				var bitmapData:BitmapData = new BitmapData(hitRectangle.width * accurracy, hitRectangle.height * accurracy, false, 0x000000); 
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
		
		//修正绘制位图时的大小问题
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
		
		/**
		 * 获得两个矩形物体的交叠矩形（比complexIntersectionRectangle要快）
		 * 
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */
		public static function intersectionRectangle(target1:DisplayObject, target2:DisplayObject):Rectangle
		{
			if (!target1.stage || !target2.stage) 
				return new Rectangle();
			
			var bounds1:Rectangle = target1.getBounds(target1.stage);
			var bounds2:Rectangle = target2.getBounds(target2.stage);
			 
			return bounds1.intersection(bounds2);
		}
		
		/**
		 * 获得两个椭圆物品的交叠矩形
		 *  
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */
		public static function intersectionEllipse(target1:DisplayObject, target2:DisplayObject):Rectangle
		{
			if (!target1.stage || !target2.stage) 
				return new Rectangle();
			
			var bounds1:Rectangle = target1.getBounds(target1.stage);
			var bounds2:Rectangle = target2.getBounds(target2.stage);
			
			var intersect:Rectangle = bounds1.intersection(bounds2);
			if (intersect.width==0)
				return new Rectangle();
			
			var center1:Point = new Point(bounds1.x + bounds1.width / 2, bounds1.y + bounds1.height / 2);
			var center2:Point = new Point(bounds2.x + bounds2.width / 2, bounds2.y + bounds2.height / 2);
			var sub:Point = center2.subtract(center1);
			var angle1:Number = Math.atan2(sub.y/bounds1.height,sub.x/bounds1.width);
			var angle2:Number = Math.atan2(-sub.y/bounds2.height,-sub.x/bounds2.width);
			var rad1:Point = new Point(bounds1.width / 2 * Math.cos(angle1),bounds1.height / 2 * Math.sin(angle1));
			var rad2:Point = new Point(bounds2.width / 2 * Math.cos(angle2),bounds2.height / 2 * Math.sin(angle2));
			if (sub.length > rad1.length + rad2.length)
				return new Rectangle();
			
			var h1:Point = center1.add(rad1);
			var h2:Point = center2.add(rad2);
			return new Rectangle(h2.x,h2.y,h1.x - h2.x,h1.y - h2.y);
		}
		
		/**
		 * 获得椭圆和矩形物品的交叠矩形
		 * 
		 * @param target1	椭圆
		 * @param target2	矩形
		 * @return 
		 * 
		 */
		public static function intersectionEllipseRectangle(target1:DisplayObject, target2:DisplayObject):Rectangle
		{
			if (!target1.stage || !target2.stage) 
				return new Rectangle();
			
			var bounds1:Rectangle = target1.getBounds(target1.stage);
			var bounds2:Rectangle = target2.getBounds(target2.stage);
			
			var intersect:Rectangle = bounds1.intersection(bounds2);
			if (intersect.width==0)
				return new Rectangle();
			
			var center1:Point = new Point(bounds1.x + bounds1.width / 2, bounds1.y + bounds1.height / 2);
			var center2:Point = new Point(bounds2.x + bounds2.width / 2, bounds2.y + bounds2.height / 2);
			
			if ((center1.x < bounds2.x || center1.x > bounds2.right) && (center1.y < bounds2.y || center1.y > bounds2.bottom))
			{
				//未完成
			}
			return bounds1.intersection(bounds2);
		}
		
	}
	
} 