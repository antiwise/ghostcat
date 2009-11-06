package ghostcat.text
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * 密码相关
	 *  
	 * @author flashyiyi
	 * 
	 */
	public final class PassWordUtil
	{
		/**
		 * 计算密码强度 
		 * @param pw
		 * @return 
		 * 
		 */
		public static function evaluatePwd(pw:String):int
		{ 
			return pw.replace(/^(?:([a-z])|([A-Z])|([0-9])|(.)){5,}|(.)+$/g,"$1$2$3$4$5").length;
		}
		
		/**
		 * 设置密码框 
		 * @param textField
		 * 
		 */
		public static function setPWTextField(textField:TextField):void
		{
			textField.displayAsPassword = true;
			textField.type = TextFieldType.INPUT;
			textField.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler,false,0,true);
			
			function keyUpHandler(event:Event):void
			{
				System.setClipboard("");
			}
		}
	}
}