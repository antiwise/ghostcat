package ghostcat.filter
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.MathUtil;
	import ghostcat.util.core.UniqueCall;
	
	/**
	 * 梯形翻转滤镜
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TrapeziumFilterProxy extends FilterProxy
	{
		public static const H:int = 0;
		public static const V:int = 1;
		
		private var _type:int = 0;
		private var _rotation:Number = 0;
		
		public var mask:BitmapData;
		
		private var updateCall:UniqueCall = new UniqueCall(update);
		private var updateMaskCall:UniqueCall = new UniqueCall(updateMask);
		
		public function TrapeziumFilterProxy(type:int)
		{
			super(new DisplacementMapFilter());
			this.type = type;
		}
		
		/**
		 * 旋转角度 
		 * @return 
		 * 
		 */
		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(v:Number):void
		{
			_rotation = v;
			updateCall.invalidate();
		}

		/**
		 * 类型
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

		public override function applyFilter(target:*) : void
		{
			super.applyFilter(target);
			update();
		}
		
		public function update():void
		{
			if (!mask)
				updateMask();
				
			switch (type)
			{
				case H:
					changeFilter(createHFilter(mask,rotation));
					break;
				case V:
					changeFilter(createVFilter(mask,rotation));
					break;
				default:
					Debug.error("不允许的取值")
					break;
			}
		}
		
		private function updateMask():void
		{
			if (mask)
				mask.dispose();
			
			if (!owner)
				return;
				
			switch (type)
			{
				case H:
					mask = createHMask(owner.width,owner.height);
					break;
				case V:
					mask = createVMask(owner.width,owner.height);
					break;
				default:
					Debug.error("不允许的取值")
					break;
			}
		}
		
		
		public static function createHMask(width:Number,height:Number):BitmapData
		{
			var w:Number = Math.ceil(width);
			var h:Number = Math.ceil(height);
			var data:BitmapData = new BitmapData(w * 2,h * 2,false);
			var hw:Number = w/2;
			var hh:Number = h/2;
			var dc:Number = 0x80 / hw / hh;
			for (var i:int = 0;i < w * 2;i++)
			{
				for (var j:int = 0;j < h * 2;j++)
				{
					var g:int = MathUtil.limitIn(0x80 - (hw - (i - hw)) * (hh - (j - hh)) * dc, 0, 0xFF);
					var r:int = MathUtil.limitIn(0xFF * (i - hw) / w, 0, 0xFF);
					data.setPixel(i,j,r << 16 | g << 8);
				}
			}
			
			return data;
		}
		
		public static function createVMask(width:Number,height:Number):BitmapData
		{
			var w:Number = Math.ceil(width);
			var h:Number = Math.ceil(height);
			var data:BitmapData = new BitmapData(w * 2,h * 2,false);
			var hw:Number = w/2;
			var hh:Number = h/2;
			var dc:Number = 0x80 / hw / hh;
			for (var i:int = 0;i < w * 2;i++)
			{
				for (var j:int = 0;j < h * 2;j++)
				{
					var g:int = MathUtil.limitIn(0x80 - (hw - (i - hw)) * (hh - (j - hh)) * dc, 0, 0xFF);
					var r:int = MathUtil.limitIn(0xFF * (j - hh) / h, 0, 0xFF);
					data.setPixel(i,j,r << 16 | g << 8);
				}
			}
			
			return data;
		}
		
		public static function createHFilter(bitmapData:BitmapData, rotation:Number):DisplacementMapFilter
		{
			var dx:Number = Math.min(2500,Math.abs(bitmapData.width * Math.tan(rotation / 180 * Math.PI)));
			var dy:Number = bitmapData.height * Math.sin(rotation / 180 * Math.PI);
			var p:Point = new Point(-bitmapData.width/4,-bitmapData.height/4);
			return new DisplacementMapFilter(bitmapData,p,BitmapDataChannel.RED,BitmapDataChannel.GREEN,dx,dy,DisplacementMapFilterMode.COLOR)
		}
		
		public static function createVFilter(bitmapData:BitmapData, rotation:Number):DisplacementMapFilter
		{
			var dx:Number = bitmapData.width * Math.sin(rotation / 180 * Math.PI);
			var dy:Number = Math.min(2500,Math.abs(bitmapData.height * Math.tan(rotation / 180 * Math.PI)));
			var p:Point = new Point(-bitmapData.width/4,-bitmapData.height/4);
			return new DisplacementMapFilter(bitmapData,p,BitmapDataChannel.GREEN,BitmapDataChannel.RED,dx,dy,DisplacementMapFilterMode.COLOR)
		}
	}
}