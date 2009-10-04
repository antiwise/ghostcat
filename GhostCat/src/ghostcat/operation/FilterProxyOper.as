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
		 * 滤镜
		 */
		public var filter:BitmapFilter;
		/**
		 * 滤镜目标
		 */
		public var filterTarget:*;
		
		public function FilterProxyOper(target:DisplayObject=null,filter:BitmapFilter=null,duration:int=100, params:Object=null, invert:Boolean=false)
		{
			super(null, duration, params, invert);
			this.filter = filter;
			this.filterTarget = target;
		}
		
		public override function execute() : void
		{
			var proxy:FilterProxy = new FilterProxy(this.filter.clone());
			proxy.applyFilter(filterTarget);
			
			this.target = proxy;
			super.execute();
		}
	}
}