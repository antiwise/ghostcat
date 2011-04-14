package ghostcat.operation
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	
	import ghostcat.display.filter.FilterProxy;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.easing.TweenEvent;

	/**
	 * 顏色變化Tween
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ColorTransfromOper extends TweenOper
	{
		private var filterTarget:*;
		
		/**
		 * 顏色變化
		 */
		public var transform:ColorTransform;
		
		/**
		 * 目标
		 */
		public override function set target(v:*) : void
		{
			filterTarget = v;
		}
		
		public override function get target() : *
		{
			return filterTarget;
		}
		
		public function ColorTransfromOper(target:* = null,transform:ColorTransform=null,duration:int=100, params:Object=null, invert:Boolean=false)
		{
			this.transform = transform;
			if (!this.transform)
				this.transform = new ColorTransform();
			
			this.filterTarget = target;
			
			super(transform, duration, params, invert);
		}
		
		public override function execute() : void
		{
			super.execute();
			if (tween)
				tween.addEventListener(TweenEvent.TWEEN_UPDATE,updateHandler);
		}
		
		protected override function end(event:*=null):void
		{
			super.end(event);
			if (tween)
				tween.removeEventListener(TweenEvent.TWEEN_UPDATE,updateHandler);
		}
		
		protected function updateHandler(event:TweenEvent):void
		{
			var target:*;
			if (filterTarget is String)
				target = ReflectUtil.eval(filterTarget);
			else
				target = filterTarget;
			
			if (target is DisplayObject)
				(target as DisplayObject).transform.colorTransform = transform;
		}
	}
}