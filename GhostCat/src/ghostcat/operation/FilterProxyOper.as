package ghostcat.operation
{
	import flash.filters.BitmapFilter;
	
	import ghostcat.display.filter.FilterProxy;
	import ghostcat.util.ReflectUtil;

	/**
	 * 滤镜代理Tween
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FilterProxyOper extends TweenOper
	{
		/**
		 * 滤镜目标
		 */
		public var filterTarget:*;
		
		/**
		 * 滤镜
		 */
		public var filter:BitmapFilter;
		
		/**
		 * 自动更新滤镜位置
		 */
		public var autoUpdateIndex:Boolean = false;
		
		/**
		 * 是否每帧后延迟更新
		 */
		public var callLater:Boolean;
		
		public override function set target(v:*) : void
		{
			filterTarget = v;
		}
		
		public override function get target() : *
		{
			return filterTarget;
		}
		
		public function FilterProxyOper(target:* = null,filter:BitmapFilter=null,duration:int=100, params:Object=null, invert:Boolean=false, autoUpdateIndex:Boolean = false, callLater:Boolean = false)
		{
			this.filter = filter;
			this.filterTarget = target;
			
			this.autoUpdateIndex = autoUpdateIndex;
			this.callLater = callLater;
			
			super(null, duration, params, invert);
		}
		
		public override function execute() : void
		{
			var proxy:FilterProxy = new FilterProxy(filter.clone(),autoUpdateIndex,callLater);
			var target:*;
			if (filterTarget is String)
				target = ReflectUtil.eval(filterTarget);
			else
				target = filterTarget;
			
			proxy.applyFilter(target);
			
			this._target = proxy;
			
			super.execute();
		}
		
		protected override function end(event:*=null):void
		{
			super.end(event);
			(_target as FilterProxy).destory();
		}
	}
}