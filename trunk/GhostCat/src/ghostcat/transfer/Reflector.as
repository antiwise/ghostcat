package ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	
	/**
	 * 倒影
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Reflector extends GBitmapTransfer
	{
		private var _falloff: Number = 0.6;
		private var _distance: Number = 10;
		
		public function Reflector(target:DisplayObject=null):void
		{
			super(target);
		}               
		/**
		 * 倒影高度占原高度的百分比
		 * @return 
		 * 
		 */
		public function get falloff(): Number
		{
			return _falloff;
		}
		                
		public function set falloff(value: Number): void
		{
			_falloff = value;
			updateTargetResize();
		}
		
		/**
		 * 与原物品的距离
		 * @return 
		 * 
		 */
		public function get distance():Number
		{
			return _distance;
		}
		
		public function set distance(value: Number):void
		{
			_distance = value;
			updateTargetMove();
		}
		
		/**
		 * 更新目标位置
		 * 
		 */
		public override function updateTargetMove():void
		{
			var rect:Rectangle = _target.getBounds(this);
			x = rect.x + this.x;
			y = rect.bottom + this.y + _distance;
		}
		
		protected override function render(): void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var m:Matrix = new Matrix();
			m.scale(1, -1);
			m.translate(-rect.x, rect.bottom);
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.draw(_target,m);	
			
			m = new Matrix();
			m.createGradientBox(rect.width, rect.height * _falloff, Math.PI/2);
			var sh: Shape = new Shape();
			sh.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0.6, 0.2, 0.0], [0, 125,255], m);
			sh.graphics.drawRect(0, 0,rect.width, rect.height * _falloff);
			sh.graphics.endFill();
			bitmapData.draw(sh,null,null,BlendMode.ALPHA);
		}
		
		protected override function createBitmapData():void
		{
			bitmapData && bitmapData.dispose();
			
			var rect: Rectangle = _target.getBounds(_target);
			if (rect.width && rect.height)
				bitmapData = new BitmapData(Math.ceil(rect.width),Math.ceil(rect.height) * _falloff,true,0);
		}
	}
}