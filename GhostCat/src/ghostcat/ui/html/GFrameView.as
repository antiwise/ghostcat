package ghostcat.ui.html
{
	import ghostcat.ui.containers.GView;
	
	/**
	 * 拥有边框和背景的视图
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GFrameView extends GView
	{
		private var _backgroundColor:Number = NaN;
		private var _border:int = 1;
		private var _borderColor:uint = 0x0;
		
		public function GFrameView(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
		}

		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			invalidateDisplayList();
		}

		public function get border():int
		{
			return _border;
		}

		public function set border(value:int):void
		{
			_border = value;
			invalidateDisplayList();
		}

		public function get borderColor():uint
		{
			return _borderColor;
		}

		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			invalidateDisplayList();
		}

		protected override function updateDisplayList() : void
		{
			super.updateDisplayList();
			
			graphics.clear();
			if (border > 0)
				graphics.lineStyle(border,borderColor);
			
			if (backgroundColor)
				graphics.beginFill(backgroundColor);
			
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
	}
}