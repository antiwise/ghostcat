package ghostcat.operation
{
	import flash.geom.Point;
	
	import ghostcat.util.display.Geom;

	/**
	 * 缩放
	 * @author flashyiyi
	 * 
	 */
	public class ZoomOper extends TweenOper
	{
		/**
		 * 中心点（父节点坐标系）
		 */
		public var center:Point;
		
		/**
		 * 缩放比
		 */
		public var scale:Number;
		
		/**
		 * 
		 * @param target	目标
		 * @param center	中心点（父坐标系），默认取图形的中心
		 * @param scale	缩放比
		 * @param duration
		 * @param params
		 * @param invert
		 * 
		 */
		public function ZoomOper(target:*=null, center:Point = null, scale:Number = 1.0, duration:int=100, params:Object=null, invert:Boolean=false)
		{
			if (!center)
				center = Geom.center(target);
			
			this.center = center;
			this.scale = scale;
			
			super(target, duration, params, invert);
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			if (!params)
				params = new Object();
			
			params.scaleX = params.scaleY = this.scale;
			params.x = center.x * (1 - scale);
			params.y = center.y * (1 - scale);
			super.execute();
		}
	}
}