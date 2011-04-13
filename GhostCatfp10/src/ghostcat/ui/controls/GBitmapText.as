package ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.geom.Rectangle;
	
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.display.BitmapCharUtil;
	
	/**
	 * 位图字体，可以设置一个位图作为字体，可以对单字使用filter
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapText extends GText
	{
		/**
		 * 未添加滤镜的原始BitmapData
		 */
		protected var normalBitmapData:BitmapData;
		
		/**
		 * 用作字体的BitmapData 
		 */
		public var fontBitmapData:BitmapData;
		
		private var _fontCharRange:String;
		private var execfontCharRange:String;
		
		/**
		 * 字体表示的文本范围（0-9,a,U+80FF）
		 */
		public function get fontCharRange():String
		{
			return _fontCharRange;
		}
		
		public function set fontCharRange(value:String):void
		{
			_fontCharRange = value;
			execfontCharRange = BitmapCharUtil.execCharRange(_fontCharRange);
		}
		
		public function GBitmapText(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, replace, separateTextField, textPadding);
			this.asTextBitmap = true;
		}

		/**
		 * 设置图形字体 
		 * 
		 * @param font	字体位图
		 * @param charRange	包含的字符集（0-9,a,U+80FF）
		 * 
		 */
		public function setFontBitmapData(font:BitmapData,charRange:String = "0-9"):void
		{
			this.fontBitmapData = font;
			this.fontCharRange = charRange;
		}
		
		/** @inheritDoc*/
		public override function reRenderTextBitmap() : void
		{
			if (fontBitmapData)
			{
				if (textBitmap)
				{
					textBitmap.parent.removeChild(textBitmap);
					textBitmap.bitmapData.dispose();
				}
				
				textBitmap = new Bitmap(BitmapCharUtil.create(textField.text,fontBitmapData,execfontCharRange));
				textBitmap.x = textField.x;
				textBitmap.y = textField.y;
				textField.parent.addChild(textBitmap);
			}
			else
			{
				super.reRenderTextBitmap();
			}
			
			if (normalBitmapData)
				normalBitmapData.dispose();
			
			normalBitmapData = textBitmap.bitmapData.clone();
		}
		
		/**
		 * 应用滤镜
		 * 
		 * @param filter
		 * @param startIndex
		 * @param endIndex
		 * 
		 */
		public function applyFilter(filter:BitmapFilter,startIndex:int,endIndex:int):void
		{
			for (var i:int = startIndex; i < endIndex; i++)
			{
				var rect:Rectangle = this.getCharBoundaries(i);
				textBitmap.bitmapData.applyFilter(normalBitmapData,rect,rect.topLeft,filter);
			}
		}
		
		/**
		 * 设置背景色
		 * 
		 * @param color
		 * @param startIndex
		 * @param endIndex
		 * 
		 */
		public function setBackgroundColor(color:uint,startIndex:int,endIndex:int):void
		{
			for (var i:int = startIndex; i < endIndex; i++)
			{
				var rect:Rectangle = this.getCharBoundaries(i);
				textBitmap.bitmapData.fillRect(rect,color);
				textBitmap.bitmapData.copyPixels(normalBitmapData,rect,rect.topLeft,null,null,true);
			}
		}
		
		/**
		 * 获得某个文本的显示区域
		 * @param i
		 * 
		 */
		public function getCharBoundaries(charIndex:int):Rectangle
		{
			if (fontBitmapData)
			{
				var w:int = fontBitmapData.width / execfontCharRange.length;
				return new Rectangle(w * charIndex,0,w,fontBitmapData.height);
			}
			else
			{
				return textField.getCharBoundaries(charIndex);
			}
		}
		
		/** @inheritDoc*/
		override public function getTextFieldSize():Rectangle
		{
			if (fontBitmapData)
			{
				return new Rectangle(textBitmap.x,textBitmap.y,textBitmap.width,textBitmap.height);
			}
			else
			{
				return super.getTextFieldSize();
			}
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (normalBitmapData)
				normalBitmapData.dispose();
			
			super.destory();
		}
	}
}