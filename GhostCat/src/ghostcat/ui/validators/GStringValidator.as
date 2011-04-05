package ghostcat.ui.validators
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.util.text.TextUtil;
	import ghostcat.ui.layout.Padding;
	
	/**
	 * 字符串验证器 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GStringValidator extends GValidator
	{
		public static var defaultTooLongError:String = "字符串长度太长";
		public static var defaultTooShortError:String = "字符串长度太短";
		
		/**
		 * 最小值
		 */
		public var minLength:Number;
		
		/**
		 * 最大值
		 */
		public var maxLength:Number;
		
		/**
		 * 中文是否按两个字符处理
		 */
		public var isANSI:Boolean = false;
		
		private var _tooLongError:String;
		private var _tooShortError:String;

		/**
		 * 长度太长的提示信息
		 */
		public function get tooLongError():String
		{
			return _tooLongError ? _tooLongError : defaultTooLongError;
		}

		public function set tooLongError(value:String):void
		{
			_tooLongError = value;
		}
		
		/**
		 * 长度太短时的提示信息
		 */
		public function get tooShortError():String
		{
			return _tooShortError ? _tooShortError :  defaultTooShortError;
		}
		
		public function set tooShortError(value:String):void
		{
			_tooShortError = value;
		}

		
		public function GStringValidator(skin:*=null, source:Object=null, property:String=null, minLength:Number = NaN, maxLength:Number = NaN, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			this.minLength = minLength;
			this.maxLength = maxLength;
			
			super(skin, source, property, replace, separateTextField, textPadding);
		}
		/** @inheritDoc*/
		protected override function triggerHandler(event:Event) : void
		{
			super.triggerHandler(event);
			
			var len:int = isANSI ? TextUtil.getANSILength(data) : data.toString().length;
			
			var v:* = source[property];
			if (!isNaN(minLength) && len < minLength)
			{
				this.data = tooShortError;
				return;
			}
			if (!isNaN(maxLength) && len > maxLength)
			{
				this.data = tooLongError;
				return;
			}
		}
	}
}