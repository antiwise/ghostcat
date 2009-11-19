package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.display.transfer.Boob;

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
			
			var b:Boob = new Boob(t,new Rectangle(330,390,80,80));
			addChild(b);
		}
	}
}