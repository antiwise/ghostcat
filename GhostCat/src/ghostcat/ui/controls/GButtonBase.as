package ghostcat.ui.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.events.ActionEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.core.AbstractUtil;
	
	/**
	 * 带Label按钮
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GButtonBase extends GButtonLite
	{
		public static const LABEL_UP:String = "up";
		public static const LABEL_OVER:String = "over";
		public static const LABEL_DOWN:String = "down";
		public static const LABEL_DISABLED:String = "disabled";
		public static const LABEL_SELECTED_UP:String = "selectedUp";
		public static const LABEL_SELECTED_OVER:String = "selectedOver";
		public static const LABEL_SELECTED_DOWN:String = "selectedDown";
		public static const LABEL_SELECTED_DISABLED:String = "selectedDisabled";
		private var _autoRefreshLabelField:Boolean = true;
		
		/**
		 * Label文本实例 
		 */
		public var labelTextField:GText;
		
		/**
		 * data中显示成label的字段
		 */
		public var labelField:String;
		
		/**
		 * 是否创建Label文本框（此属性已取消，必须用GButtonBase构造函数的第5个参数来设置）
		 */
		public function get autoRefreshLabelField():Boolean
		{
			return _autoRefreshLabelField;
		}
		
		public function set autoRefreshLabelField(v:Boolean):void
		{
			throw new Error("GButtonBase的autoRefreshLabelField属性已失效，必须用构造函数的第5个参数来设置");
		}
		
		/**
		 * 根据文本框更新图形大小
		 * 
		 */
		public function adjustContextSize():void
		{
			if (labelTextField)
				labelTextField.adjustContextSize();
		}
		
		/**
		 * 删除Label文本框 
		 * 
		 */
		public function removeLabelTextField():void
		{
			if (labelTextField)
			{
				labelTextField.destory();
				labelTextField = null;
			}
		}
		
		/**
		 * 是否自动根据文本调整Skin体积。当separateTextField为false时，此属性无效。
		 * 要正确适应文本，首先必须在创建时将separateTextField参数设为true，其次可以根据textPadding来决定边距
		 */
		public function get enabledAdjustContextSize():Boolean
		{
			return labelTextField ? labelTextField.enabledAdjustContextSize : false;
		}

		public function set enabledAdjustContextSize(value:Boolean):void
		{
			if (labelTextField)
				labelTextField.enabledAdjustContextSize = value;
		}
		
		
		/**
		 * 动态创建的TextField的初始位置（如果是从skin中创建，此属性无效）
		 */
		public function get textStartPoint():Point
		{
			return labelTextField ? labelTextField.textStartPoint : null;
		}

		public function set textStartPoint(value:Point):void
		{
			if (labelTextField)
				labelTextField.textStartPoint = value;
		}
		
		
		/**
		 * 文本自适应边距 
		 * @return 
		 * 
		 */
		public function get textPadding():Padding
		{
			return labelTextField ? labelTextField.textPadding : null;
		}
		
		public function set textPadding(value:Padding):void
		{
			if (labelTextField)
				labelTextField.textPadding = value;
		}
		
		/**
		 * Label自动大小
		 */
		public function get autoSize():String
		{
			return labelTextField ? labelTextField.autoSize : null;
		}

		public function set autoSize(value:String):void
		{
			if (labelTextField)
				labelTextField.autoSize = value;
		}
		
		/**
		 * 是否将文本从Skin中剥离。剥离后Skin缩放才不会影响到文本的正常显示
		 */
		public function get separateTextField():Boolean
		{
			return labelTextField ? labelTextField.separateTextField : false;
		}
		
		public function set separateTextField(v:Boolean):void
		{
			if (labelTextField)
				labelTextField.separateTextField = v;
		}
		
		/**
		 * 自动截取文本 
		 * @return 
		 * 
		 */
		public function get enabledTruncateToFit():Boolean
		{
			return labelTextField ? labelTextField.enabledTruncateToFit : false;
		}
		
		public function set enabledTruncateToFit(v:Boolean):void
		{
			if (labelTextField)
				labelTextField.enabledTruncateToFit = v;
		}
		
		/**
		 * 文本是否垂直居中
		 */
		public function get enabledVerticalCenter():Boolean
		{
			return labelTextField ? labelTextField.enabledVerticalCenter : false;
		}
		
		public function set enabledVerticalCenter(v:Boolean):void
		{
			if (labelTextField)
				labelTextField.enabledVerticalCenter = v;
		}
		
		/**
		 * 激活文本自适应
		 * 
		 * 文本原左上坐标不变，向右下扩展。背景根据Padding调整到位置。
		 * 
		 */
		public function enabledAutoLayout(padding:Padding,autoSize:String = TextFieldAutoSize.LEFT):void
		{
			if (labelTextField)
				labelTextField.enabledAutoLayout(padding,autoSize);
		}
		
		/**
		 * 
		 * @param skin	皮肤
		 * @param replace	是否替换
		 * @param separateTextField	是否将原本的文本框内容提出到contant外（历史原因一般保持默认值）
		 * @param textPadding	设置文本自适应位置（历史原因一般保持默认值）
		 * @param autoRefreshLabelField	是否创建Label的TextField，为真时有可能会影响皮肤内部的GText对象。
		 * 
		 */
		public function GButtonBase(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null, autoRefreshLabelField:Boolean = true)
		{
			this._autoRefreshLabelField = autoRefreshLabelField;
			
			super(skin, replace);
			
			this.separateTextField = separateTextField;
			this.textPadding = textPadding;
		}
		
		/**
		 * Label文字 
		 * @return 
		 * 
		 */
		public function get label():String
		{
			return labelField ? data[labelField] : (data is String || data is Number) ? data : null;
		}

		public function set label(v:String):void
		{
			if (labelField)
			{
				if (super.data == null)
					super.data = new Object();
					
				super.data[labelField] = v;
			}
			else
				data = v;
		}
		/** @inheritDoc*/
		public override function set data(v:*) : void
		{
			super.data = v;
			
			if (label != null)
			{
				if (labelTextField && _autoRefreshLabelField)
					labelTextField.text = label;
			}
		} 
		
		/**
		 * 更新label
		 * 
		 */
		public function refreshLabelField():void
		{
			if (labelTextField)
			{
				//复制原属性
				var newText:GText = new GText(content,false,separateTextField,textPadding);
				newText.enabledAdjustContextSize = enabledAdjustContextSize;
				newText.enabledTruncateToFit = enabledTruncateToFit;
				newText.enabledVerticalCenter = enabledVerticalCenter;
				newText.autoSize = autoSize;
				
				labelTextField.destory();
				labelTextField = newText;
			}
			else
			{
				labelTextField = new GText(content,false);
			}
			
			if (!labelTextField.parent)
				addChild(labelTextField)
			
			if (label != null)
				labelTextField.text = label;
		}
				
		/**
		 * 设置单个状态 
		 * @param skin
		 * @param replace
		 * 
		 */
		public override function setPartContent(skin:*, replace:Boolean=true):void
		{
			super.setPartContent(skin,replace);
			
			if (_autoRefreshLabelField)
				refreshLabelField();
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (labelTextField)
				labelTextField.destory();
			
			super.destory();
		}
	}
}