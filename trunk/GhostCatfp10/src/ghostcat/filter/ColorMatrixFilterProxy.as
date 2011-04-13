package ghostcat.filter
{
	import flash.filters.ColorMatrixFilter;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.core.UniqueCall;
	
	/**
	 * 色彩变换滤镜
	 * 
	 * @author flashyiyi
	 * 
	 */
	public dynamic class ColorMatrixFilterProxy extends FilterProxy
	{
		/**
		 * 色彩饱和度
		 */
		public static const SATURATION:int = 0;
		/**
		 * 对比度
		 */
		public static const CONTRAST:int = 1;
		/**
		 * 亮度
		 */
		public static const BRIGHTNESS:int = 2;
		/**
		 * 颜色反相
		 */
		public static const INVERSION:int = 3;
		
		/**
		 * 色相偏移 
		 */
		public static const HUE:int = 4;
		/**
		 * 阈值
		 */
		public static const THRESHOLD:int = 5;
		
		private var _type:int;
		private var _n:int;
		
		private var updateCall:UniqueCall = new UniqueCall(update);
		
		public function ColorMatrixFilterProxy(type:int,n:int)
		{
			super(new ColorMatrixFilter())
			this.type = type;
			this.n = n;
		}
		
		/**
		 * 滤镜需要的参数
		 * @return 
		 * 
		 */
		public function get n():int
		{
			return _n;
		}

		public function set n(v:int):void
		{
			_n = v;
			updateCall.invalidate();
		}

		/**
		 * 滤镜类型 
		 * @return 
		 * 
		 */
		public function get type():int
		{
			return _type;
		}
		
		public function set type(v:int):void
		{
			_type = v;
			updateCall.invalidate();
		}
		private function update():void
		{
			switch (type)
			{
				case SATURATION:
					changeFilter(createSaturationFilter(n));
					break;
				case CONTRAST:
					changeFilter(createContrastFilter(n));
					break;
				case BRIGHTNESS:
					changeFilter(createBrightnessFilter(n));
					break;
				case INVERSION:
					changeFilter(createInversionFilter());
					break;
				case HUE:
					changeFilter(createHueFilter(n));
					break;
				case THRESHOLD:
					changeFilter(createThresholdFilter(n));
					break;
				default:
					Debug.error("错误的取值")
					break;
			}
		}
		
		/**
         * 色彩饱和度
         * 
         * @param n (N取值为0到255)
         * @return 
         * 
         */
        public static function createSaturationFilter(n:Number):ColorMatrixFilter
        {
        	return new ColorMatrixFilter([0.3086*(1-n)+ n,	0.6094*(1-n),	0.0820*(1-n),	0,	0,
						 0.3086*(1-n),	0.6094*(1-n) + n,	0.0820*(1-n),	0,	0,
						 0.3086*(1-n),	0.6094*(1-n)    ,	0.0820*(1-n) + n,	0,	0,
						 0,	0,	0,	1,	0]);
        }
        
        /**
         * 对比度
         * 
         * @param n (N取值为0到10)
         * @return 
         * 
         */
        public static function createContrastFilter(n:Number):ColorMatrixFilter
        {
        	return new ColorMatrixFilter([n,	0,	0,	0,	128*(1-n),
						 0,	n,	0,	0,	128*(1-n),
						 0,	0,	n,	0,	128*(1-n),
						 0,	0,	0,	1,	0]);
        }
        
        /**
         * 亮度(N取值为-255到255)
         * 
         * @param n
         * @return 
         * 
         */
        public static function createBrightnessFilter(n:Number):ColorMatrixFilter
        {
        	return new ColorMatrixFilter([1,	0,	0,	0,	n,
						 0,	1,	0,	0,	n,
						 0,	0,	1,	0,	n,
						 0,	0,	0,	1,	0]);
        }
        
        /**
         * 颜色反相
         * 
         * @return 
         * 
         */
        public static function createInversionFilter():ColorMatrixFilter
        {
        	return new ColorMatrixFilter([-1,	0,	0,	0,	255,
						 0,	-1,	0,	0,	255,
						 0,	0,	-1,	0,	255,
						 0,	0,	0,	1,	0]);
        }
		
		/**
		 * 色相偏移 
		 * @return 
		 * 
		 */
		public static function createHueFilter(n:Number):ColorMatrixFilter
		{
			const p1:Number = Math.cos(n * Math.PI / 180);
			const p2:Number = Math.sin(n * Math.PI / 180);
			const p4:Number = 0.213;
			const p5:Number = 0.715;
			const p6:Number = 0.072;
			return new ColorMatrixFilter([p4 + p1 * (1 - p4) + p2 * (0 - p4), p5 + p1 * (0 - p5) + p2 * (0 - p5), p6 + p1 * (0 - p6) + p2 * (1 - p6), 0, 0, 
				p4 + p1 * (0 - p4) + p2 * 0.143, p5 + p1 * (1 - p5) + p2 * 0.14, p6 + p1 * (0 - p6) + p2 * -0.283, 0, 0, 
				p4 + p1 * (0 - p4) + p2 * (0 - (1 - p4)), p5 + p1 * (0 - p5) + p2 * p5, p6 + p1 * (1 - p6) + p2 * p6, 0, 0,
				0, 0, 0, 1, 0]);
		}
        
        /**
         * 阈值
         * 
         * @param n(N取值为-255到255)
         * @return 
         * 
         */
        public static function createThresholdFilter(n:Number):ColorMatrixFilter
        {
        	return new ColorMatrixFilter([0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
						 0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
						 0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
						 0, 0, 0, 1, 0]);
        }
	}
}