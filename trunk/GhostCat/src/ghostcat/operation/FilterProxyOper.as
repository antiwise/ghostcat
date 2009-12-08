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
		
		private var proxy:FilterProxy;
		
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
			this.filterTarget = target;
			this.proxy = new FilterProxy(filter.clone());
		
			super(this.proxy, duration, params, invert);
		}
		
		public override function execute() : void
		{
			proxy.applyFilter(filterTarget);
			
			super.execute();
		}
	}
}