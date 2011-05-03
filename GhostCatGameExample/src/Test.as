package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import ghostcat.fileformat.csv.CSVDecoder;
	import ghostcat.manager.GBindingManager;
	
	public class Test extends Sprite 
	{
		public function Test()
		{
			CSVDecoder.decode();
		}
		
	}
}