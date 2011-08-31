package ghostcat.display.filter
{
	import flash.filters.ColorMatrixFilter;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.core.UniqueCall;
	
	/**
	 * 色彩变换滤镜，可以同时调整对比度，色相等参数
	 * 必须用applyFilter方法来给对象应用滤镜
	 * 
	 * @author flashyiyi
	 * 
	 */
	public dynamic class MultiColorMatrixFilterProxy extends FilterProxy
	{
		private var _brightness:Number;

		/**
		 * 亮度
		 */
		public function get brightness():Number
		{
			return _brightness;
		}

		public function set brightness(value:Number):void
		{
			if (_brightness == value)
				return;
			
			_brightness = value;
			updateCall.invalidate();
		}

		
		private var _contrast:Number;

		/**
		 * 对比度
		 */
		public function get contrast():Number
		{
			return _contrast;
		}

		public function set contrast(value:Number):void
		{
			if (_contrast == value)
				return;
			
			_contrast = value;
			updateCall.invalidate();
		}

		
		private var _saturation:Number;

		/**
		 * 色彩饱和度
		 */
		public function get saturation():Number
		{
			return _saturation;
		}

		public function set saturation(value:Number):void
		{
			if (_saturation == value)
				return;
			
			_saturation = value;
			updateCall.invalidate();
		}

		
		private var _hue:Number;

		/**
		 * 色相偏移 
		 */
		public function get hue():Number
		{
			return _hue;
		}

		public function set hue(value:Number):void
		{
			if (_hue == value)
				return;
			
			_hue = value;
			updateCall.invalidate();
		}

		
		private var _threshold:Number;

		/**
		 * 阈值
		 */
		public function get threshold():Number
		{
			return _threshold;
		}

		public function set threshold(value:Number):void
		{
			if (_threshold == value)
				return;
			
			_threshold = value;
			updateCall.invalidate();
		}

		
		private var _inversion:Boolean;

		/**
		 * 颜色反相
		 */
		public function get inversion():Boolean
		{
			return _inversion;
		}

		public function set inversion(value:Boolean):void
		{
			if (_inversion == value)
				return;
			
			_inversion = value;
			updateCall.invalidate();
		}
		
		private var _monocro:uint;
		
		/**
		 * 着色
		 */
		public function get monocro():uint
		{
			return _monocro;
		}
		
		public function set monocro(value:uint):void
		{
			if (_monocro == value)
				return;
			
			_monocro = value;
			updateCall.invalidate();
		}
		
		private var updateCall:UniqueCall = new UniqueCall(update);
		
		public function MultiColorMatrixFilterProxy(brightness:Number = 0,contrast:Number = 0,saturation:Number = 0,hue:Number = 0,threshold:Number = 0,inversion:Boolean = false,monocro:uint = 0)
		{
			super(new ColorMatrixFilter());
			
			this.brightness = brightness;
			this.contrast = contrast;
			this.saturation = saturation;
			this.hue = hue;
			this.threshold = threshold;
			this.inversion = inversion;
			this.monocro = monocro;
		}
		
		private function update():void
		{
			changeFilter(new ColorMatrixFilter(createMultColorMatrix(brightness,contrast,saturation,hue,threshold,inversion)));
		}
		
		public override function destory():void
		{
			updateCall.destory();
			super.destory();
		}
		
		public static function createMultColorMatrix(brightness:Number = 0,contrast:Number = 0,saturation:Number = 0,hue:Number = 0,threshold:Number = 0,inversion:Boolean = false,monocro:uint = 0):Array
		{
			var m:Array = [1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0];
			
			if (brightness)
				m = concatMatrix(m,createBrightnessMatrix(brightness));
			if (contrast)
				m = concatMatrix(m,createContrastMatrix(contrast));
			if (saturation)
				m = concatMatrix(m,createSaturationMatrix(saturation));
			if (hue)
				m = concatMatrix(m,createHueMatrix(hue));
			if (threshold)
				m = concatMatrix(m,createThresholdMatrix(threshold));
			if (inversion)
				m = concatMatrix(m,createInversionMatrix());
			if (monocro)
				m = concatMatrix(m,createMonocroMatrix(monocro));
			
			return m;
		}
		
		/**
         * 色彩饱和度
         * 
         * @param n (N取值为-100到100)
         * @return 
         * 
         */
        public static function createSaturationMatrix(n:Number):Array
        {
			n = n / 100 + 1;
			return [0.3086*(1-n)+ n,	0.6094*(1-n),	0.0820*(1-n),	0,	0,
						 0.3086*(1-n),	0.6094*(1-n) + n,	0.0820*(1-n),	0,	0,
						 0.3086*(1-n),	0.6094*(1-n)    ,	0.0820*(1-n) + n,	0,	0,
						 0,	0,	0,	1,	0];
        }
		
		/**
		 * 黑白矩阵
		 * 
		 * @return 
		 * 
		 */
		public static function createGrayMatrix():Array
		{
			return [0.3086,	0.6094,	0.0820,	0,	0,
				0.3086,	0.6094,	0.0820,	0,	0,
				0.3086,	0.6094,	0.0820,	0,	0,
				0,	0,	0,	1,	0];
		}
        
        /**
         * 对比度
         * 
         * @param n (N取值为-100到100)
         * @return 
         * 
         */
        public static function createContrastMatrix(n:Number):Array
        {
			n = n / 100;
			return [n + 1,	0,	0,	0,	-128 * n,
					 0,	n + 1,	0,	0,	-128 * n,
					 0,	0,	n + 1,	0,	-128 * n,
					 0,	0,	0,	1,	0];
        }
        
        /**
         * 亮度(N取值为-100到100)
         * 
         * @param n
         * @return 
         * 
         */
        public static function createBrightnessMatrix(n:Number):Array
        {
			n = n / 100 * 255;
        	return [1,	0,	0,	0,	n,
						 0,	1,	0,	0,	n,
						 0,	0,	1,	0,	n,
						 0,	0,	0,	1,	0];
        }
        
        /**
         * 颜色反相
         * 
         * @return 
         * 
         */
        public static function createInversionMatrix():Array
        {
        	return [-1,	0,	0,	0,	255,
						 0,	-1,	0,	0,	255,
						 0,	0,	-1,	0,	255,
						 0,	0,	0,	1,	0];
        }
		
		/**
		 * 色相偏移（n取值为-180到180）
		 * @return 
		 * 
		 */
		public static function createHueMatrix(n:Number):Array
		{
			const p1:Number = Math.cos(n * Math.PI / 180);
			const p2:Number = Math.sin(n * Math.PI / 180);
			const p4:Number = 0.213;
			const p5:Number = 0.715;
			const p6:Number = 0.072;
			return [p4 + p1 * (1 - p4) + p2 * (0 - p4), p5 + p1 * (0 - p5) + p2 * (0 - p5), p6 + p1 * (0 - p6) + p2 * (1 - p6), 0, 0, 
				p4 + p1 * (0 - p4) + p2 * 0.143, p5 + p1 * (1 - p5) + p2 * 0.14, p6 + p1 * (0 - p6) + p2 * -0.283, 0, 0, 
				p4 + p1 * (0 - p4) + p2 * (0 - (1 - p4)), p5 + p1 * (0 - p5) + p2 * p5, p6 + p1 * (1 - p6) + p2 * p6, 0, 0,
				0, 0, 0, 1, 0];
		}
        
        /**
         * 阈值
         * 
         * @param n(N取值为-100到100)
         * @return 
         * 
         */
        public static function createThresholdMatrix(n:Number):Array
        {
			n = n / 100;
        	return [0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
						 0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
						 0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
						 0, 0, 0, 1, 0];
        }
		
		/**
		 * 单色滤镜 
		 * @param c 颜色值
		 * @return 
		 * 
		 */
		public static function createMonocroMatrix(c:uint):Array
		{
			var r:Number = ((c >> 16) & 0xFF) / 0xFF / 3;
			var g:Number = ((c >> 8) & 0xFF) / 0xFF / 3;
			var b:Number = (c & 0xFF) / 0xFF / 3;
			return [
				r,r,r,0,0,
				g,g,g,0,0,
				b,b,b,0,0,
				0,0,0,1,0,
			];
		}
		
		/**
		 * 合并两个颜色矩阵 
		 * @param m1
		 * @param m2
		 * 
		 */
		public static function concatMatrix(m1:Array,m2:Array):Array
		{
			var result:Array = [];
			for (var i:int = 0;i < m1.length;i++)
				result[i] = m1[i] + m2[i];
			
			result[0]--;
			result[6]--;
			result[12]--;
			result[18]--;
			return result;
		}
	}
}