package ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import ghostcat.display.GBase;
	import ghostcat.manager.FontManager;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.text.TextFieldUtil;
	import ghostcat.text.TextUtil;
	import ghostcat.text.UBB;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.Geom;
	import ghostcat.util.display.MatrixUtil;
	import ghostcat.util.display.SearchUtil;
	
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * 文本框
	 * 
	 * 标签规则：内容将作为背景存在，以内部找到的第一个TextField为标准，否则重新创建
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	public class GText extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(TextField,{autoSize:TextFieldAutoSize.LEFT});
		public static var defaultTextFormat:String;
		/**
		 * 文本改变时的回调函数 
		 */
		public static var textChangeHandler:Function;
		
		/**
		 * 将它设置为true，将通过外部嵌入字体，否则使用SWF内的字体
		 */
		public static var autoRebuildEmbedText:Boolean = false;
		
		/**
		 * 字体替换 
		 */
		public static var fontFamilyReplacer:Object;
		
		private var _textFormat:String;
		private var _autoSize:String = TextFieldAutoSize.NONE;
		private var _separateTextField:Boolean = false;
		
		/**
		 * 包含的TextField。此属性会在设置皮肤时自动设置成搜索到的第一个TextField。 
		 */		
		public var textField:TextField;
		
		/**
		 * 自动创建的TextField的初始位置（如果是从skin中创建，此属性无效）
		 */
		public var textPadding:Padding;
		
		/**
		 * 是否自动根据文本调整Skin体积。当separateTextField为false时，此属性无效。
		 * 要正确适应文本，首先必须在创建时将separateTextField参数设为true，其次可以根据textPadding来决定边距
		 */
		public var enabledAdjustContextSize:Boolean = false;
		
		/**
		 * 是否激活多语言 
		 */
		public var enabledLangage:Boolean = true;
		
		/**
		 * 是否激活截断文本
		 */
		public var enabledTruncateToFit:Boolean = false;
		
		/**
		 * 限定输入内容的正则表达式
		 */
		public var regExp:RegExp;
		
		/**
		 * 在输入文字的时候也发布Change事件
		 */
		public var changeWhenInput:Boolean = false;
		
		/**
		 * 文字是否竖排
		 */		
		public var vertical:Boolean = false;
		
		/**
		 * ANSI的最大输入限制字数（中文算两个字）
		 */
		public var ansiMaxChars:int;
		
		/**
		 * 是否强制使用HTML文本
		 */
		public var useHtml:Boolean = false;
		
		/**
		 * 是否转换UBB（只在HTML文本中有效）
		 */
		public var ubb:Boolean = false;
		
		/**
		 * 是否将文本从Skin中剥离。剥离后Skin缩放才不会影响到文本的正常显示
		 */
		public function get separateTextField():Boolean
		{
			return _separateTextField;
		}
		
		public function set separateTextField(v:Boolean):void
		{
			_separateTextField = v;
			
			if (textField)
			{
				if (v)
				{
					var m:Matrix = MatrixUtil.getMatrixAt(textField,this);
					if (m)
						textField.transform.matrix = m;
					addChild(textField);
				}
			}
		}
		
		/**
		 * 文本框自适应文字的方式
		 */
		public function get autoSize():String
		{
			return textField ? textField.autoSize : _autoSize;
		}

		public function set autoSize(v:String):void
		{
			_autoSize = v;
			if (textField)
				textField.autoSize = v;
		}
		
		/**
		 * 让文本框适应文本大小
		 * @return 
		 * 
		 */
		public function enabledAutoLayout(padding:Padding,autoSize:String = TextFieldAutoSize.LEFT):void
		{
			this.separateTextField = true;
			
			this.textPadding = padding;
			this.enabledAdjustContextSize = true;
			this.autoSize = autoSize;
			
			this.adjustContextSize();
		}
		
		/**
		 * 字体名称
		 */
		public function get textFormat():String
		{
			return _textFormat;
		}

		public function set textFormat(v:String):void
		{
			_textFormat = v;
			if (textField && v)
			{
				var f:TextFormat = FontManager.instance.getTextFormat(v);
				if (f)
					applyTextFormat(f,true);
			}
		}
		
		/**
		 * 应用字体样式
		 * 
		 * @param f	为空则取默认字体样式
		 * @param overwriteDefault	是否覆盖默认字体样式
		 * 
		 */
		public function applyTextFormat(f:TextFormat=null,overwriteDefault:Boolean = false):void 
		{
			if (!textField)
				return;
			
			if (!f)
				f = textField.defaultTextFormat;
			
			if (textField.length > 0)
				textField.setTextFormat(f,0,textField.length);
			
			if (overwriteDefault)
				textField.defaultTextFormat = f;
			
			if (asTextBitmap)
				reRenderTextBitmap();
		}
		
		/**
		 * 设置字体样式 
		 * @param f
		 * 
		 */
		public function setTextFormat(f:TextFormat,beginIndex:int = -1,endIndex:int = -1):void
		{
			if (!textField)
				return;
			
			textField.setTextFormat(f,beginIndex,endIndex);
			
			if (asTextBitmap)
				reRenderTextBitmap();
		}


		/**
		 * 最大输入限制字数
		 *  
		 * @return 
		 * 
		 */
		public function get maxChars():int
		{
			return textField ? textField.maxChars : 0;
		}

		public function set maxChars(v:int):void
		{
			if (textField)
				textField.maxChars = v;
		}
		
		/**
		 * 编辑时是否自动全选
		 */
		public var autoSelect:Boolean

		/**
		 * 可编辑
		 * @return 
		 * 
		 */
		public function get editable():Boolean
		{
			return textField.type == TextFieldType.INPUT;
		}

		public function set editable(v:Boolean):void
		{
			textField.type = v ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			textField.mouseEnabled = v;
		}
		
		/**
		 * 是否可选
		 * 
		 */
		public function get selectable():Boolean
		{
			return textField.selectable;
		}
		
		public function set selectable(v:Boolean):void
		{
			textField.selectable = textField.mouseEnabled = v;
		}
		
		/**
		 * 是否多行显示（可激活回车换行） 
		 * @return 
		 * 
		 */
		public function get multiline():Boolean
		{
			return textField.multiline;
		}
		
		public function set multiline(v:Boolean):void
		{
			textField.multiline = v;
		}
		
		private var _editable:Boolean;
		
		/**
		 * 用于缓存的Bitmap
		 */
		protected var textBitmap:Bitmap;
		
		private var _asTextBitmap:Boolean;
		
		public function GText(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (textPadding)
				this.textPadding = textPadding;
			
			this._separateTextField = separateTextField;
			
			super(skin, replace);
		}
		
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			getTextFieldFromSkin(this.skin);
		}
		
		/**
		 * 从skin中获得TextField对象，没有则自己创建。
		 * 
		 * @param skin
		 * 
		 */
		protected function getTextFieldFromSkin(skin:DisplayObject):void
		{
			if (textField)
			{
				textField.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
				textField.removeEventListener(FocusEvent.FOCUS_IN,textFocusInHandler);
				textField.removeEventListener(FocusEvent.FOCUS_OUT,textFocusOutHandler);
				textField.removeEventListener(KeyboardEvent.KEY_DOWN,textKeyDownHandler);
				if (textField.parent == this)
					this.removeChild(textField);
			}
			
			textField = SearchUtil.findChildByClass(skin,TextField) as TextField;
			
			if (!textField)
			{
				textField = TextFieldParse.createTextField();
				addChild(textField);
				
				this._separateTextField = true;
				
				if (textPadding)
					textPadding.adjectRect(textField,this);
			}
			else
			{
				if (autoRebuildEmbedText && textField.embedFonts)//如果需要用Embed标签来定义嵌入字体，则必须重新创建文本框
					rebuildTextField();
				
				if (this._separateTextField)
					separateTextField = true;//提取文本框
			}
			
			this.textFormat = textFormat ? textFormat : defaultTextFormat;//应用字体样式（如果有）
			var oldFont:TextFormat = this.textField.defaultTextFormat;//替换字体
			if (fontFamilyReplacer && fontFamilyReplacer[oldFont.font])
			{
				oldFont.font = fontFamilyReplacer[oldFont.font]
				this.textField.defaultTextFormat = oldFont;
			}
			
			if (!this.text)
				super.data = textField.text;
			
			doWithText(this.text);
			
			textField.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			textField.addEventListener(FocusEvent.FOCUS_IN,textFocusInHandler);
			textField.addEventListener(FocusEvent.FOCUS_OUT,textFocusOutHandler);
			textField.addEventListener(KeyboardEvent.KEY_DOWN,textKeyDownHandler);
			
			textField.mouseEnabled = false;
		}
		
		/**
		 * 重新创建TextField，执行此方法后，TextField会和代码创建的相同（原本有些细节是不同的）
		 * 
		 */
		public function rebuildTextField():void
		{
			this.textField = TextFieldUtil.clone(this.textField,true);//将TextField重新创建避免出现显示错误
		}
		
		/**
		 * 当此属性包含<html>标签时，将作为html文本处理
		 * @return 
		 * 
		 */		
		
		public function get text():String
		{
			return data as String;
		}

		public function set text(v:String):void
		{
			data = v;
		}
		
		/**
		 * 当前文本 
		 * @return 
		 * 
		 */
		public function get curText():String
		{
			return textField ? textField.text : null;
		}
		
		/**
		 * 设置格式文本 
		 * @param v
		 * 
		 */
		public function set htmlText(v:String):void
		{
			data = "<html>"+v+"</html>"
		}
		
		/**
		 * 根据文本框更新图形大小
		 * 
		 */
		public function adjustContextSize():void
		{
			if (content)
			{
				if (textPadding)
				{
					textPadding.invent().adjectRectBetween(content,textField);
				}
				else
				{
					var rect:Rectangle = getBounds(this);
					content.width = textField.width - rect.x;
					content.height = textField.height - rect.y;
				}
			}
		}
		
		/**
		 * 根据文本框大小截断文本 
		 * 
		 */
		public function truncateToFit(showToolTip:Boolean = true):void
		{
			if (TextFieldUtil.truncateToFit(textField) && showToolTip)
				this.toolTip = this.text;
		}
		
		/** @inheritDoc*/
		public override function set data(v:*):void
		{
			if (v == super.data)
				return;
			
			super.data = v;
			
			doWithText(v);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function doWithText(str:String):void
		{
			if (!str)
				str = "";
			
			if (textChangeHandler != null && enabledLangage)
				str = textChangeHandler(str);
			
			if (this.vertical)
				str = TextUtil.vertical(str);
			
			if (textField)
			{
				if (useHtml || str.indexOf("<html>") != -1)
				{
					if (ubb)
						str = UBB.decode(str);
					
					textField.htmlText = str;
				}
				else
					textField.text = str;
				
				if (enabledTruncateToFit)
					truncateToFit();
				
				if (enabledAdjustContextSize)
					adjustContextSize();
				
				if (asTextBitmap)
					reRenderTextBitmap();
			}
		}
		
		/**
		 * 将TextField替换成Bitmap，以实现设备文本的平滑旋转缩放效果
		 * 
		 */		
		public function set asTextBitmap(v:Boolean):void
		{
			_asTextBitmap = v;
			
			if (v)
			{
				textField.visible = false;
				reRenderTextBitmap();	
			}
			else
			{
				textField.visible = true;
				if (textBitmap)
				{
					textBitmap.bitmapData.dispose();
					textBitmap.parent.removeChild(textBitmap);
					textBitmap = null;
				}
			}
		}
		
		public function get asTextBitmap():Boolean
		{
			return _asTextBitmap;
		}
		
		/**
		 * 更新位图文字
		 * 
		 */			
		public function reRenderTextBitmap():void
		{
			if (textBitmap)
			{
				textBitmap.parent.removeChild(textBitmap);
				textBitmap.bitmapData.dispose();
			}
			
			textBitmap = new Bitmap(new BitmapData(Math.ceil(textField.width),Math.ceil(textField.height),true,0));
			textBitmap.x = textField.x;
			textBitmap.y = textField.y;
			textField.parent.addChild(textBitmap);
			
			textBitmap.bitmapData.draw(textField);
		}
		
		/**
		 * 获得ANSI长度（中文按两个字符计算）
		 * @param data
		 * @return 
		 * 
		 */
		private function getANSILength(data:String):int
  		{
			return TextUtil.getANSILength(data);
		}
		
		/**
		 * 键入文字事件 
		 * @param event
		 * 
		 */
		protected function textInputHandler(event:TextEvent):void
		{
			if (regExp && !regExp.test(textField.text + event.text))
				event.preventDefault();
			
			if (ansiMaxChars && getANSILength(textField.text + event.text) > ansiMaxChars)
				event.preventDefault();
			
			if (changeWhenInput)
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 文件焦点事件 
		 * @param event
		 * 
		 */
		protected function textFocusInHandler(event:Event):void
		{
			if (autoSelect)
				textField.setSelection(0,textField.length);
		}
		
		protected function textFocusOutHandler(event:Event):void
		{
			if (editable)
				this.data = textField.text;
		}
		
		protected function textKeyDownHandler(event:KeyboardEvent):void
		{
			
		}
		
		/** @inheritDoc*/
		protected override function updateSize():void
		{
			super.updateSize();
			
			if (textPadding)
				textPadding.adjectRect(textField,this);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (textBitmap)
				textBitmap.bitmapData.dispose();
				
			if (textField)
			{
				textField.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
				textField.removeEventListener(FocusEvent.FOCUS_IN,textFocusInHandler);
				textField.removeEventListener(FocusEvent.FOCUS_OUT,textFocusOutHandler);
				textField.removeEventListener(KeyboardEvent.KEY_DOWN,textKeyDownHandler);
				if (textField.parent == this)
					removeChild(textField);
			}
			
			super.destory();
		}
		
	}
}