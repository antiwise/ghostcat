package 
{
	import flash.display.Sprite;
	
	import org.ghostcat.bitmap.Reflector;
	import org.ghostcat.display.transfer.Skew;
	
	[SWF(width="300",height="300")]
	public class SkewExample extends Sprite
	{
		public var p:Sprite;
		public var f:Skew;
		public function SkewExample()
		{
			var p:Sprite = new TestRepeater();
			addChild(p);
			f = new Skew(p,5,5);
			addChild(f);
			
			f.setTransform(0,0,5,5,10,10,20,20);
		}
	}
}