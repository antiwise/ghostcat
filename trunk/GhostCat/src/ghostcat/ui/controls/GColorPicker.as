package ghostcat.ui.controls
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.ColorUtil;
	import ghostcat.util.display.PaletteUtil;
	
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
		private var _selectedColor:Number;
		
		public function GColorPicker(skin:*=null, replace:Boolean=true)
		{
			if (!skin)
				skin = PaletteBitmap;
			
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
			return ColorUtil.getColorAtPoint(content,mouseX,mouseY);
		}
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
			super.destory();
		}
	}
}
import flash.display.Bitmap;

import ghostcat.util.display.PaletteUtil;

class PaletteBitmap extends Bitmap
{
	public function PaletteBitmap():void
	{
		bitmapData = PaletteUtil.getColorPaletter();
	}
}