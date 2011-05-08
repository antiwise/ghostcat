package ghostcattools.util
{
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import spark.components.TextArea;

	public final class TextControl
	{
		static public function createTextLayoutFormat(values:Object):TextLayoutFormat
		{
			var tf:TextLayoutFormat = new TextLayoutFormat();
			for (var p:String in values)
			{
				tf[p] = values[p];
			}
			return tf 
		}
		
		static public function setTextAreaDefaultFromat(textArea:TextArea,values:Object = null):void
		{
			textArea.setFormatOfRange(createTextLayoutFormat(values),textArea.text.length - 1,textArea.text.length);
		}
		
		static public function appendText(textArea:TextArea,text:String,values:Object = null):void
		{
			textArea.appendText(text);
			textArea.setFormatOfRange(createTextLayoutFormat(values),textArea.text.length - text.length,textArea.text.length);
		}
	}
}