package ghostcat.ui.validators
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.text.RegExpUtil;
	import ghostcat.ui.layout.Padding;
	
	/**
	 * 数字验证器 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GNumberValidator extends GValidator
	{
		public static var defaultExceedsMaxError:String = "数值太大";
		public static var defaultLowerThanMinError:String = "数值太小";
		public static var defaultIntegerError:String = "不是数字";
		public static var defaultPrecisionError:String = "小数位数错误";
		
		/**
		 * 最小值
		 */
		public var minValue:Number;
		
		/**
		 * 最大值
		 */
		public var maxValue:Number;
		
		/**
		 * 小数位限定
		 */
		public var precision:Number;
		
		private var _exceedsMaxError:String;
		private var _lowerThanMinError:String;
		private var _integerError:String;
		private var _precisionError:String;
		
		/**
		 * 超出上限后的提示 
		 * @return 
		 * 
		 */
		public function get exceedsMaxError():String
		{
			return _exceedsMaxError ? _exceedsMaxError : defaultExceedsMaxError;
		}

		public function set exceedsMaxError(value:String):void
		{
			_exceedsMaxError = value;
		}

		/**
		 * 超出下限的提示
		 * @return 
		 * 
		 */
		public function get lowerThanMinError():String
		{
			return _lowerThanMinError ? _lowerThanMinError : defaultLowerThanMinError;
		}

		public function set lowerThanMinError(value:String):void
		{
			_lowerThanMinError = value;
		}

		/**
		 * 非数值时的提示 
		 * @return 
		 * 
		 */
		public function get integerError():String
		{
			return _integerError ? _integerError : defaultIntegerError;
		}

		public function set integerError(value:String):void
		{
			_integerError = value;
		}

		/**
		 * 小数位错误时的提示
		 * @return 
		 * 
		 */
		public function get precisionError():String
		{
			return _precisionError ? _precisionError : defaultPrecisionError;
		}
		
		public function set precisionError(value:String):void
		{
			_precisionError = value;
		}
			

		public function GNumberValidator(skin:*=null, source:Object=null, property:String=null, minValue:Number = NaN, maxValue:Number = NaN, precision:Number= NaN, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			this.minValue = minValue;
			this.maxValue = maxValue;
			this.precision = precision;
			
			super(skin, source, property, replace, separateTextField, textPadding);
		}
		/** @inheritDoc*/
		protected override function triggerHandler(event:Event) : void
		{
			super.triggerHandler(event);
			
			var v:Number = source[property];
			if (isNaN(v))
			{
				this.data = integerError;
				return;
			}
			
			if (!isNaN(minValue) && v < minValue)
			{
				this.data = lowerThanMinError;
				return;
			}
			
			if (!isNaN(maxValue) && v > maxValue)
			{
				this.data = exceedsMaxError;
				return;
			}
			
			if (!isNaN(precision) && !RegExpUtil.isNumber(v.toString(),precision))
			{
				this.data = precisionError;
				return;
			}	
		}
	}
}