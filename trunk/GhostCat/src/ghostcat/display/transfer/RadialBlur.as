package ghostcat.display.transfer
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	
	/**
	 * 径向旋转加亮模糊 
	 * @author flashyiyi
	 * 
	 */
	public class RadialBlur extends GBitmapEffect
	{
		/**
		 * 缩放速度
		 */
		public var scaleSpeed:Number;
		
		/**
		 * 旋转速度
		 */
		public var rotationSpeed:Number;
		
		/**
		 * 发光速度 
		 */
		public var lightSpeed:Number;
		
		/**
		 * 固定变化间隔
		 */
		public var interval:Number;
		
		private var _enabledTickRender:Boolean;
		private var r:Number = 0.0;
		private var s:Number = 1.0;
		
		public function RadialBlur(target:DisplayObject=null,scaleSpeed:Number = 1,rotationSpeed:Number = 1,lightSpeed:Number = 0.2)
		{
			super(target);
			
			this.scaleSpeed = scaleSpeed;
			this.rotationSpeed = rotationSpeed;
			this.lightSpeed = lightSpeed;
			this.byAlpha = false;
			
			this.start();
		}
		
		public override function start():void
		{
			r = 0.0;
			s = 1.0;
			renderTarget();
			bitmapData.copyPixels(normalBitmapData,normalBitmapData.rect,new Point());
		
			super.start();
		}
		
		protected override function renderTickHandler(event:TickEvent):void
		{
			if (!parent)
				return;
			
			var inv:Number = interval;
			if (!inv)
				inv = event.interval;
			
			r += rotationSpeed * inv / 1000;
			s *= 1 + scaleSpeed * inv / 1000;
			
			var m:Matrix = new Matrix();
			var w:Number = normalBitmapData.width / 2;
			var h:Number = normalBitmapData.height / 2;
			
			m.translate(-w,-h);
			m.scale(s,s);
			m.rotate(r);
			m.translate(w,h);
			
			bitmapData.draw(normalBitmapData,m,new ColorTransform(1,1,1,lightSpeed),BlendMode.ADD);
		}
	}
}