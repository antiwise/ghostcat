package ghostcat.parse.display
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.text.TextFieldUtil;

	/**
	 * 文本框 
	 * @author flashyiyi
	 * 
	 */
	public class TextFieldParse extends DisplayParse
	{
		/**
		 * 文字 
		 */
		public var text:String;
		/**
		 * 偏移量
		 */
		public var pos:Point;
		/**
		 * 默认字体 
		 */
		public var defaultTextFormat:TextFormat;
		
		public function TextFieldParse(text:String,pos:Point=null,defaultTextFormat:TextFormat=null)
		{
			this.text = text;
			this.pos = pos;
			this.defaultTextFormat = defaultTextFormat;
		}
		/** @inheritDoc*/
		public override function parseContainer(target:DisplayObjectContainer) : void
		{
			super.parseContainer(target);
			target.addChild(createTextField());
		}
		
		/**
		 * 创建文本框 
		 * @return 
		 * 
		 */
		public function createTextField():TextField
		{
			if (!defaultTextFormat)
				defaultTextFormat = new TextFormat("宋体",12);
			var textField:TextField = new TextField();
			textField.defaultTextFormat = defaultTextFormat;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			if (text.indexOf("<html>") != -1)
				textField.htmlText = text;
			else
				textField.text = text;
			if (pos)
			{
				textField.x = pos.x;
				textField.y = pos.y;
			}
			TextFieldUtil.adjustSize(textField);
			return textField;
		}
		
		/**
		 * 创建文本框 
		 * @param text
		 * @param pos
		 * @param defaultTextFormat
		 * @return 
		 * 
		 */
		public static function createTextField(text:String="",pos:Point=null,defaultTextFormat:TextFormat=null):TextField
		{
			var p:TextFieldParse = new TextFieldParse(text,pos,defaultTextFormat);
			return p.createTextField();
		}
	}
}