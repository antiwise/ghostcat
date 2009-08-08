package org.ghostcat.bitmap
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.util.CallLater;
	
	
	public class Trapezium extends GBitmapTransfer
	{
		public static const H:int = 0;
		
		public static const W:int = 1;
		
		private var _rotationTrape:Number = 0;
		
		private var _scaleTrape:Number = 1.5;
		
		private var _direct:int = 0;
		
		private var tempBitmapData:BitmapData;
		
		public function Trapezium(target:DisplayObject)
		{
			super(target);
		}
		
		/**
		 * 向内旋转角度
		 * 
		 * @return 
		 * 
		 */
		public function get rotationTrape():Number
		{
			return _rotationTrape;
		}

		public function set rotationTrape(v:Number):void
		{
			_rotationTrape = v;
			invalidateTrape();
		}
		
		/**
		 * 靠近视角最大的缩放比例
		 * 
		 * @return 
		 * 
		 */
		public function get scaleTrape():Number
		{
			return _scaleTrape;
		}

		public function set scaleTrape(v:Number):void
		{
			_scaleTrape = v;
			invalidateTrape();
		}

		public function get direct():int
		{
			return _direct;
		}

		public function set direct(v:int):void
		{
			_direct = v;
			invalidateTrape();
		}
		
		public override function updateTargetMove():void
		{
			var rect:Rectangle = _target.getBounds(this);
			x = rect.x + this.x - rect.width * (_scaleTrape - 1)/2;
			y = rect.y + this.y - rect.height * (_scaleTrape - 1)/2;
		}
		
		protected override function createBitmapData() : void
		{
			bitmapData && bitmapData.dispose();
			tempBitmapData && tempBitmapData.dispose();
			
			var rect: Rectangle = _target.getBounds(_target);
			if (rect.width && rect.height)
				bitmapData = new BitmapData(rect.width*_scaleTrape,rect.height*_scaleTrape,true,0);
			
			tempBitmapData = bitmapData.clone();
		}
		
		protected override function render() : void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var m:Matrix = new Matrix();
			m.translate(-rect.x + rect.width * (_scaleTrape - 1)/2, -rect.y + rect.height * (_scaleTrape - 1)/2);
			
			tempBitmapData.fillRect(bitmapData.rect,0);
			tempBitmapData.draw(_target,m);
			
			renderTrape();
		}
		
		public function invalidateTrape():void
		{
			CallLater.callLater(renderTrape,null,true);
		}
		
		private function renderTrape():void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var dx:Number = rect.width * (_scaleTrape - 1)/2;
			var dy:Number = rect.height * (_scaleTrape - 1)/2;
			bitmapData.lock();
			bitmapData.fillRect(bitmapData.rect,0);
			var i:int = 0;
			var j:int = 0;
			var c:uint;
			if (direct == 0)
			{
				for (j = 0;j < rect.height;j++)
					for (i = 0;i < rect.width;i++)
					{
						c = tempBitmapData.getPixel32(dx+i,dy+j);
						bitmapData.setPixel32(dx+i,dy+j,c);
					}
			}
			else if (direct == 1)
			{
				for (j = 0;j < rect.height;j++)
					for (i = 0;i < rect.width;i++)
					{
						c = tempBitmapData.getPixel32(dx+i,dy+j);
						bitmapData.setPixel32(dx+i,dy+j,c);
					}
			}
			bitmapData.unlock();
		}
		
		public override function destory() : void
		{
			super.destory();
			tempBitmapData.dispose();
		}
	}
}