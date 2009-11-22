package ghostcat.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import ghostcat.util.RandomUtil;
	import ghostcat.util.easing.TweenUtil;

	/**
	 * 文本缓动 
	 * @author flashyiyi
	 * 
	 */
	public final class TextTweenUtil
	{
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
			var oldText:String = textField.text;
			var data:Object = {len : 0};
			
			var length:int = textField.text.length;
			
			TweenUtil.to(data, speed * length,{len: length,ease: ease, invert: invert,onUpdate: updateHandler,onComplete:completeHandler}).update();
			
			function updateHandler():void
			{
				if (addRandomText)
					textField.text = oldText.substr(0,data.len - 1) + RandomUtil.string(1);
				else
					textField.text = oldText.substr(0,data.len)
			}
			
			function completeHandler():void
			{
				textField.text = invert ? "" : oldText;
			}
		}
		
		/**
		 * HTML文本缓动
		 * 
		 * @param textField	文本框
		 * @param speed	速度
		 * @param ease	缓动方法
		 * @param invent	是否倒放
		 * @param addRandomText	是否在缓动的时候增加随机尾字符
		 */
		public static function tweenHtml(textField:TextField,speed:Number = 100,ease:Function = null,invert:Boolean = false,addRandomText:Boolean = false):void
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
		
		/**
		 * 高性能HTML文本缓动，不支持倒放
		 * 
		 * @param textField	文本框
		 * @param speed	速度
		 * @param ease	缓动方法
		 */
		public static function tweenQuick(textField:TextField,speed:Number = 100,ease:Function = null):void
		{
			var oldText:TextField = new TextField();
			oldText.htmlText = textField.htmlText;
			
			var length:int = oldText.text.length;
			var data:Object = {len : 0};
			textField.text = "";
			
			TweenUtil.to(data, speed * length,{len: length,ease: ease, onUpdate: updateHandler,onComplete:completeHandler}).update();
			
			function updateHandler():void
			{
				var oldLen:int = textField.text.length;
				var newLen:int = data.len;
				var a:String = oldText.text.substring(oldLen,newLen);
				if (a.length > 0)
				{
					textField.appendText(a);
					textField.setTextFormat(oldText.getTextFormat(oldLen,newLen),oldLen,newLen);
				}
			}
			
			function completeHandler():void
			{
				textField.htmlText = oldText.htmlText;
			}
		}
	}
}