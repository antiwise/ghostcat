package ghostcat.ui.controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GBox;
	import ghostcat.ui.containers.GView;
	import ghostcat.ui.layout.Padding;
	import ghostcat.ui.layout.PaddingLayout;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.easing.Circ;
	import ghostcat.util.easing.TweenUtil;
	import ghostcat.util.text.NumberUtil;
	import ghostcat.util.text.TextFieldUtil;
	
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
		 * 转换文字函数
		 */
		public var textFunction:Function;
		
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
		 * 显示变化文字
		 */
		public var showOffestTextNum:int = 0;
		
		/**
		 * 变化文字间距
		 */
		public var offestTextGap:int = 0;
		
		/**
		 * 变化文本持续时间
		 */
		public var offestTextShowTime:int = 1000;
		
		/**
		 * 变化文本字体
		 */
		public var offestTextFormat:TextFormat;
		
		/**
		 * 变化文本字体2
		 */
		public var offestTextFormat2:TextFormat;
		
		/**
		 * 变化文本滤镜
		 */
		public var offestTextFilters:Array;
		
		/**
		 * 是否缩放变化文本
		 */
		public var scaleOffestText:Boolean = false;
		/**
		 * 变化文本方向
		 */
		public var offestTextDirect:String = UIConst.DOWN;
		
		protected var offestTexts:Sprite;
		protected var offestValues:Array = [];
		
		/**
		 * 小数点位数
		 */
		public var fix:int = 0;
		
		public function GNumberic(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, replace, separateTextField, textPadding);
		}
		
		/**
		 * 增加值 
		 * @param v
		 * @param tween
		 * 
		 */
		public function addValue(v : Number, tween:Boolean = true):void
		{
			setValue(data + v,tween);
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
			var offest:Number = v - Number(data);
			
			_data = v;
			
			if (tween && !isNaN(displayValue))
			{
				if (offest != 0)
				{
					if (showOffestTextNum)
						addOffestNum(offest);
					
					TweenUtil.removeTween(this,false);
					TweenUtil.to(this,duration,{displayValue:v,ease:easing,onComplete:tweenCompleteHandler})
				}
			}
			else
			{
				tweenCompleteHandler();
			}
		
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function tweenCompleteHandler():void
		{
			displayValue = Number(_data);
		}
		
		/**
		 * 增加变化文本
		 * 
		 */
		public function addOffestNum(v:Number):void
		{
			if (showOffestTextNum)
			{
				offestValues.push(v);
				offestValues = offestValues.slice(Math.max(0,offestValues.length - showOffestTextNum),showOffestTextNum);
			}
			
			refreshOffestTexts();
			setTimeout(removeOffestNum,offestTextShowTime);
		}
		
		//删除一个变化文本
		private function removeOffestNum():void
		{
			offestValues.shift();
			refreshOffestTexts();
		}
		
		/**
		 * 更新变化文本
		 * 
		 */
		public function refreshOffestTexts():void
		{
			if (!offestTexts)
			{
				offestTexts = new Sprite();
				addChild(offestTexts);
			}
			
			DisplayUtil.removeAllChildren(offestTexts);
			
			var prevText:TextField = textField;
			for (var i:int = 0;i < offestValues.length;i++)
			{
				var n:TextField = createOffestTexts(prevText,offestValues[i]);
				offestTexts.addChild(n);
				
				prevText = n;
			}
		}
		
		protected function createOffestTexts(prevText:TextField,v:Number):TextField
		{
			var n:TextField = TextFieldUtil.clone(prevText,false); 
			n.text = (v >= 0 ? "+" : "") + v.toString();
			
			if (offestTextDirect == UIConst.LEFT)
				n.x = prevText.x - n.textWidth - offestTextGap;
			else if (offestTextDirect == UIConst.RIGHT)
				n.x = prevText.x + prevText.textWidth + offestTextGap;
			else if (offestTextDirect == UIConst.UP)
				n.y = prevText.y - n.textHeight - offestTextGap;
			else 
				n.y = prevText.y + prevText.textHeight + offestTextGap;
				
			var tf:TextFormat = n.defaultTextFormat;
			if (v < 0 && offestTextFormat2)
				tf = offestTextFormat2;
			else if (offestTextFormat)
				tf = offestTextFormat;
			
			if (scaleOffestText)
				tf.size = Number(tf.size) * (1 - 1 / (showOffestTextNum + 1));
			n.setTextFormat(tf,0,n.length);
			n.defaultTextFormat = tf;
			if (offestTextFilters)
				n.filters = offestTextFilters;
			n.cacheAsBitmap = true;
			return n;
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
		
		protected var _displayValue:Number;
		/** @inheritDoc*/
		public function get displayValue():Number
		{
			return _displayValue;
		}
		
		public function set displayValue(v:Number):void
		{
			_displayValue = v;
			
			if (textField)
			{
				if (textFunction!=null)
					textField.text = textFunction(v);
				else
					textField.text = prefix + (fix == 0 ? int(v).toString() : v.toFixed(fix)) + suffix;
			}
			
			if (enabledTruncateToFit)
				truncateToFit();
			
			if (enabledAdjustContextSize)
				adjustContextSize();
			
			if (asTextBitmap)
				reRenderTextBitmap();
		}
	}
}