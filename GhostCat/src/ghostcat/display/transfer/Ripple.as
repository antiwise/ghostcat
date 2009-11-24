package ghostcat.display.transfer
{
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.filters.ConvolutionFilter;
    import flash.filters.DisplacementMapFilter;
    import flash.filters.DisplacementMapFilterMode;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import ghostcat.display.GBase;
    import ghostcat.events.TickEvent;
    
	/**
	 * 波纹效果 
	 * 
	 */
    public class Ripple extends GBase
    {
		//扩展滤镜，将波纹展开
		private const expandFilter : ConvolutionFilter = new ConvolutionFilter(3, 3, [0.5, 1, 0.5, 1, 0, 1, 0.5, 1, 0.5], 3);
		//调色
		private const colorTransform : ColorTransform = new ColorTransform(1, 1, 1, 1, 127, 127, 127);
		
		private var buffer1 : BitmapData;
        private var buffer2 : BitmapData;
        private var defData : BitmapData;
		
        private var filter : DisplacementMapFilter;//移位滤镜，实现波纹扭曲
		private var m : Matrix;
        
        private var scaleInv : Number;//缓存scale的倒数
		private var strength : Number;//波幅
        
		/**
		 * 
		 * @param skin
		 * @param replace
		 * @param strength	波幅
		 * @param scale	放大倍速（波长）
		 * 
		 */
        public function Ripple(skin:* = null, replace:Boolean = true, strength : Number = 40, scale : Number = 3)
        {
			this.scaleInv = 1 / scale;
			this.strength = strength;
			
			super(skin,replace);
            
			this.enabledTick = true;
        }
		
		public override function setContent(skin:*,replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			
			disposeBuffer();
			
			if (!content)
				return;
				
            buffer1 = new BitmapData(content.width * scaleInv, content.height * scaleInv, false, 0x000000);
            buffer2 = new BitmapData(buffer1.width, buffer1.height, false, 0x000000);
            defData = new BitmapData(content.width, content.height);
            
			var correctedScaleX : Number = defData.width / buffer1.width;
			var correctedScaleY : Number = defData.height / buffer1.height;
            
            filter = new DisplacementMapFilter(buffer1, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE, strength, strength, DisplacementMapFilterMode.CLAMP);
			
			m = new Matrix();
			m.scale(correctedScaleX, correctedScaleY);
			
			content.filters = [filter];
        }
        
		/**
		 * 
		 * @param x
		 * @param y
		 * @param size	波浪半径
		 * @param alpha	波幅百分比
		 * 
		 */
        public function drawRipple(x : int, y : int, radius : int = 15, alpha : Number = 1.0) : void
        {
			var rect:Rectangle = content.getRect(content);
			var intensity : int = (alpha * 0xFF & 0xFF) * alpha;
			
			var drawRect:Rectangle = new Rectangle();
			drawRect.x = (x - rect.x - radius / 2) * scaleInv;	
            drawRect.y = (y - rect.y - radius / 2) * scaleInv;
            drawRect.width = drawRect.height = radius * scaleInv;
			
            buffer1.fillRect(drawRect, intensity);
        }
        
       	protected override function tickHandler(event:TickEvent) : void
        {
			var temp : BitmapData = buffer2.clone();
            buffer2.applyFilter(buffer1, buffer1.rect, new Point(), expandFilter);
            buffer2.draw(temp, null, null, BlendMode.SUBTRACT, null, false);
            defData.draw(buffer2, m, colorTransform, null, null, true);
            filter.mapBitmap = defData;
			content.filters = [filter];
            
			temp.dispose();
			
			temp = buffer1;
			buffer1 = buffer2;
			buffer2 = temp;
        }
		
		private function disposeBuffer():void
		{
			if (buffer1)
				buffer1.dispose();
			
			if (buffer2)
				buffer2.dispose();
			
			if (defData)
				defData.dispose();
			
			buffer1 = null;
			buffer2 = null;
			defData = null;
		}
		
		/**
		 * 销毁
		 */
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			disposeBuffer();
			
			super.destory();
		}
    }
}