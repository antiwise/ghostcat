package ghostcat.util.display
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	        
	/**
	 * 不规则物品碰撞检测
	 * 
	 */
	public class HitTest
	{
		public static var tileSize:int=20;
		public static function complexHitTestObject(target1:DisplayObject, target2:DisplayObject):Boolean
		{
			var scaleX:Number = (target1.width < target2.width ? target1.width : target2.width) / tileSize 
			var scaleY:Number = (target1.height < target2.height ? target1.height : target2.height) / tileSize 
			scaleX = scaleX < 1 ? 1 : scaleX
			scaleY = scaleY < 1 ? 1 : scaleY
			var pt:Point=new Point()
			var ct:ColorTransform=new ColorTransform();		
			ct.color=0xFF00000F			
			var oldHitRectangle:Rectangle=intersectionRectangle(target1, target2)
			var hitRectangle:Rectangle= new Rectangle();
			return complexIntersectionRectangle(target1, target2 , scaleX , scaleY , pt , ct , oldHitRectangle,hitRectangle,tileSize,tileSize).width != 0;
		}		
		
		public static function intersectionRectangle(target1:DisplayObject, target2:DisplayObject):Rectangle
		{
			if (!target1.root || !target2.root || !target1.hitTestObject(target2))
				return new Rectangle();
			
			var bounds1:Rectangle = target1.getBounds(target1.root);
			var bounds2:Rectangle = target2.getBounds(target2.root);
			var intersection:Rectangle = new Rectangle();
			intersection.x = Math.max(bounds1.x, bounds2.x);
			intersection.y = Math.max(bounds1.y, bounds2.y);
			intersection.width = Math.min((bounds1.x + bounds1.width) - intersection.x, (bounds2.x + bounds2.width) - intersection.x);
			intersection.height = Math.min((bounds1.y + bounds1.height) - intersection.y, (bounds2.y + bounds2.height) - intersection.y);
			return intersection;
		}
		
		public static function complexIntersectionRectangle(target1:DisplayObject, target2:DisplayObject, scaleX:Number , scaleY:Number , pt:Point , ct:ColorTransform ,oldhitRectangle:Rectangle,hitRectangle:Rectangle,nowW:int,nowH:int):Rectangle
		{		
			if (!target1.hitTestObject(target2))
				return new Rectangle();
			
			hitRectangle.x = oldhitRectangle.x
			hitRectangle.y = oldhitRectangle.y
			hitRectangle.width = oldhitRectangle.width / scaleX
			hitRectangle.height = oldhitRectangle.height / scaleY
			var bitmapData:BitmapData=new BitmapData(nowW,nowH, true, 0);			
			
			bitmapData.draw(target1, getDrawMatrix(target1, hitRectangle , scaleX , scaleY ),ct);
			if (scaleX!=1&&scaleY!=1)
				bitmapData.threshold(bitmapData,bitmapData.rect,pt,">",0,0xFF00000F)
			
			bitmapData.draw(target2, getDrawMatrix(target2, hitRectangle , scaleX , scaleY ),ct, BlendMode.ADD);
			var hits:int=bitmapData.threshold(bitmapData,bitmapData.rect,pt,">",0xFF00000F,0xFFFF0000)
			var intersection:Rectangle=bitmapData.getColorBoundsRect(0xFFFFFFFF, 0xFFFF0000);
					
			if(intersection.width!=0)
			{				
				if(scaleX>1||scaleY>1)
				{
					if(hits<=(scaleX+scaleY)*1.5)
					{				
						var xadd:int = 0.5;
						var yadd:int = 0.5;
						var nextW:int = nextW = tileSize;
						var nextH:int = nextW = tileSize;
						
						if (intersection.width != nowW)
							nextW=tileSize					
						else
							nextW=nowW*2
						
						if (intersection.height != nowH)
							nextH=tileSize
						else
							nextH=nowH*2
						
						oldhitRectangle.x += (intersection.x - xadd) * scaleX
						oldhitRectangle.y += (intersection.y - yadd) * scaleY
						oldhitRectangle.width = (intersection.width + xadd*2) * scaleX
						oldhitRectangle.height = (intersection.height + yadd*2)  * scaleY
						scaleX = (oldhitRectangle.width / nextW) 
						scaleY = (oldhitRectangle.height / nextH) 
						scaleX = scaleX < 2 ? 1 : scaleX
						scaleY = scaleY < 2 ? 1 : scaleY
						intersection=complexIntersectionRectangle(target1,target2, scaleX , scaleY ,pt,ct,oldhitRectangle,hitRectangle,nextW,nextH)							
					}
				}
			}
			return intersection;
		}
		
		protected static function getDrawMatrix(target:DisplayObject, hitRectangle:Rectangle , scaleX:Number , scaleY:Number ):Matrix
		{
			var localToGlobal:Point;
			var matrix:Matrix;
			var rootConcatenatedMatrix:Matrix=target.root.transform.concatenatedMatrix;
			
			localToGlobal=target.localToGlobal(new Point());
			
			matrix=target.transform.concatenatedMatrix;
			matrix.tx=(localToGlobal.x - hitRectangle.x) / scaleX;
			matrix.ty=(localToGlobal.y - hitRectangle.y) / scaleY;			
			matrix.a=matrix.a / rootConcatenatedMatrix.a / scaleX ;
			matrix.d=matrix.d / rootConcatenatedMatrix.d / scaleY;
			
			return matrix;
		}
		
		/**
		 * 遍历第2个物体的子对象并执行一次HitTestObject
		 * 
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */
		public static function hitTestObjectChildren(target1:DisplayObject,target2:DisplayObject):Boolean
		{
			var size:int = (target2 is DisplayObjectContainer)?(target2 as DisplayObjectContainer).numChildren : 0;
			if (size == 0)
				return target1.hitTestObject(target2);
			else
			{
				for (var i:int = 0;i < size;i++)
				{
					if (target1.hitTestObject((target2 as DisplayObjectContainer).getChildAt(i)))
						return true;
				}
			}
			return false;
		}
		
		/**
		 * 遍历物体的子对象并执行一次HitTestPoint
		 * 
		 * @param target2
		 * @param x	舞台x
		 * @param y	舞台y
		 * @param shapeFlag	是否位图检测
		 * @return 
		 * 
		 */
		public static function hitTestPointChildren(target2:DisplayObject,x:Number,y:Number,shapeFlag:Boolean=false):Boolean
		{
			var size:int = (target2 is DisplayObjectContainer)?(target2 as DisplayObjectContainer).numChildren : 0;
			if (size == 0)
				return target2.hitTestPoint(x,y,shapeFlag);
			else
			{
				for (var i:int = 0;i < size;i++)
				{
					var item:DisplayObject = (target2 as DisplayObjectContainer).getChildAt(i);
					if (item.hitTestPoint(x,y))
					{
						if (shapeFlag)
						{
							if (item.hitTestPoint(x,y,shapeFlag))
								return true;
						}
						else
							return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 遍历第2个物体的子对象并执行一次complexHitTestObject
		 *  
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */
		public static function complexHitTestObjectChildren(target1:DisplayObject,target2:DisplayObject):Boolean
		{
			var size:int = (target2 is DisplayObjectContainer)?(target2 as DisplayObjectContainer).numChildren : 0;
			if (size == 0)
				return complexHitTestObject(target1,target2);
			else
			{
				for (var i:int = 0;i < size;i++)
				{
					if (complexHitTestObject(target1,(target2 as DisplayObjectContainer).getChildAt(i)))
						return true;
				}
			}
			return false;
		}
		
		
//		/**
//		 * 获得两个椭圆物品的交叠矩形
//		 *  
//		 * @param target1
//		 * @param target2
//		 * @return 
//		 * 
//		 */
//		public static function intersectionEllipse(target1:DisplayObject, target2:DisplayObject):Rectangle
//		{
//			if (!target1.stage || !target2.stage) 
//				return new Rectangle();
//			
//			var bounds1:Rectangle = target1.getBounds(target1.stage);
//			var bounds2:Rectangle = target2.getBounds(target2.stage);
//			
//			var intersect:Rectangle = bounds1.intersection(bounds2);
//			if (intersect.width==0)
//				return new Rectangle();
//			
//			var center1:Point = new Point(bounds1.x + bounds1.width / 2, bounds1.y + bounds1.height / 2);
//			var center2:Point = new Point(bounds2.x + bounds2.width / 2, bounds2.y + bounds2.height / 2);
//			var sub:Point = center2.subtract(center1);
//			var angle1:Number = Math.atan2(sub.y/bounds1.height,sub.x/bounds1.width);
//			var angle2:Number = Math.atan2(-sub.y/bounds2.height,-sub.x/bounds2.width);
//			var rad1:Point = new Point(bounds1.width / 2 * Math.cos(angle1),bounds1.height / 2 * Math.sin(angle1));
//			var rad2:Point = new Point(bounds2.width / 2 * Math.cos(angle2),bounds2.height / 2 * Math.sin(angle2));
//			if (sub.length > rad1.length + rad2.length)
//				return new Rectangle();
//			
//			var h1:Point = center1.add(rad1);
//			var h2:Point = center2.add(rad2);
//			return new Rectangle(h2.x,h2.y,h1.x - h2.x,h1.y - h2.y);
//		}
//		
//		/**
//		 * 获得椭圆和矩形物品的交叠矩形
//		 * 
//		 * @param target1	椭圆
//		 * @param target2	矩形
//		 * @return 
//		 * 
//		 */
//		public static function intersectionEllipseRectangle(target1:DisplayObject, target2:DisplayObject):Rectangle
//		{
//			if (!target1.stage || !target2.stage) 
//				return new Rectangle();
//			
//			var bounds1:Rectangle = target1.getBounds(target1.stage);
//			var bounds2:Rectangle = target2.getBounds(target2.stage);
//			
//			var intersect:Rectangle = bounds1.intersection(bounds2);
//			if (intersect.width==0)
//				return new Rectangle();
//			
//			var center1:Point = new Point(bounds1.x + bounds1.width / 2, bounds1.y + bounds1.height / 2);
//			var center2:Point = new Point(bounds2.x + bounds2.width / 2, bounds2.y + bounds2.height / 2);
//			
//			if ((center1.x < bounds2.x || center1.x > bounds2.right) && (center1.y < bounds2.y || center1.y > bounds2.bottom))
//			{
//				//未完成
//			}
//			return bounds1.intersection(bounds2);
//		}
		
	}
	
} 