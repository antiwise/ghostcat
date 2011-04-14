package ghostcat.display.fte
{
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;

	public class FTEHelper
	{
		public static function createTextLine(text:String,format:ElementFormat = null,textRotation:String = "rotate0"):TextLine
		{
			return new TextBlock(new TextElement(text,format,null,textRotation)).createTextLine();
		}
	}
}