package ghostcat.operation.effect
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	import ghostcat.util.ColorUtil;
	
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
		/** @inheritDoc*/
		public override function execute():void
		{
			this.alpha = fromAlpha;
			
			this.list = [new TweenEffect(this,duration,{alpha:toAlpha}),
							new TweenEffect(this,duration,{alpha:fromAlpha})];
			
			super.execute();
		}
	}
}