package ghostcat.operation.effect
{
	import flash.geom.Point;
	
	import ghostcat.operation.TweenOper;
	import ghostcat.util.display.Geom;
	
	/**
	 * 缩放
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ZoomEffect extends TweenOper
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
		public function ZoomEffect(target:*=null, center:Point = null, scale:Number = 1.0, duration:int=100, params:Object=null, invert:Boolean=false)
		{
			this.center = center;
			this.scale = scale;
			
			super(target, duration, params, invert);
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			if (!params)
				params = new Object();
			
			if (!center)
				center = Geom.center(target);
			
			params.scaleX = params.scaleY = this.scale;
			params.x = target.x + (target.x - center.x) * (scale - target.scaleX) / target.scaleX;
			params.y = target.y + (target.y - center.y) * (scale - target.scaleY) / target.scaleY;
			super.execute();
		}
	}
}