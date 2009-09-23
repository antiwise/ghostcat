package ghostcat.operation.effect
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	import ghostcat.util.ColorUtil;
	
	
	
	public class ColorFlashEffect extends RepeatEffect
	{
		public var color:uint;
		public var duration:int;
		public var fromAlpha:Number;
		public var toAlpha:Number;
		
		public function ColorFlashEffect(target:*, duration:int, color:uint = 0xFFFFFF,fromAlpha:Number = 0.0, toAlpha:Number = 0.5, loop:int = -1)
		{
			super(null, loop);
		
			this.target = target;
			this.color = color;
			this.duration = duration;
			this.fromAlpha = fromAlpha;
			this.toAlpha = toAlpha;
		}
		
		private var _alpha:Number;
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(v:Number):void
		{
			_alpha = v;
			(target as DisplayObject).transform.colorTransform = ColorUtil.getColorTransform2(color,_alpha);
		}
		
		public override function execute():void
		{
			this.alpha = fromAlpha;
			
			this.list = [new TweenEffect(this,duration,{alpha:toAlpha}),
							new TweenEffect(this,duration,{alpha:fromAlpha})];
			
			super.execute();
		}
	}
}