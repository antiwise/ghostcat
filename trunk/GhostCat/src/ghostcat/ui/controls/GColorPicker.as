package ghostcat.ui.controls
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.Palette;
	
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * 取色器
	 * 
	 * 会以点击的皮肤的颜色作为实际的颜色
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GColorPicker extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(Palette);
		private var bitmap:BitmapData;
		private var _selectedColor:Number;
		
		public function GColorPicker(skin:*=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin;
			
			super(skin, replace);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		public function get selectedColor():uint
		{
			return _selectedColor;
		}

		public function set selectedColor(value:uint):void
		{
			if (_selectedColor == value)
				return;
			
			_selectedColor = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}

		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			bitmap = new BitmapData(content.width,content.height);
			bitmap.draw(content);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			selectedColor = getColorOnMouse();
		}
		
		/**
		 * 取得鼠标下的颜色 
		 * @return 
		 * 
		 */
		public function getColorOnMouse():uint
		{
			return bitmap.getPixel(mouseX,mouseY);
		}
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (bitmap)
				bitmap.dispose();
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
			super.destory();
		}
	}
}