package ghostcat.util.code
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import ghostcat.util.text.UBB;
	
	/**
	 * 代码着色
	 * @author Administrator
	 * 
	 */
	public class CodeColor extends EventDispatcher
	{
		static public var colors:Object = {
			"9900cc":"\\b(package|interface|class)\\b",
			"0033ff":"\\b(import|static|public|private|protected|extends|const|for|do|while|if|else|new|in|this|void|null)\\b",
			"339966":"\\b(function)\\b",
			"cc6666":"\\b(trace)\\b",
			"6699cc":"\\b(var)\\b",
			"0033ff":"(?<=\\[)\\w*?(?=(\\(.*?\\))?\\])",
			"990000":"(['\"]).*?(?<!\\\\)\\1",
			"3f5fbf":"/\\*.*?\\*/",
			"009900":"//.*\\r"
		}
		
		static public function parse(textField:TextField,colors:Object = null):void
		{
			if (!colors)
				colors = CodeColor.colors;
				
			var html:String = textField.text;
			textField.setTextFormat(new TextFormat(null,null,0));
			for (var p:String in colors)
			{
				var regExp:RegExp = new RegExp(colors[p],"gm");
				do
				{
					var result:Object = regExp.exec(html);
					if (result)
					{
						var index:int = result.index;
						var len:int = result[0].length;
						textField.setTextFormat(new TextFormat(null,null,parseInt(p,16)),index,index + len);
					}
				}
				while (result);
			}
		}
		
		static public function addChangeListener(textField:TextField,colors:Object = null):void
		{
			textField.addEventListener(Event.CHANGE,changeHandler);
			changeHandler(null);
			function changeHandler(e:Event):void
			{
				parse(textField,colors);
			}
		}
	}
}