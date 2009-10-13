package ghostcat.filter
{
	import flash.filters.ColorMatrixFilter;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.core.CallLater;
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
		 * 阈值
		 */
		public static const THRESHOLD:int = 4;
		
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