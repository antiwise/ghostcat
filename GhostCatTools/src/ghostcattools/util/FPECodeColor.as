package ghostcattools.util
{
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import ghostcat.util.code.CodeColor;
	
	import spark.components.TextArea;

	public final class FPECodeColor
	{
		static public function parse(sourceText:TextArea):void
		{
			var colors:Object = CodeColor.colors;
			
			var textLayoutFormat:TextLayoutFormat = new TextLayoutFormat(sourceText.textFlow.computedFormat);
			sourceText.setFormatOfRange(textLayoutFormat,0,sourceText.text.length);
			
			for (var p:String in colors)
			{
				var regExp:RegExp = new RegExp(colors[p],"gm");
				textLayoutFormat.color = parseInt(p,16);
				do
				{
					var result:Object = regExp.exec(sourceText.text);
					if (result)
					{
						var index:int = result.index;
						var len:int = result[0].length;
						sourceText.setFormatOfRange(textLayoutFormat,index,index + len);
					}
				}
				while (result);
			}
		}
	}
}