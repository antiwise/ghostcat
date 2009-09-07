package org.ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.ghostcat.display.GBase;
	import org.ghostcat.events.GTextEvent;
	import org.ghostcat.parse.display.TextFieldParse;
	import org.ghostcat.text.ANSI;
	import org.ghostcat.text.TextFieldUtil;
	import org.ghostcat.text.TextUtil;
	import org.ghostcat.util.ClassFactory;
	import org.ghostcat.util.Geom;
	import org.ghostcat.util.SearchUtil;
	import org.ghostcat.util.Util;
	
	[Event(name="text_change",type="org.ghostcat.events.GTextEvent")]
	
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
		 * 是否让容器适应文本框的体积
		 */
		public var enabledAdjustContextSize:Boolean = false;
		
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
		
		public function GText(skin:DisplayObject=null, replace:Boolean=true, asBitmap:Boolean = false, textPos:Point=null)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
			if (textPos)
				this.textPos = textPos;
			
			super(skin, replace);
			
			this.asBitmap = asBitmap;
		}
		
		public override function setContent(skin:DisplayObject, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			getTextFieldFromSkin(skin);
		}
		
		/**
		 * 从skin中获得TextField对象，没有则自己创建。
		 * 
		 * @param skin
		 * 
		 */
		public function getTextFieldFromSkin(skin:DisplayObject):void
		{
			if (textField)
			{
				textField.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
				removeChild(textField);
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
			}
			else
			{
				var pos:Point = new Point(textField.x,textField.y);
				Geom.localToContent(pos,content,this);
			
				textField.x = pos.x;
				textField.y = pos.y;
			}
			addChild(textField);
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
		
		protected function textInputHandler(event:TextEvent):void
		{
			if (regExp && !regExp.test(textField.text + event.text))
				event.preventDefault();
			
			if (ansiMaxChars && ANSI.getLength(textField.text + event.text) > ansiMaxChars)
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