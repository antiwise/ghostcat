package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import org.ghostcat.display.GBase;
	import org.ghostcat.text.TextFieldUtil;

	/**
	 * 进度条，滚动条，滑块基类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GPercentBar extends GBase
	{
		public static const MOVIECLIP:int = 0;
		public static const SCALEX:int = 1;
		public static const X:int = 2;
		public static const Y:int = 3;
		
		/**
		 * 最大值
		 */
		public var maxValue:Number = 100;
		
		/**
		 * 最小值
		 */
		public var minValue:Number = 0;
		
		private var _percent:Number = 0.0;
		
		private var thumb:DisplayObject;
		private var labelTextField:TextField;
		
		/**
		 * 取值模式
		 */
		public var mode:int = 0;
		
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
		public function GPercentBar(skin:DisplayObject,replace:Boolean = true,mode:int = 0,fields:Object = null)
		{
			if (fields)
				this.fields = fields;
			this.mode = mode;
		
			super(skin,replace);
			
		}
		
		public override function setContent(skin:DisplayObject, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var mcField:String = this.fields.mcField;
			var labelField:String = this.fields.labelField;
			
			if (content.hasOwnProperty(mcField))
				this.thumb = content[mcField];
				
			if (content.hasOwnProperty(labelField))
				this.labelTextField = content[labelField];
		}
		
		/**
		 * 设置百分比位置
		 * 
		 * @param v
		 * 
		 */
		public function set percent(v:Number):void
		{
			if (!thumb)
				return;
			
			if (_percent == v)
				return;
			
			_percent = v;
			switch (_percent)
			{
				case MOVIECLIP:
					(thumb as MovieClip).gotoAndStop(minValue + v * maxValue);
					break;
				case SCALEX:
					thumb.scaleX = (minValue + v * (maxValue - minValue))/100;
					break;
				case X:
					thumb.x = minValue + v * (maxValue - minValue);
					break;
				case Y:
					thumb.y = minValue + v * (maxValue - minValue);
					break;
			}
		}
		
		public function get percent():Number
		{
			return _percent;
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
			{
				labelTextField.text = v;
				TextFieldUtil.adjustSize(labelTextField)
			}	
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