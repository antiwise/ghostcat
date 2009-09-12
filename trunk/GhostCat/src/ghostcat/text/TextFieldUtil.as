package ghostcat.text
{
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;

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
         * 文本打字效果
         * 
         * @param textField	文本框
         * @param speed	速度
         * 
         */
        public static function startTalk(textField:TextField,speed:Number = 100):void
		{
			var timer:Timer;
			var oldhtmltext:String;
			var point:int;
			timer = new Timer(speed,0);
			point = 1;
			oldhtmltext = textField.htmlText;
			textField.htmlText="";
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timercompleteHandler);
			timer.start();
		
			function timerHandler(event:TimerEvent):void
			{
				var newText:String=TextUtil.subHtmlStr(oldhtmltext,0,point);
				if (textField.htmlText==newText)
					timer.stop();
				else
				{
					textField.htmlText = newText;
					point++;
				}
				event.updateAfterEvent();
			}
			function timercompleteHandler(event:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timercompleteHandler);
			}
		}
	}
}