package ghostcat.community
{
	import flash.events.EventDispatcher;
	
	import ghostcat.display.GBase;
	

	/**
	 * 针对景深排序进行了优化
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SortManager extends DisplayCommunityManager
	{
		public function SortManager(command:Function)
		{
			super(command);
		}
		
		public override function calculate(v:*):void
		{
			if (v is GBase)
			{
				if (!needCalculate(v))
					return;
			
				var g:GBase = v as GBase;
				var dy:Number = g.y - g.oldPosition.y;
				var index:int = g.parent.getChildIndex(g);
				var len:int = g.parent.numChildren;
				var i:int;
				var v2:*;
				
				
				if (dy > 0)
				{
					for (i = len - 1; i >=index + 1;i--)
					{
						v2 = g.parent.getChildAt(i);
						if (data.indexOf(v2)!= -1 && needCalculate(v2))
						{
							if (command(v,v2))
								break;
						}
					}
				}
				else if (dy < 0)
				{
					for (i = 0; i < index - 1;i++)
					{
						v2 = g.parent.getChildAt(i);
						if (data.indexOf(v2)!= -1 && needCalculate(v2))
						{
							if (command(v,v2))
								break;
						}
					}
				}
			}
			else
				super.calculate(v);
		}
		
		public override function add(obj:*):void
		{
			data.push(obj);
			
			if (obj is EventDispatcher && setDirtyWhenEvent)
				registerDirty(obj,setDirtyWhenEvent);
				
			super.calculate(obj);//加入时立即计算
			
		}
	}
}