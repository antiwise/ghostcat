package ghostcat.text
{
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	
	import ghostcat.util.RandomUtil;
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
		 * 将TextField按字打散到一个容器内
		 *  
		 * @param textField
		 * @param cotainer
		 * 
		 */
		public static function separate(textField:TextField,cotainer:DisplayObjectContainer = null):void
		{
			if (!cotainer)
				cotainer = textField.parent;
			
			
		}
        
        /**
         * 文本打字效果
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