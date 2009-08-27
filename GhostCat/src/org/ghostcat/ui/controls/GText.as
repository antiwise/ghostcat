package org.ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.display.GBase;
	import org.ghostcat.events.TextFieldEvent;
	import org.ghostcat.parse.display.TextFieldParse;
	import org.ghostcat.text.TextFieldUtil;
	import org.ghostcat.util.Geom;
	import org.ghostcat.util.SearchUtil;
	import org.ghostcat.util.Util;
	
	/**
	 * 显示文字用
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
		 * 是否让容器适应文本框的体积
		 */
		public var adjustSize:Boolean = false;
		
		/**
		 * 限定输入内容的正则表达式
		 */
		public var regExp:RegExp;
		
		private var _bitmap:Bitmap;//用于缓存的Bitmap
		
		private var _asBitmap:Boolean = false;
		
		public function GText(skin:DisplayObject=null, replace:Boolean=true, asBitmap:Boolean = false)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
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
				textField = TextFieldParse.createTextField("");
			else
			{
				var pos:Point = new Point(textField.x,textField.y);
				Geom.localToContent(pos,content,this);
			
				textField.x = pos.x;
				textField.y = pos.y;
			}
			addChild(textField);
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
		
		public function adjustTextSize():void
		{
			TextFieldUtil.adjustSize(textField);
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
			
			if (str!=null && textField){
				if (str.indexOf("<html>") != -1){
					textField.htmlText = str;
				}else{
					textField.text = str;
				}
			}
			
			if (adjustSize)
				adjustTextSize();
			
			if (asBitmap)
				reRenderBitmap();
			
			dispatchEvent(Util.createObject(new TextFieldEvent(TextFieldEvent.TEXT_CHANGE),{textField:textField}))
			
			super.data = str;
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
			if (regExp && !regExp.test(textField.text))
				event.preventDefault();
		}
		
		public override function destory() : void
		{
			super.destory();
			
			if (_bitmap)
				_bitmap.bitmapData.dispose();
		}
		
	}
}