package org.ghostcat.parse.display
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.ghostcat.parse.DisplayParse;

	public class TextFieldParse extends DisplayParse
	{
		public var text:String;
		public var pos:Point;
		public var defaultTextFormat:TextFormat;
		
		public function TextFieldParse(text:String,pos:Point=null,defaultTextFormat:TextFormat=null)
		{
			this.text = text;
			this.pos = pos;
			this.defaultTextFormat = defaultTextFormat;
		}
		
		protected override function parseContainer(target:DisplayObjectContainer) : void
		{
			super.parseContainer(target);
			target.addChild(createTextField());
		}
		
		public function createTextField():TextField
		{
			if (!defaultTextFormat)
				defaultTextFormat = new TextFormat("宋体",12);
			var textField:TextField = new TextField();
			textField.defaultTextFormat = defaultTextFormat;
			textField.selectable = false;
			if (text.indexOf("<html>"))
				textField.htmlText = text;
			else
				textField.text = text;
			if (pos)
			{
				textField.x = pos.x;
				textField.y = pos.y;
			}
			return textField;
		}
		
		public static function createTextField(text:String,pos:Point=null,defaultTextFormat:TextFormat=null):TextField
		{
			var p:TextFieldParse = new TextFieldParse(text,pos,defaultTextFormat);
			return p.createTextField();
		}
	}
}