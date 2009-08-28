package org.ghostcat.display.viewport
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.util.Geom;
	import org.ghostcat.util.SearchUtil;

	/**
	 * 碰撞检测块。
	 * 使用多个方框和圆形的组合来处理碰撞，这种方法比位图碰撞要快得多，而且可以适应绝大多数情况。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class Collision
	{
		public static const RECT:int = 0;
		public static const ELLIPSE:int = 1;
		
		private var rects:Array;
		private var unrects:Array;
		
		/**
		 * 碰撞区域源数据
		 */		
		public var base:DisplayObject;
		
		/**
		 * 
		 * @param base	用于检测用的对象。对象内应该有一个collision实例名的对象，这个对象下的所有图形为判断依据。
		 * 如果不是容器的话，则是collision对象本身，而如果collision不存在的话，则等同于getBounds的结果。
		 * 
		 * 此外，还可以增加一个实例名为uncollision的对象，它可以解除collision的影响，用于在设定好的区域里挖洞。
		 * 由此一来，就没有什么不能造的碰撞区域了。
		 * 
		 */		
		public function Collision(base:DisplayObject)
		{
			this.base = base;
			refresh();
		}
		
		public function get globalPosition():Point
		{
			var pos:Point;
			Geom.copyPosition(base,pos);
			return base.localToGlobal(pos);
		}
		
		/**
		 * 更新碰撞区域
		 * 
		 */		
		public function refresh():void
		{
			if (!base.stage)	//未加入显示列表，将无法计算碰撞区域
				return;
			
			rects = [];
			unrects = [];
			
			var collision:Sprite = SearchUtil.findChildByProperty(base,"name","collision") as Sprite;
			var uncollision:Sprite = SearchUtil.findChildByProperty(base,"name","uncollision") as Sprite;
			
			var i:int;
			
			if (collision)
			{
				collision.visible = false;
				
				if (collision.numChildren != 0)
				{
					for (i = 0; i < collision.numChildren; i++)
						createFromObj(collision.getChildAt(i));
				}
				else
				{
					createFromObj(collision);
				}
			}
			else
			{	
				rects.push(new CollisionItem(RECT,base.getBounds(base),base));
			}
			
			if (uncollision)
			{
				uncollision.visible = false;
				
				if (uncollision.numChildren != 0)
				{
					for (i = 0; i < uncollision.numChildren; i++)
						deleteFromObj(uncollision.getChildAt(i));
				}
				else
				{
					deleteFromObj(uncollision);
				}
			}
		}
		
		/**
		 * 由显示对象增加碰撞区域
		 * 
		 * @param obj	显示对象
		 * 
		 */		
		public function createFromObj(obj:DisplayObject):void
		{
			var rect:Rectangle = obj.getRect(obj);
			if (rect)
				rects.push(new CollisionItem( isRect(obj) ? RECT : ELLIPSE, rect, obj));
		}
		
		/**
		 * 由显示对象增加裁剪碰撞区域
		 * 
		 * @param obj	显示对象
		 * 
		 */		
		public function deleteFromObj(obj:DisplayObject):void
		{
			var unrect:Rectangle = obj.getRect(obj);
			if (unrect)
				unrects.push(new CollisionItem( isRect(obj) ? RECT : ELLIPSE, unrect, obj));
		}
		
		//检测四个边角的像素来判断是否为矩形，因此这个矩形旋转角度必须为0
		private function isRect(obj:DisplayObject):Boolean
		{
			var rect:Rectangle = obj.getRect(obj);
			var points:Array = [new Point(rect.left+1,rect.top+1),
								new Point(rect.right-1,rect.bottom-1),
								new Point(rect.right-1,rect.top+1),
								new Point(rect.left+1,rect.bottom-11)];
			for each (var testPoint:Point in points)
			{
				var temp:Point = obj.localToGlobal(testPoint);
				if (!obj.hitTestPoint(temp.x,temp.y,true))
					return false;
			}
			return true;
		}
		
		/**
		 * 执行一次hitTest方法后，获得的碰撞边缘值将会被保存在这里，始终采用这个值将会在边缘滑动。
		 * 这是一个舞台坐标
		 */		
		public var lastVergePoint:Point;
		
		/**
		 * 碰撞检测
		 * 
		 * @param p	舞台坐标
		 * @param old	前一个舞台坐标，是检测边缘的依据。如果要计算矩形的边缘，必须设置此值
		 * 
		 * @return 
		 * 
		 */		
		public function hitTestPoint(p:Point,old:Point=null):Boolean
		{
			var hit:Boolean = false;
			
			lastVergePoint = checkCollisionItem(p,old,rects);
			
			if (lastVergePoint && unrects)
			{
				if (checkCollisionItem(p,old,unrects))
					lastVergePoint = null;
				else 
				{
					if (checkCollisionItem(lastVergePoint,old,unrects))
						lastVergePoint = p;
				}
			}
			return lastVergePoint!=null;
		}
		
		
		/**
		 * 检测交叠点
		 *  
		 * @param p	点
		 * @param old	点的旧值
		 * @param rects	矩形
		 * @return 返回碰撞边缘点。如果没有碰撞则返回null
		 * 
		 */
		private function checkCollisionItem(p:Point,old:Point,rects:Array):Point
		{
			var v:Point;//边缘坐标
			var hit:Boolean = false;
			
			var lastVergePoint:Point = p.clone();
			
			for (var i:int = 0;i < rects.length;i++)
			{
				var item:CollisionItem = rects[i] as CollisionItem;
				var rect:Rectangle = item.rect;
				
				var local:Point = item.shape.globalToLocal(lastVergePoint);//当前坐标
				
				if (local.x > rect.left && local.x < rect.right && local.y > rect.top && local.y < rect.bottom)
				{
					if (item.type == RECT)
					{
						if (old)
						{
							var oldLocal:Point = item.shape.globalToLocal(old);//前一个坐标
							v = oldLocal;
							if (local.x > rect.left && oldLocal.x <= rect.left + 1)
								v = new Point(rect.left,local.y);
							if (local.x < rect.right && oldLocal.x >= rect.right - 1)
								v = new Point(rect.right,local.y);
							if (local.y > rect.top && oldLocal.y <= rect.top + 1)
								v = new Point(local.x,rect.top); 
							if (local.y < rect.bottom && oldLocal.y >= rect.bottom - 1)
								v = new Point(local.x,rect.bottom) ;
							
							lastVergePoint = item.shape.localToGlobal(v);
						}
						else
							lastVergePoint = p.clone();
						
						hit = true;
					}
					else if (item.type == ELLIPSE)
					{
						var center:Point = Geom.center(rect);
						var sub:Point = local.subtract(center);
						var r:Number = Math.atan2(sub.y/rect.height,sub.x/rect.width);
						v = new Point(rect.width / 2 * Math.cos(r),rect.height / 2 * Math.sin(r));
						if (sub.length < v.length)
						{
							v = center.add(v);
							lastVergePoint = item.shape.localToGlobal(v);
							hit = true;
						}
					}
				}
			}
			if (hit)
				return lastVergePoint;
			return null;
		}
		
		/**
		 * 两个物品之间的碰撞检测
		 * 
		 * 这个方法功能受限，不能处理旋转，不能处理圆，不能处理unRect。
		 * 
		 * @param obj	碰撞对象
		 * 
		 */
		public function hitTestObject(obj:Collision):Boolean
		{
			for (var j:int = 0;j <obj.rects.length;j++)
			{
				var hit:Boolean = false;
				
				var lastVergePoint:Point = obj.globalPosition.clone();
				
				var item2:CollisionItem = obj.rects[j] as CollisionItem;
				var rect2:Rectangle = Geom.localRectToContent(item2.rect,item2.shape,null);
				
				for (var i:int = 0;i < rects.length;i++)
				{
					var item:CollisionItem = rects[i] as CollisionItem;
					var rect:Rectangle = Geom.localRectToContent(item.rect,item.shape,null);
					
					if (rect2.intersects(rect))
					{
						var add:Point = new Point();
						if (rect2.left < rect.left)
							add = new Point((rect.left - rect2.left) - rect2.width,0);
						if (rect2.right > rect.right)
							add = new Point(rect2.width - (rect2.right - rect.right),0);
						if (rect2.top < rect.top)
							add = new Point(0,(rect.top - rect2.top) - rect2.height); 
						if (rect2.bottom > rect.bottom)
							add = new Point(0,rect2.height - (rect2.bottom - rect.bottom)) ;
						
						lastVergePoint = lastVergePoint.add(add);
						hit = true;
					}
				}
				if (hit)
					this.lastVergePoint = lastVergePoint;
			}
			return hit;
		}
	}
}
import flash.geom.Rectangle;
import flash.display.DisplayObject;

class CollisionItem
{
	public var type:int;
	public var rect:Rectangle;
	public var shape:DisplayObject;
	public function CollisionItem(type:int,rect:Rectangle,shape:DisplayObject)
	{
		this.type = type;
		this.rect = rect;
		this.shape = shape;
	}
}