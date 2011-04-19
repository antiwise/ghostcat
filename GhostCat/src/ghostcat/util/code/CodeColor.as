package ghostcat.util.code
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	
	public class CodeColor extends EventDispatcher
	{
		public var colors:Object = {
			0xFF0000:/(package|class)/g,
			0x0000FF:/import|public|private|protected|in/g
		}
		public function CodeColor()
		{
		}
		
		public function parse(textField:TextField):void
		{
			for (var p:String in colors)
			{
				var result:Array = RegExp(colors[p]).exec(textField.text);
			
			}
		}
	}
}