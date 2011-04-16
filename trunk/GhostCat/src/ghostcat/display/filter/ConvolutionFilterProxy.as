package ghostcat.display.filter
{
	import flash.filters.ConvolutionFilter;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.core.UniqueCall;
	
	/**
	 * Convolution滤镜
	 * 必须用applyFilter方法来给对象应用滤镜
	 *  
	 * @author flashyiyi
	 * 
	 */
	public dynamic class ConvolutionFilterProxy extends FilterProxy
	{
		/**
		 * 高斯模糊
		 */
		public static const GAUSS:int = 0;
		/**
		 * 锐化
		 */
		public static const SHARPE:int = 1;
		/**
		 * 查找边缘
		 */
		public static const EDGE:int = 2;
		
		private var _type:int = 0;
		
		private var updateCall:UniqueCall = new UniqueCall(update);
		
		public function ConvolutionFilterProxy(type:int)
		{
			super(new ConvolutionFilter())
			this.type = type;
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
				case GAUSS:
					changeFilter(createGaussFilter());
					break;
				case SHARPE:
					changeFilter(createSharpeFilter());
					break;
				case EDGE:
					changeFilter(createEdgeFilter());
					break;
				default:
					Debug.error("不允许的取值");
					break;
			}
		}
		
       /**
         * 高斯模糊滤镜
         *  
         * @return 
         * 
         */
        public static function createGaussFilter():ConvolutionFilter
        {
        	var matrix:Array = [1, 2, 1, 
        						2, 4, 2, 
        						1, 2, 1];
        	return new ConvolutionFilter(3,3,matrix,16);
        }
        
        /**
         * 锐化滤镜
         * 
         * @return 
         * 
         */
        public static function createSharpeFilter():ConvolutionFilter
        {
        	var matrix:Array = [-1, -1, -1, 
        						-1, 9, -1, 
        						-1, -1, -1];
        	return new ConvolutionFilter(3,3,matrix);
        }
        
        /**
         * 查找边缘滤镜
         * 
         * @return 
         * 
         */
        public static function createEdgeFilter():ConvolutionFilter
        {
        	var matrix:Array = [-2, -4, -4, -4, -2, 
        						-4, 0, 8, 0, -4, 
        						-4, 8, 24, 8, -4, 
        						-4, 0, 8, 0, -4, 
        						-2, -4, -4, -4, -2];
        	return new ConvolutionFilter(5, 5, matrix);
        }
	}
}