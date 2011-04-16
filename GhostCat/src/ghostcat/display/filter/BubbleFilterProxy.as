package ghostcat.display.filter
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.core.UniqueCall;
	
	/**
	 * 水泡滤镜
	 * 必须用applyFilter方法来给对象应用滤镜
	 * 
	 * @author flashyiyi
	 * 
	 */
	public dynamic class BubbleFilterProxy extends FilterProxy
	{
		public var mask:BitmapData;
		
		private var updateCall:UniqueCall = new UniqueCall(update);
		private var updateMaskCall:UniqueCall = new UniqueCall(updateMask);
		
		public function BubbleFilterProxy()
		{
			super(new DisplacementMapFilter());
		}
		
		/**
		 * 深度 
		 * @return 
		 * 
		 */
		public function get deep():Number
		{
			return _deep;
		}
		
		public function set deep(v:Number):void
		{
			_deep = v;
			updateCall.invalidate();
		}
		
		/**
		 * 起点
		 * @return 
		 * 
		 */
		public function get pos():Point
		{
			return _pos;
		}
		
		public function set pos(v:Point):void
		{
			_pos = v;
			updateCall.invalidate();
		}
		
		/**
		 * 作用半径
		 * @return 
		 * 
		 */
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(v:Number):void
		{
			_radius = v;
			updateMaskCall.invalidate();
			updateCall.invalidate();
		}
		
		private var _radius:Number = 128;
		
		private var _pos:Point = new Point();
		
		private var _deep:Number =  -128;
		
		private function update():void
		{
			if (!mask)
				updateMask();
			
			changeFilter(createBubbleFilter(mask,pos,deep));
		}
		
		private function updateMask():void
		{
			if (mask)
				mask.dispose();
			
			mask = createBubbleMask(radius);
		}
		
		/**
		 * 以红绿通道生成渐进变化的色圆。
		 * 
		 * @return 
		 * 
		 */
		public static function createBubbleMask(radius:Number = 128,inner:Number = 100):BitmapData
		{
			var data:BitmapData = new BitmapData(radius*2,radius*2,false);
			for (var x:int = -radius; x < radius; x++)
			{
				for (var y:int = -radius; y < radius; y++) 
				{
					var i:Number = x / radius * 128;//数据规整到256方便运算
					var j:Number = y / radius * 128;
					var l:Number = new Point(i,j).length;
					var color:uint;
					if (l <= 128)
					{
						if (l > inner)//在圆外圈
						{
							color = int(i * Math.sqrt(128 * 128 - l * l) / 80 + 128) << 16;
							color += int(j * Math.sqrt(128 * 128 - l * l) / 80 + 128) << 8;
							color += int(Math.sqrt(128 * 128 - l * l) * 0.7 * Math.sqrt(128 * 128 - l * l) / 80);
							color += 128;
						}
						else //圆的内部
						{
							color = ((i + 128) << 16) + ((j + 128) << 8) + int(Math.sqrt(128 * 128 - l * l) * 0.7) + 128;
						}
					}
					else
					{
						color = 0x808080;//中性灰
					}
					
					data.setPixel(x + radius,y + radius,color);
				}
			}
			return data;
		}
		
		/**
		 * 放大镜（水泡）效果
		 * 
		 * @param bitmapData	水泡遮罩，需由createBubbleMask方法生成
		 * @param pos	水泡左上坐标
		 * @param deep	凹进的幅度（负值为凸出）
		 * @return 
		 * 
		 */		
		public static function createBubbleFilter(bitmapData:BitmapData, pos:Point,deep:Number = -128):DisplacementMapFilter
		{
			return new DisplacementMapFilter(bitmapData,pos,BitmapDataChannel.RED,BitmapDataChannel.GREEN,deep,deep)
		}
	}
}