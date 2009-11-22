package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import ghostcat.display.transfer.Cataclasm;

	[SWF(width="600",height="600")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends Sprite
	{
		[Embed("p3.jpg")]
		public var c:Class;
		public function TestExample()
		{
			var t:Bitmap = new c();
			addChild(t);
			
			var s:Cataclasm = new Cataclasm(t);
			addChild(s);
		}
	}
}