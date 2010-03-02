package ghostcat.ui.validators
{
	import flash.events.Event;
	
	import ghostcat.ui.layout.Padding;
	
	/**
	 * 正则数据验证器 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GRegexpValidator extends GValidator
	{
		public static var defaultNoMatchError:String = "数据格式不符合要求";
		
		/**
		 * 正则表达式
		 */
		public var expression:RegExp;
		
		private var _noMatchError:String;

		/**
		 * 不符合时的提示信息
		 */
		public function get noMatchError():String
		{
			return _noMatchError ? _noMatchError : defaultNoMatchError;
		}

		public function set noMatchError(value:String):void
		{
			_noMatchError = value;
		}

		
		public function GRegexpValidator(skin:*=null, source:Object=null, property:String=null, expression:RegExp = null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			this.expression = expression;
			super(skin, source, property, replace, separateTextField, textPadding);
		}
		/** @inheritDoc*/
		protected override function triggerHandler(event:Event) : void
		{
			super.triggerHandler(event);
			
			var v:* = source[property];
			if (expression && !expression.test(v))
				this.data = noMatchError;
		}
	}
}