package org.ghostcat.filter
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
	
	import org.ghostcat.util.CallLater;
	import org.ghostcat.debug.Debug;

	/**
	 * 偏移滤镜
	 * 
	 * @author flashyiyi
	 * 
	 */
	public dynamic class DisplacementMapFilterProxy extends FilterProxy
	{
		/**
		 * 水泡 
		 */
		public static const BUBBLE:int = 0;
		/**
		 * 同心波纹
		 */
		public static const WAVE:int = 1;
		/**
		 * 横向波纹 
		 */
		public static const HWAVE:int = 2;
		/**
		 * 纵向波纹
		 */
		public static const VWAVE:int = 3;
		
		public var mask:BitmapData;
		
		private var _type:int;
		
		public function DisplacementMapFilterProxy(type:int)
		{
			super(new DisplacementMapFilter());
			this.type = type;
		}
		
		/**
		 * 偏移数量 
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
			CallLater.callLater(update,null,true);
		}

		/**
		 * 偏移起点
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
			CallLater.callLater(update,null,true);
		}

		/**
		 * 波纹重复次数
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
			CallLater.callLater(updateMask,null,true);
			CallLater.callLater(update,null,true);
		}

		/**
		 * 偏移范围半径
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
			CallLater.callLater(updateMask,null,true);
			CallLater.callLater(update,null,true);
			
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
			CallLater.callLater(updateMask,null,true);
			CallLater.callLater(update,null,true);
		}
		
		private var _radius:Number = 128;
		
		private var _cycle:int = 5;
		
		private var _pos:Point;
		
		private var _deep:Number = NaN;
		
		private function update():void
		{
			if (!mask)
				updateMask();
			switch (type)
			{
				case BUBBLE:
					if (isNaN(deep))
						deep = -128;
					changeFilter(createBubbleFilter(mask,pos,deep));
					break;
				case WAVE:
				case HWAVE:
					if (isNaN(deep))
						deep = 9;
					changeFilter(createWaveFilter(mask,pos,deep));
					break;
				default:
					Debug.error("不允许的取值");
					break;
			}
		}
		
		private function updateMask():void
		{
			if (mask)
				mask.dispose();
				
			switch (type)
			{
				case BUBBLE:
					mask = createBubbleMask(radius);
					break;
				case WAVE:
					mask = createWaveMask(radius,cycle,0);
					break;
				case HWAVE:
					mask = createWaveMask(radius,cycle,1);
					break;
				case VWAVE:
					mask = createWaveMask(radius,cycle,2);
					break;
				default:
					Debug.error("不允许的取值")
					break;
			}
		}
		
		/**
		 * 以红绿通道生成渐进变化的色圆。
		 * 
		 * @return 
		 * 
		 */
		public static function createBubbleMask(radius:Number = 128):BitmapData
		{
			var data:BitmapData = new BitmapData(radius*2,radius*2,false);
			for (var x:int = -radius; x<radius; x++)
			{
				for (var y:int = -radius; y<radius; y++) 
				{
					var i:Number = x/radius*128;//数据规整到256方便运算
					var j:Number = y/radius*128;
					var l:Number = new Point(i,j).length;
					var color:uint;
					if (l<=128)
					{
						if (l>100)//在圆外圈
						{
							color = int(i*Math.sqrt(128*128-l*l)/80+128)<<16;
							color += int(j*Math.sqrt(128*128-l*l)/80+128)<<8;
							color += int(Math.sqrt(128*128-l*l)*0.7*Math.sqrt(128*128-l*l)/80);
							color += 128;
						}
						else //原的内部
							color = ((i+128)<<16)+((j+128)<<8)+int(Math.sqrt(128*128-l*l)*0.7)+128;
					}
					else
						color = 0x808080;//中性灰
					
					data.setPixel(x+radius,y+radius,color);
				}
			}
			return data;
		}
		
		/**
		 * 生成水波遮罩
		 * 
		 * @param radius	半径
		 * @param cycle		周期数
		 * @param shapeType	0.圆形，1.水平矩形，2.垂直矩形
		 * @return 
		 * 
		 */
		public static function createWaveMask(radius:Number = 128,cycle:int = 5, shapeType:int = 0):BitmapData
		{
			var shape:Shape = new Shape();
			var colors:Array = [];
			var alphas:Array = [];
			var ratios:Array = [];
			
			for (var i:int = 0;i< cycle;i++)
			{
				colors.push(0x0,0xFFFFFF);
				alphas.push(1.0,1.0);
				var step:Number = 255/cycle * i;
				ratios.push(step,step + 255/cycle/2);
			}
			colors.push(0x808080);
			alphas.push(1.0);
			ratios.push(255);
			
			var m:Matrix = new Matrix();
			m.createGradientBox(radius + radius,radius + radius);
			if (shapeType == 0)
			{
				shape.graphics.beginGradientFill(GradientType.RADIAL,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawCircle(radius,radius,radius);
			}
			else if (shapeType == 1)
			{
				shape.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawRect(0,0,radius + radius,radius + radius); 
			}
			else if (shapeType == 2)
			{
				m.rotate(90);
				shape.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawRect(0,0,radius + radius,radius + radius); 
			}
			var data:BitmapData = new BitmapData(radius + radius,radius + radius,false,0x808080);
			data.draw(shape);
			return data;
		}
		
		/**
		 * 放大镜（水泡）效果
		 * 
		 * @param bitmapData	水泡遮罩，需由createBubbleMask方法生成
		 * @param pos	水泡中心坐标
		 * @param deep	凹进的幅度（负值为凸出）
		 * @return 
		 * 
		 */		
		public static function createBubbleFilter(bitmapData:BitmapData, pos:Point=null,deep:Number = -128):DisplacementMapFilter
		{
			if (!pos)
				pos = new Point()
			return new DisplacementMapFilter(bitmapData,pos,BitmapDataChannel.RED,BitmapDataChannel.GREEN,deep,deep)
		}
		
		/**
		 * 同心水波效果
		 * 
		 * @param bitmapData	水波遮罩，需由createWaveMash方法生成
		 * @param pos	水波中心坐标
		 * @param deep	波幅
		 * @return 
		 * 
		 */		
		public static function createWaveFilter(bitmapData:BitmapData, pos:Point=null,deep:Number = 9):DisplacementMapFilter
		{
			if (!pos)
				pos = new Point()
			return new DisplacementMapFilter(bitmapData,pos,BitmapDataChannel.RED,BitmapDataChannel.GREEN,deep,deep)
		}
	}
}