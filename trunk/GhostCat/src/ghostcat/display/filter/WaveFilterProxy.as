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
	public dynamic class WaveFilterProxy extends FilterProxy
	{
		/**
		 * 同心波纹
		 */
		public static const WAVE:int = 0;
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
		private var _deep:Number = 9;
		
		private var updateCall:UniqueCall = new UniqueCall(update);
		private var updateMaskCall:UniqueCall = new UniqueCall(updateMask);
		
		public function WaveFilterProxy(type:int)
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
		
		/**
		 * 生成水波遮罩
		 * 
		 * @param shapeType	0.圆形，1.水平矩形，2.垂直矩形
		 * @param rect	范围
		 * @param cycle	周期
		 * @param cycleStart	周期起点
		 * @return 
		 * 
		 */
		public static function createWaveMask(shapeType:int,rect:Rectangle,cycle:int, cycleStart:Number):BitmapData
		{
			var shape:Shape = new Shape();
			var colors:Array = [];
			var alphas:Array = [];
			var ratios:Array = [];
			
			colors.push(0x808080);
			alphas.push(1.0);
			ratios.push(0);
			for (var i:int = 0;i < cycle;i++)
			{
				var step1:Number = 255 / cycle * (i + cycleStart);
				if (step1 >= 0 && step1 <= 255)
				{
					colors.push(0x0);
					alphas.push(1.0);
					ratios.push(step1);
				}
				var step2:Number = step1 + 255/cycle * 0.5;
				if (step2 >= 0 && step2 <= 255)
				{
					colors.push(0xFFFFFF);
					alphas.push(1.0);
					ratios.push(step2);
				}
			}
			colors.push(0x808080);
			alphas.push(1.0);
			ratios.push(255);
			
			var m:Matrix = new Matrix();
			m.createGradientBox(rect.width,rect.height);
			if (shapeType == 0)
			{
				shape.graphics.beginGradientFill(GradientType.RADIAL,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawEllipse(0,0,rect.width,rect.height);
			}
			else if (shapeType == 1)
			{
				shape.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawRect(0,0,rect.width,rect.height); 
			}
			else if (shapeType == 2)
			{
				m.rotate(90);
				shape.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawRect(0,0,rect.width,rect.height); 
			}
			var data:BitmapData = new BitmapData(rect.width,rect.height,false,0x808080);
			data.draw(shape);
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
			return new DisplacementMapFilter(bitmapData,pos,BitmapDataChannel.RED,BitmapDataChannel.GREEN,deep,deep)
		}
	}
}