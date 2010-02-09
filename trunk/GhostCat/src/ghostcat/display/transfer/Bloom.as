package ghostcat.display.transfer
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	
	import ghostcat.filter.ColorMatrixFilterProxy;
	

	/**
	 * 曝光效果
	 * @author flashyiyi
	 * 
	 */
	public class Bloom extends GBitmapTransfer
	{
		private var _blur:int;

		public function get blur():int
		{
			return _blur;
		}

		public function set blur(value:int):void
		{
			_blur = value;
			updateFilter();
		}

		private var _brightness:Number;

		public function get brightness():Number
		{
			return _brightness;
		}

		public function set brightness(value:Number):void
		{
			_brightness = value;
			updateFilter();
		}
		
		private var _contrast:Number;
		
		public function get contrast():Number
		{
			return _contrast;
		}
		
		public function set contrast(value:Number):void
		{
			_contrast = value;
			updateFilter();
		}

		public function Bloom(target:DisplayObject=null,alpha:Number = 1.0,blur:int = 8,brightness:int = -100, contrast:Number = 100)
		{
			super(target);
			
			this.blendMode = BlendMode.ADD;
			
			this.blur = blur;
			this.contrast = contrast;
			this.brightness = brightness;
			this.alpha = alpha;
		}
		
		public override function renderTarget() : void
		{
			super.renderTarget();
			updateFilter();
		}
		
		public function updateFilter():void
		{
			this.filters = [
				ColorMatrixFilterProxy.createBrightnessFilter(brightness),
				ColorMatrixFilterProxy.createContrastFilter(contrast),
				new BlurFilter(blur,blur),
				ColorMatrixFilterProxy.createSaturationFilter(0)
			]
		}
	}
}