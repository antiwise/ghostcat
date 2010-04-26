package ghostcat.operation.effect
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.util.display.ColorUtil;
	
	/**
	 * 颜色闪烁效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ColorFlashEffect extends RepeatEffect
	{
		/**
		 * 颜色 
		 */
		public var color:uint;
		/**
		 * 持续时间
		 */
		public var duration:int;
		/**
		 * 起始透明度
		 */
		public var fromAlpha:Number;
		/**
		 * 结束透明度
		 */
		public var toAlpha:Number;
		
		public function ColorFlashEffect(target:*=null, duration:int=1000, color:uint = 0xFFFFFF,fromAlpha:Number = 0.0, toAlpha:Number = 0.5, loop:int = -1)
		{
			super(null, loop);
		
			this.target = target;
			this.color = color;
			this.duration = duration;
			this.fromAlpha = fromAlpha;
			this.toAlpha = toAlpha;
		}
		
		private var _alpha:Number;
		
		/**
		 * 颜色透明度 
		 * @return 
		 * 
		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(v:Number):void
		{
			_alpha = v;
			(target as DisplayObject).transform.colorTransform = ColorUtil.getColorTransform2(color,_alpha);
		}
		
		public function clearCurrent():void
		{
			if (children && index >= 0 && index < children.length)
				children[index].halt();
			
			(target as DisplayObject).transform.colorTransform = new ColorTransform(color,fromAlpha);
		}
		
		/** @inheritDoc*/
		public override function execute():void
		{
			if (this.step == Oper.RUN)//清理重复调用
			{
				this.end();
				this.clearCurrent();
			}
			
			this._alpha = fromAlpha;
			this.children = [new TweenOper(this,duration,{alpha:toAlpha}),
							new TweenOper(this,duration,{alpha:fromAlpha})];
			
			super.execute();
		}
	}
}