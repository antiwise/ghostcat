package ghostcat.ui.controls
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.text.TextFieldUtil;
	import ghostcat.util.easing.TweenUtil;
	import ghostcat.util.easing.Circ;
	
	/**
	 * 数值显示
	 * 
	 * 标签规则：和文本框相同
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GNumberic extends GText
	{
		/**
		 * 缓动时间
		 */
		public var duration:int=1000;
		
		/**
		 * 附加在数字前的文字
		 * @return 
		 * 
		 */
		public var prefix:String = "";
		
		/**
		 * 附加在数字后的文字
		 * @return 
		 * 
		 */
		public var suffix:String = "";
		
		/**
		 * 缓动函数
		 */
		public var easing:Function = Circ.easeOut;
		
		/**
		 * 小数点位数
		 */
		public var fix:int = 0;
		
		public function GNumberic(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPos:Point=null)
		{
			super(skin, replace, separateTextField, textPos);
		}
		
		/**
		 * 设置数值
		 * 
		 * @param v
		 * @param tween	是否缓动
		 * 
		 */
		public function setValue(v : Number, tween:Boolean = true):void
		{
			v = Number(v);
//			if (_data && v == data)
//				return;
				
			_data = v;
			
			if (!_data || !tween)
				displayValue = v;
			else
			{
				TweenUtil.removeTween(this);
				TweenUtil.to(this,duration,{displayValue:v,ease:easing})
			}
		
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 获得数据
		 * 
		 * @return 
		 * 
		 */
		public function getValue():*
		{
			return data;
		}
		/** @inheritDoc*/
		public override function set data(v : *):void
		{
			setValue(v);
		}
		
		public override function get data():*
		{
			return Number(_data);
		}
		
		private var _displayValue:Number;
		/** @inheritDoc*/
		public function get displayValue():Number
		{
			return _displayValue;
		}
		
		public function set displayValue(v:Number):void
		{
			_displayValue = v;
			
			if (textField)
				textField.text = prefix + v.toFixed(fix) + suffix;
			
//			if (enabledAdjustTextSize)
//				TextFieldUtil.adjustSize(textField);
			
			if (enabledAdjustContextSize)
				adjustContextSize();
			
			if (asBitmap)
				reRenderBitmap();
		}
		
	}
}