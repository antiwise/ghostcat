package ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import ghostcat.display.GBase;
	import ghostcat.events.GTextEvent;
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

		private var _bitmap:Bitmap;//用于缓存的Bitmap
		
		private var _asBitmap:Boolean = false;
		
		private var enabledAdjustContextSize:Boolean = false;//是否自动根据文本调整图元体积。如果为真，将会把TextField中皮肤中提出。
		
		public function GText(skin:*=null, replace:Boolean=true, enabledAdjustContextSize:Boolean = false, textPos:Point=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (textPos)
				this.textPos = textPos;
			
			this.enabledAdjustContextSize = enabledAdjustContextSize;
			
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
		private function getTextFieldFromSkin(skin:DisplayObject):void
		{
			if (textField)
			{
				textField.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
				if (textField.parent == this)
					this.removeChild(textField);
			}
			
			textField = SearchUtil.findChildByClass(skin,TextField) as TextField;
			
			if (!textField)
			{
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
			
				if (this.enabledAdjustContextSize)
					addChild(textField);//可缩放背景必须提取文本框
			}
			this.text = textField.text;
			
			textField.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
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
		
		public override function get data():*
		{
			return super.data;
		}

		public override function set data(v:*):void
		{
			if (v == super.data)
				return;
			
			var str:String = v as String;
			
			super.data = str;
		
			if (this.vertical)
				str = TextUtil.vertical(str);
			
			if (str!=null && textField){
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
			
			dispatchEvent(Util.createObject(new GTextEvent(GTextEvent.TEXT_CHANGE),{gText:this}))
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
		
		public override function destory() : void
		{
			super.destory();
			
			if (_bitmap)
				_bitmap.bitmapData.dispose();
				
			if (textField)
			{
				textField.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
				removeChild(textField);
			}
		}
		
	}
}