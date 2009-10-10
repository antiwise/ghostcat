package ghostcat.community
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import ghostcat.display.GBase;
	

	/**
	 * 针对景深排序进行了优化
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SortYManager extends GBaseCommunityManager
	{
		public function SortYManager()
		{
			super(sortCommand);
		}
		
		/**
		 * 获得深度变化正负
		 * @param g
		 * @return 
		 * 
		 */
		protected function getDeepOffest(g:GBase):Number
		{
			return g.y - g.oldPosition.y;
		}
		
		/**
		 * 排序方法
		 * @param d1
		 * @param d2
		 * @return 
		 * 
		 */
		protected function sortCommand(d1:DisplayObject,d2:DisplayObject):Boolean
		{
			if (d1.parent != d2.parent)
				return false;
				
			var parent:DisplayObjectContainer = d1.parent;
			
			var i1:int = parent.getChildIndex(d1);
			var i2:int = parent.getChildIndex(d2);
			var isHighIndex:Boolean = i1 > i2; 
			var isHighValue:Boolean = d1.y > d2.y;
			
			if (isHighIndex != isHighValue)
			{
				parent.setChildIndex(d1,i2);
				return true;
			}
			return false;
		}
		
		public override function calculate(v:*):void
		{
			if (filter!=null && filter(v)==false)
				return;
			
			var g:GBase = v as GBase;
			var dy:Number = getDeepOffest(g);
			var index:int = g.parent.getChildIndex(g);
			var len:int = g.parent.numChildren;
			var i:int;
			var v2:*;
			
			
			if (dy > 0)
			{
				for (i = len - 1; i >=index + 1;i--)
				{
					v2 = g.parent.getChildAt(i);
					if (data.indexOf(v2)!= -1 && !(filter!=null && filter(v2)==false))
					{
						if (sortCommand(v,v2))
							break;
					}
				}
			}
			else if (dy < 0)
			{
				for (i = 0; i < index - 1;i++)
				{
					v2 = g.parent.getChildAt(i);
					if (data.indexOf(v2)!= -1 && !(filter!=null && filter(v2)==false))
					{
						if (sortCommand(v,v2))
							break;
					}
				}
			}
			
		}
		
		public override function add(obj:*):void
		{
			if (!(obj is GBase))
				throw new Error("只能加入继承于GBase的对象")
			
			data.push(obj);
			
			if (obj is EventDispatcher && setDirtyWhenEvent)
				registerDirty(obj,setDirtyWhenEvent);
				
			super.calculate(obj);//加入时立即计算
			
		}
	}
}