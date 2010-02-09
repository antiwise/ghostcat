package ghostcat.display.transfer
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	
	import ghostcat.filter.ColorMatrixFilterProxy;
	

	public class Bloom extends GBitmapTransfer
	{
		private var _blur:int = 30;

		public function get blur():int
		{
			return _blur;
		}

		public function set blur(value:int):void
		{
			_blur = value;
			updateFilter();
		}

		private var _contrast:Number = 2.5;

		public function get contrast():Number
		{
			return _contrast;
		}

		public function set contrast(value:Number):void
		{
			_contrast = value;
			updateFilter();
		}

		public function Bloom(target:DisplayObject=null,blur:int = 30,contrast:Number = 2.5,alpha:Number = 0.5)
		{
			super(target);
			
			this.blendMode = BlendMode.ADD;
			
			this.blur = blur;
			this.contrast = contrast;
			this.alpha = alpha;
		}
		
		public override function renderTarget() : void
		{
			super.renderTarget();
			updateFilter();
		}
		
		public function updateFilter():void
		{
			this.filters = [new BlurFilter(blur,blur),ColorMatrixFilterProxy.createSaturationFilter(0),ColorMatrixFilterProxy.createContrastFilter(contrast)]
		}
	}
}