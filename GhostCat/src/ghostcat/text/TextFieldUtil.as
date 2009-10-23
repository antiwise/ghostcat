package ghostcat.text
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.RandomUtil;
	import ghostcat.util.display.MatrixUtil;
	import ghostcat.util.easing.TweenUtil;

	/**
	 * 文本框处理类 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class TextFieldUtil
	{
		static public const TEXT_WIDTH_PADDING:int = 5;
	    static public const TEXT_HEIGHT_PADDING:int = 4;

		/**
		 * 调整TextField的大小以显示全部文字
		 * 
		 */
		public static function adjustSize(textField:TextField,maxWidth:Number=1000,maxHeight:Number=1000):void
		{
			textField.width = maxWidth;
			textField.height = maxHeight;
			
            textField.width = Math.ceil(textField.textWidth) + TEXT_WIDTH_PADDING;
            textField.height = Math.ceil(textField.textHeight) + TEXT_HEIGHT_PADDING;
		}
		
		/**
         * 缩短文字以符合TextField的大小
         * 
         * @param textField	文本框
         * @return 
         * 
         */        
        public static function truncateToFit(textField:TextField):*
        {
            if (textField.text == null || textField.text.length < 1)
                return;
            
            var firstLine:TextLineMetrics = textField.getLineMetrics(0);
            var charBound:Rectangle = textField.getCharBoundaries(0);
            
            if (firstLine.x + charBound.width > textField.width) 
            {
                var i:int = (textField.text.charAt(textField.text.length - 5) != " ") ? 4 : 5;
                textField.text = textField.text.slice(0, textField.length - i);
                textField.text = textField.text.concat("...");
            }
        }
		
		/**
		 * 从索引处截取一个字
		 * 
		 * @param textField
		 * @param index
		 * @return 
		 * 
		 */
		public static function getTextFieldAtIndex(textField:TextField,index:int):TextField
		{
			var t:TextField = new TextField();
			t.selectable = false;
			t.embedFonts = textField.embedFonts;
			t.text = textField.text.charAt(index);
			t.setTextFormat(textField.getTextFormat(index,index+1),0,1);
			var rect:Rectangle = textField.getCharBoundaries(index);
			var tRect:Rectangle = t.getCharBoundaries(0);
			if (rect && tRect)
			{
				t.x = rect.x - tRect.x;
				t.y = rect.y - tRect.y;
			}
			return t;
		}
		
		/**
		 * 将TextField按字打散到一个容器内
		 *  
		 * @param textField
		 * @param cotainer
		 * @param bitmap	是否转换为位图
		 */
		public static function separate(textField:TextField,cotainer:DisplayObjectContainer = null,bitmap:Boolean = false):Array
		{
			if (!cotainer)
				cotainer = textField.parent;
				
			var m:Matrix = MatrixUtil.getMatrixAt(textField,cotainer);
			var result:Array = [];
			
			for (var i:int = 0;i < textField.text.length;i++)
			{
				var t:TextField = getTextFieldAtIndex(textField,i);
				t.transform.matrix = MatrixUtil.concat(m,t.transform.matrix);
				
				if (bitmap)
				{
					var b:Bitmap = DrawParse.createBitmap(t);
					cotainer.addChild(b);
					result.push(b);
				}
				else
				{
					cotainer.addChild(t);
					result.push(t);
				}
			}
			
			return result;
		}
        
        /**
         * 文本缓动
         * 
         * @param textField	文本框
         * @param speed	速度
         * @param ease	缓动方法
		 * @param invent	是否倒放
		 * @param addRandomText	是否在缓动的时候增加随机尾字符
         */
        public static function tween(textField:TextField,speed:Number = 100,ease:Function = null,invert:Boolean = false,addRandomText:Boolean = false):void
		{
			var oldText:String = textField.htmlText;
			var data:Object = {len : 0};
			
			var length:int = textField.text.length;
			
			TweenUtil.to(data, speed * length,{len: length,ease: ease, invert: invert,onUpdate: updateHandler,onComplete:completeHandler}).update();
		
			function updateHandler():void
			{
				if (addRandomText)
					textField.htmlText = TextUtil.subHtmlStr(oldText,0,data.len - 1) + RandomUtil.string(1);
				else
					textField.htmlText = TextUtil.subHtmlStr(oldText,0,data.len)
			}
			
			function completeHandler():void
			{
				textField.htmlText = invert ? "" : oldText;
			}
		}
	}
}