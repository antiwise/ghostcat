package ghostcat.display.filter
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.core.UniqueCall;

	/**
	 * 波纹滤镜
	 * 必须用applyFilter方法来给对象应用滤镜
	 * 
	 * @author flashyiyi
	 * 
	 */
	public dynamic class WaveHVFilterProxy extends FilterProxy
	{
		/**
		 * 横向波纹 
		 */
		public static const HWAVE:int = 1;
		/**
		 * 纵向波纹
		 */
		public static const VWAVE:int = 2;
		
		public var mask:BitmapData;
		
		private var _type:int;
		private var _cycle:int = 5;
		private var _cycleStart:Number = 0;
		private var _rect:Rectangle = new Rectangle(0,0,100,100);
		private var _deep:Number = 5;
		
		private var updateCall:UniqueCall = new UniqueCall(update);
		private var updateMaskCall:UniqueCall = new UniqueCall(updateMask);
		
		public function WaveHVFilterProxy(type:int = 1)
		{
			super(new DisplacementMapFilter());
			this.type = type;
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
		 * 周期
		 * @return 
		 * 
		 */
		public function get cycle():int
		{
			return _cycle;
		}

		public function set cycle(v:int):void
		{
			_cycle = v;
			updateMaskCall.invalidate();
			updateCall.invalidate();
		}
		
		/**
		 * 周期起点
		 * @return 
		 * 
		 */
		public function get cycleStart():Number
		{
			return _cycleStart;
		}
		
		public function set cycleStart(v:Number):void
		{
			_cycleStart = v;
			updateMaskCall.invalidate();
			updateCall.invalidate();
		}

		/**
		 * 作用范围
		 * @return 
		 * 
		 */
		public function get rect():Rectangle
		{
			return _rect;
		}

		public function set rect(v:Rectangle):void
		{
			_rect = v;
			updateMaskCall.invalidate();
			updateCall.invalidate();
		}

		/**
		 * 偏移类型
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
			updateMaskCall.invalidate();
			updateCall.invalidate();
		}
		
		private function update():void
		{
			if (!mask)
				updateMask();
			
			changeFilter(createWaveFilter(mask,rect.topLeft,deep));
		}
		
		private function updateMask():void
		{
			if (mask)
				mask.dispose();
				
			mask = createWaveMask(type,rect,cycle,cycleStart);
		}
		
		public function dispose():void
		{
			if (mask)
				mask.dispose();
		}
		
		public override function destory():void
		{
			updateCall.destory();
			updateMaskCall.destory();
			super.destory();
		}
		
		/**
		 * 生成水波遮罩
		 * 
		 * @param shapeType	1.水平矩形，2.垂直矩形，3.水平矩形缩放，4.垂直矩形缩放
		 * @param rect	范围
		 * @param cycle	周期
		 * @param cycleStart	周期起点
		 * @return 
		 * 
		 */
		public static function createWaveMask(shapeType:int,rect:Rectangle,cycle:int, cycleStart:Number):BitmapData
		{
			var data:BitmapData = new BitmapData(rect.width,rect.height,false,0x808080);
			if (shapeType == 1)
			{
				for (var i:int = 0;i < rect.width;i++)
				{
					var c:uint = 0x80 + 0x7F * Math.sin((i / rect.width * cycle + cycleStart) * Math.PI * 2)
					data.fillRect(new Rectangle(i,0,1,rect.height),(0x80 << 16) | (c << 8));
				}
			}
			else if (shapeType == 2)
			{
				for (i = 0;i < rect.height;i++)
				{
					c = 0x80 + 0x7F * Math.sin((i / rect.height * cycle + cycleStart) * Math.PI * 2)
					data.fillRect(new Rectangle(0,i,rect.width,1),(c << 16) | (0x80 << 8));
				}
			}
			else if (shapeType == 3)
			{
				for (i = 0;i < rect.width;i++)
				{
					c = 0x80 + 0x7F * Math.sin((i / rect.width * cycle + cycleStart) * Math.PI * 2)
					data.fillRect(new Rectangle(i,0,1,rect.height),(c << 16) | (0x80 << 8));
				}
			}
			else if (shapeType == 4)
			{
				for (i = 0;i < rect.height;i++)
				{
					c = 0x80 + 0x7F * Math.sin((i / rect.height * cycle + cycleStart) * Math.PI * 2)
					data.fillRect(new Rectangle(0,i,rect.width,1),(0x80 << 16) | (c << 8));
				}
			}
			return data;
		}
		
		/**
		 * 同水波效果
		 * 
		 * @param bitmapData	水波遮罩，需由createWaveMask方法生成
		 * @param pos	水波左上坐标
		 * @param deep	波幅
		 * @return 
		 * 
		 */		
		public static function createWaveFilter(bitmapData:BitmapData, pos:Point,deep:Number = 9):DisplacementMapFilter
		{
			return new DisplacementMapFilter(bitmapData,pos,BitmapDataChannel.RED,BitmapDataChannel.GREEN,deep,deep,DisplacementMapFilterMode.IGNORE)
		}
	}
}