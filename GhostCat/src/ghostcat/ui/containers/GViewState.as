package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.GBase;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.effect.IEffect;
	
	/**
	 * 切换显示容器
	 * 
	 * 标签规则：子对象成为不同的View，只显示其中一个
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GViewState extends GBase
	{
		public var showFromLeft:IEffect;
		public var showFromRight:IEffect;
		public var hideToLeft:IEffect;
		public var hideToRight:IEffect;
		
		protected var _selectedIndex:int = -1;
		
		public function GViewState(skin:* = null,replace:Boolean = true)
		{
			super(skin, replace);
			
			var container:DisplayObjectContainer = content as DisplayObjectContainer;
			for (var i:int = 0; i < container.numChildren; i++)
				container.getChildAt(i).visible = false;
			
			selectedIndex = 0;
		}

		/**
		 * 选择显示的容器 
		 * @return 
		 * 
		 */
		public function get selectedChild():DisplayObject
		{
			if (_selectedIndex == -1)
				return null;
			else if (_selectedIndex >= (content as DisplayObjectContainer).numChildren)
				return null;
			else
				return (content as DisplayObjectContainer).getChildAt(_selectedIndex);
		}

		public function set selectedChild(v:DisplayObject):void
		{
			var container:DisplayObjectContainer = content as DisplayObjectContainer;
			
			for (var i:int = 0; i < container.numChildren; i++)
			{
				if (v == container.getChildAt(i))
				{
					selectedIndex = i;
					return;
				}
			}
			selectedIndex = -1;
		}

		/**
		 * 选择的容器的索引
		 * @return 
		 * 
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(v:int):void
		{
			if (_selectedIndex == v)
				return;
			
			var tweenToRight:Boolean = v > _selectedIndex;
			var effect:IEffect;
			var container:DisplayObjectContainer = content as DisplayObjectContainer;
			if (_selectedIndex != -1 && _selectedIndex < container.numChildren)
			{
				var page:DisplayObject = container.getChildAt(_selectedIndex);
				effect = tweenToRight ? hideToRight : hideToLeft;
				if (effect)
				{
					effect.target = page;
					
					effect.addEventListener(OperationEvent.OPERATION_COMPLETE,tweenCompleteHandler);
					effect.execute();
				}
				else
				{
					page.visible = false;
				}
			}
				
			_selectedIndex = v;
				
			if (_selectedIndex != -1 && _selectedIndex < container.numChildren)
			{
				var page2:DisplayObject = container.getChildAt(_selectedIndex);
				effect = tweenToRight ? showFromLeft : showFromRight;
				page2.visible = true;
				if (effect)
				{
					effect.target = page2;
					
					effect.removeEventListener(OperationEvent.OPERATION_COMPLETE,tweenCompleteHandler);
					effect.execute();
				}
			}
		}
		
		private function tweenCompleteHandler(event:OperationEvent):void
		{
			var tween:IEffect = event.currentTarget as IEffect;
			tween.target.visible = selectedChild == tween.target;
			tween.removeEventListener(OperationEvent.OPERATION_COMPLETE,tweenCompleteHandler);
		}

	}
}