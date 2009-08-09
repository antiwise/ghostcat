package org.ghostcat.filter
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	import org.ghostcat.debug.Debug;
	import org.ghostcat.util.CallLater;
	
	public class TrapeziumFilterProxy extends FilterProxy
	{
		public static const H:int = 0;
		public static const V:int = 1;
		
		private var _type:int = 0;
		private var _rotation:Number = 0;
		private var _maxScale:Number = 0.5;
		
		public var mask:BitmapData;
		public function TrapeziumFilterProxy(type:int)
		{
			super(new DisplacementMapFilter());
			this.type = type;
		}
		
		public function get maxScale():Number
		{
			return _maxScale;
		}

		public function set maxScale(v:Number):void
		{
			_maxScale = v;
			CallLater.callLater(update,null,true);
		}

		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(v:Number):void
		{
			_rotation = v;
			CallLater.callLater(update,null,true);
		}

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
					changeFilter(createHFilter(mask,rotation,maxScale));
					break;
				case V:
					changeFilter(createVFilter(mask,rotation,maxScale));
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
			
			if (!owner)
				return;
				
			switch (type)
			{
				case H:
					mask = createMask(owner.width,owner.height);
					break;
				case V:
					mask = createMask(owner.width,owner.height);
					break;
				default:
					Debug.error("不允许的取值")
					break;
			}
		}
		
		
		public static function createMask(width:Number,height:Number):BitmapData
		{
			var data:BitmapData = new BitmapData(width,height);
			return data;
		}
		
		public static function createHFilter(bitmapData:BitmapData, rotation:Number, maxScale:Number):DisplacementMapFilter
		{
			var deep:Number = bitmapData.width * maxScale * Math.sin(rotation / 180 * Math.PI);
			return new DisplacementMapFilter(bitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,deep,deep)
		}
		
		public static function createVFilter(bitmapData:BitmapData, rotation:Number, maxScale:Number):DisplacementMapFilter
		{
			var deep:Number = bitmapData.height * maxScale * Math.sin(rotation / 180 * Math.PI);
			return new DisplacementMapFilter(bitmapData,new Point(),BitmapDataChannel.GREEN,BitmapDataChannel.RED,deep,deep)
		}
	}
}