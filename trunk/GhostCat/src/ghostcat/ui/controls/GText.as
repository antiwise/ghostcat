package ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import ghostcat.display.GBase;
	import ghostcat.events.GTextEvent;
	import ghostcat.manager.FontManager;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.text.TextFieldUtil;
	import ghostcat.text.TextUtil;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.Geom;
	import ghostcat.util.SearchUtil;
	import ghostcat.util.Util;
	
	[Event(name="text_change",type="ghostcat.events.GTextEvent")]
	
	/**
	 * 文本框
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	public class GText extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(TextField);
		public static var defaultTextFormat:String;
		
		private var _textFormat:String;
		/**
		 * 包含的TextField。此属性会在设置皮肤时自动设置成搜索到的第一个TextField。 
		 */		
		public var textField:TextField;
		
		/**
		 * 是否让文本框适应文字的体积
		 */
		public var enabledAdjustTextSize:Boolean = true;
		
		/**
		 * 自动创建的TextField的初始位置（如果是从skin中创建，此属性无效）
		 */
		public var textPos:Point = new Point();
		
		/**
		 * 是否将文本从Skin中剥离。剥离后Skin缩放才不会影响到文本的正常显示
		 */
		public var separateTextField:Boolean = false;
		
		/**
		 * 是否自动根据文本调整Skin体积。当separateTextField为false时，此属性无效。
		 */
		public var enabledAdjustContextSize:Boolean = false;
		
		/**
		 * 限定输入内容的正则表达式
		 */
		public var regExp:RegExp;
		
		/**
		 * 文字是否竖排
		 */		
		public var vertical:Boolean = false;
		
		/**
		 * ANSI的最大输入限制字数（中文算两个字）
		 */
		public var ansiMaxChars:int;
		
		/**
		 * 字体
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
					textField.defaultTextFormat = f;
			}
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
		}
		
		private var _editable:Boolean;
		
		private var _bitmap:Bitmap;//用于缓存的Bitmap
		
		private var _asBitmap:Boolean = false;
		
		public function GText(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPos:Point=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (textPos)
				this.textPos = textPos;
			
			this.separateTextField = separateTextField;
			
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
				this.separateTextField = true;
				textField = TextFieldParse.createTextField("");
			
				if (textPos)
				{
					textField.x = textPos.x;
					textField.y = textPos.y;
				}
				addChild(textField);
			}
			else
			{
				var pos:Point = new Point(textField.x,textField.y);
				Geom.localToContent(pos,content,this);
			
				textField.x = pos.x;
				textField.y = pos.y;
			
				if (this.separateTextField)
					addChild(textField);//可缩放背景必须提取文本框
			}
			
			if (!textFormat)
				textFormat = defaultTextFormat;
			else
				textFormat = textFormat;
			
			this.text = textField.text;
			
			textField.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			textField.addEventListener(FocusEvent.FOCUS_IN,textFocusInHandler);
			textField.addEventListener(FocusEvent.FOCUS_OUT,textFocusOutHandler);
			textField.addEventListener(KeyboardEvent.KEY_DOWN,textKeyDownHandler);
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
		
		public function adjustContextSize():void
		{
			if (content)
			{
				var rect:Rectangle = getBounds(this);
				content.width = textField.width - rect.x;
				content.height = textField.height - rect.y;
			}
		}

		public override function set data(v:*):void
		{
			if (v == super.data)
				return;
			
			var str:String;
			if (!v)
				str = "";
			else
				str = v.toString();
			
			super.data = str;
		
			if (this.vertical)
				str = TextUtil.vertical(str);
			
			
			if (textField){
				if (str.indexOf("<html>") != -1)
					textField.htmlText = str;
				else
					textField.text = str;
			}
			
			if (enabledAdjustTextSize)
				TextFieldUtil.adjustSize(textField);
			
			if (enabledAdjustContextSize)
				adjustContextSize();
			
			if (asBitmap)
				reRenderBitmap();
			
			dispatchEvent(Util.createObject(new GTextEvent(GTextEvent.TEXT_CHANGE),{gText:this}));//只在设置属性的时候才替换语言，而不是文本变化时就换
		}
		
		/**
		 * 将TextField替换成Bitmap，以实现设备文本的平滑旋转缩放效果
		 * 
		 */		
		
		public function set asBitmap(v:Boolean):void
		{
			if (v){
				textField.visible = false;
				reRenderBitmap();	
			}else{
				textField.visible = true;
				if (_bitmap){
					_bitmap.bitmapData.dispose();
					_bitmap.parent.removeChild(_bitmap);
					_bitmap = null;
				}
			}
		}
		
		public function get asBitmap():Boolean
		{
			return _asBitmap;
		}
		
		/**
		 * 更新位图文字
		 * 
		 */			
		public function reRenderBitmap():void
		{
			if (!_bitmap){
				_bitmap = new Bitmap(new BitmapData(textField.width,textField.height,true,0x00FFFFFF));
				_bitmap.x = textField.x;
				_bitmap.y = textField.y;
				textField.parent.addChild(_bitmap);
			}
			
			_bitmap.bitmapData.draw(textField);
		}
		
		private function getANSILength(data:String):int
  		{
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte(data,"gb2312");
			return byte.length;
  		}
		
		protected function textInputHandler(event:TextEvent):void
		{
			if (regExp && !regExp.test(textField.text + event.text))
				event.preventDefault();
			
			if (ansiMaxChars && getANSILength(textField.text + event.text) > ansiMaxChars)
				event.preventDefault();
		}
		
		protected function textFocusInHandler(event:Event):void
		{
			if (autoSelect)
				textField.setSelection(0,textField.length);
		}
		
		protected function textFocusOutHandler(event:Event):void
		{
			
		}
		
		protected function textKeyDownHandler(event:KeyboardEvent):void
		{
			
		}
		
		public override function destory() : void
		{
			super.destory();
			
			if (_bitmap)
				_bitmap.bitmapData.dispose();
				
			if (textField)
			{
				textField.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
				textField.removeEventListener(FocusEvent.FOCUS_IN,textFocusInHandler);
				textField.removeEventListener(FocusEvent.FOCUS_OUT,textFocusOutHandler);
				textField.removeEventListener(KeyboardEvent.KEY_DOWN,textKeyDownHandler);
				removeChild(textField);
			}
		}
		
	}
}