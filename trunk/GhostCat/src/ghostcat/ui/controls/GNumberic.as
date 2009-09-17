package ghostcat.ui.controls
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.text.TextFieldUtil;
	import ghostcat.util.TweenUtil;
	import ghostcat.util.easing.Circ;
	
	/**
	 * 数值显示
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
		
		public function setValue(v : Number, tween:Boolean = true):void
		{
			v = Number(v);
			if (_data && v == data)
				return;
				
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
		
		public override function set data(v : *):void
		{
			setValue(v);
		}
		
		public override function get data():*
		{
			return Number(_data);
		}
		
		private var _displayValue:Number;
		
		public function get displayValue():Number
		{
			return _displayValue;
		}
		
		public function set displayValue(v:Number):void
		{
			_displayValue = v;
			
			if (textField)
				textField.text = v.toFixed(fix);
			
			if (enabledAdjustTextSize)
				TextFieldUtil.adjustSize(textField);
			
			if (enabledAdjustContextSize)
				adjustContextSize();
			
			if (asBitmap)
				reRenderBitmap();
		}
		
	}
}