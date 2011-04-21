package ghostcat.util.code
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	
	public class CodeColor extends EventDispatcher
	{
		public var colors:Object = {
			"#FF00FF":/\b(package|class)\b/g,
			"#0000FF":/\b(import|public|private|protected|extends|in)\b/g,
			"#00FF00":/\b(function)\b/g,
			"#000080":/\b(var)\b/g,
			"#FF0000":/'[^'].*?'/g
		}
		public function CodeColor()
		{
		}
		
		public function parse(textField:TextField):void
		{
			var html:String = textField.text;
			for (var p:String in colors)
			{
				html = html.replace(RegExp(colors[p]),"<font color=\"" + p + "\">$1</font>");
			}
			textField.htmlText = html;
		}
	}
}