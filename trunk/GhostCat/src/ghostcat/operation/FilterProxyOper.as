package ghostcat.operation
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	import ghostcat.filter.FilterProxy;

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
		
		public override function set target(v:*) : void
		{
			filterTarget = v;
		}
		
		public override function get target() : *
		{
			return filterTarget;
		}
		
		public function FilterProxyOper(target:DisplayObject=null,filter:BitmapFilter=null,duration:int=100, params:Object=null, invert:Boolean=false)
		{
			this.filter = filter;
			this.filterTarget = target;
		
			super(null, duration, params, invert);
		}
		
		public override function execute() : void
		{
			var proxy:FilterProxy = new FilterProxy(filter.clone());
			proxy.applyFilter(filterTarget);
			
			this._target = proxy;
			
			super.execute();
		}
	}
}