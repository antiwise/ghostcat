package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import ghostcat.display.GBase;
	import ghostcat.util.easing.TweenUtil;

	/**
	 * 进度条基类
	 * 
	 * 标签规则：子对象thumb是滑块，labelTextField是显示信息的文本
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GPercentBar extends GBase
	{
		/**
		 * 多个模式是直接以value的实际值为准的，所以范围可以由minValue和maxValue调整。但SCALEX,SCALEY模式要除以100，也就是百分率是0-100的范围 
		 */
		public static const MOVIECLIP:String = "movieClip";
		public static const SCALEX:String = "scaleX";
		public static const SCALEY:String = "scaleY";
		public static const X:String = "x";
		public static const Y:String = "y";
		
		/**
		 * 最大值
		 */
		public var maxValue:Number = 100;
		
		/**
		 * 最小值
		 */
		public var minValue:Number = 0;
		
		/**
		 * 缓动持续时间 
		 */
		public var duration:int = 0;
		
		/**
		 * 缓动函数 
		 */
		public var ease:Function;
		
		private var _percent:Number;
		
		/**
		 * 滑块
		 */
		public var thumb:DisplayObject;
		
		/**
		 * 文本框
		 */
		public var labelTextField:TextField;
		
		/**
		 * 取值模式
		 */
		public var mode:String = "scaleX";
		
		/**
		 * 内部元素名称
		 */
		public var fields:Object = {mcField:"thumb",labelField:"labelTextField"};
		
		/**
		 * 
		 * @param skin
		 * @param replace
		 * @param mode	数据模式
		 * @param mcField	动画实例名
		 * @param labelField	标签实例名
		 * 
		 */
		public function GPercentBar(skin:*=null,replace:Boolean = true,mode:String = "scaleX",fields:Object = null)
		{
			if (fields)
				this.fields = fields;
			this.mode = mode;
		
			super(skin,replace);
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean = true) : void
		{
			super.setContent(skin,replace);
			
			if (!content)
				return;
			
			var mcField:String = this.fields.mcField;
			var labelField:String = this.fields.labelField;
			
			if (content.hasOwnProperty(mcField))
				this.thumb = content[mcField];
				
			if (content.hasOwnProperty(labelField))
			{
				this.labelTextField = content[labelField];
				
				if (this.labelTextField.autoSize == TextFieldAutoSize.NONE)
					this.labelTextField.autoSize = TextFieldAutoSize.LEFT;
			}
		}
		
		/**
		 * 百分比位置
		 * 
		 * @param v
		 * 
		 */
		public function set percent(v:Number):void
		{
			setPercent(v);
		}
		
		public function get percent():Number
		{
			return _percent;
		}
		
		
		/**
		 * 设置百分比位置
		 * 
		 * @param v
		 * @param tween	是否使用Tween
		 * @return 
		 * 
		 */
		public function setPercent(v:Number,tween:Boolean = true):void
		{
			if (!thumb)
				return;
			
			if (_percent == v)
				return;
			
			_percent = v;
			
			if (duration > 0)
				TweenUtil.removeTween(thumb);
			
			var v2:Number = minValue + v * (maxValue - minValue);
			
			switch (mode)
			{
				case MOVIECLIP:
					if (duration > 0 && tween)
						TweenUtil.to(thumb,duration,{frame:Math.round(v2),ease:ease});
					else
						(thumb as MovieClip).gotoAndStop(Math.round(v2));
					break;
				case SCALEX:
					if (duration > 0 && tween)
						TweenUtil.to(thumb,duration,{scaleX:v2/100,ease:ease});
					else	
						thumb.scaleX = v2 / 100;
					break;
				case SCALEY:
					if (duration > 0 && tween)
						TweenUtil.to(thumb,duration,{scaleY:v2/100,ease:ease});
					else	
						thumb.scaleY = v2 / 100;
					break;
				case X:
					if (duration > 0 && tween)
						TweenUtil.to(thumb,duration,{x:v2,ease:ease});
					else	
						thumb.x = v2;
					break;
				case Y:
					if (duration > 0 && tween)
						TweenUtil.to(thumb,duration,{y:v2});
					else	
						thumb.y = v2;
					break;
			}
		}
	
		/**
		 * 设置标签信息
		 * 
		 * @param v
		 * 
		 */
		public function set label(v:String):void
		{
			if (labelTextField)
				labelTextField.text = v ? v : "";
		}
		
		public function get label():String
		{
			if (labelTextField)
				return labelTextField.text;
			else
				return null;
		}
	}
}