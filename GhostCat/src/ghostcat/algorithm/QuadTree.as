package ghostcat.algorithm
{
	import flash.geom.Rectangle;

	/**
	 * 图形筛选4叉树 
	 * @author flashyiyi
	 * 
	 */
	public class QuadTree
	{
		/**
		 * 第1象限
		 */
		public var q1:QuadTree;
		/**
		 * 第2象限
		 */
		public var q2:QuadTree;
		/**
		 * 第3象限
		 */
		public var q3:QuadTree;
		/**
		 * 第4象限
		 */
		public var q4:QuadTree;
		/**
		 * 父节点
		 */
		public var parent:QuadTree;
		/**
		 * 起始节点
		 */
		public var root:QuadTree;
		/**
		 * 图形范围 
		 */
		public var rect:Rectangle;
		/**
		 * 数据
		 */
		public var data:Array = [];
		
		public function QuadTree(rect:Rectangle)
		{
			this.rect = rect;
			this.root = this;
		}
		
		/**
		 * 创建树结构 
		 * @param deep
		 * 
		 */
		public function createChildren(deep:int):void
		{
			if (deep == 0)
				return;
			
			const hw:Number = rect.width / 2;
			const hh:Number = rect.height / 2;
			
			q1 = new QuadTree(new Rectangle(rect.x + hw, rect.y, hw, hh));
			q2 = new QuadTree(new Rectangle(rect.x + hw, rect.y + hh, hw, hh));
			q3 = new QuadTree(new Rectangle(rect.x, rect.y + hh, hw, hh));
			q4 = new QuadTree(new Rectangle(rect.x, rect.y, hw, hh));
			
			q1.parent = q2.parent = q3.parent = q4.parent = this;
			q1.root = q2.root = q3.root = q4.root = this.root;
			
			q1.createChildren(deep - 1);
			q2.createChildren(deep - 1);
			q3.createChildren(deep - 1);
			q4.createChildren(deep - 1);
		}
		
		/**
		 * 是否有子树 
		 * @return 
		 * 
		 */
		public function get hasChildren():Boolean
		{
			return q1 && q2 && q3 && q4;
		}
		
		/**
		 * 添加一个数据 
		 * @param v
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function add(v:*, x:Number, y:Number):QuadTree
		{
			if (!isIn(x,y))
				return null;
			
			if (hasChildren)
			{
				return q1.add(v,x,y) || q2.add(v,x,y) || q3.add(v,x,y) || q4.add(v,x,y);
			}
			else
			{
				data.push(v);
				return this;
			}
		}
		
		/**
		 * 删除一个数据，坐标为NaN则会进行遍历查找 
		 * @param v
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function remove(v:*, x:Number = NaN, y:Number = NaN):QuadTree
		{
			if (!isIn(x,y))
				return null;
			
			if (hasChildren)
			{
				return q1.remove(v,x,y) || q2.remove(v,x,y) || q3.remove(v,x,y) || q4.remove(v,x,y);
			}
			else
			{
				var index:int = data.indexOf(v);
				if (index!=-1)
				{
					data.splice(index, 1);
					return this;
				}
				else
				{
					return null;
				}
			}
		}
		
		/**
		 * 检测是否还在当前区间内，并返回新的区间 
		 * @param v
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function reinsert(v:*, x:Number, y:Number):QuadTree
		{
			if (!isIn(x,y))
			{
				var result:QuadTree = root.add(v,x,y);
				if (result)
				{
					remove(v);
					return result;
				}
			}
			return this;
		}
		
		/**
		 * 判断坐标是否在界限内，设为NaN则不做限制 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function isIn(x:Number, y:Number):Boolean
		{
			return (isNaN(x) || x >= rect.x && x < rect.right) && (isNaN(y) || y >= rect.y && y < rect.bottom);
		}
		
		/**
		 * 获得一个范围内的所有数据
		 * 
		 * @param rect
		 * 
		 */
		public function getDataInRect(rect:Rectangle):Array
		{
			if (!this.rect.intersects(rect))
				return [];
			
			var result:Array = data.concat();
			if (hasChildren)
			{
				result.push.apply(null,q1.getDataInRect(rect));
				result.push.apply(null,q2.getDataInRect(rect));
				result.push.apply(null,q3.getDataInRect(rect));
				result.push.apply(null,q4.getDataInRect(rect));
			}
			return result;
		}
	}
}